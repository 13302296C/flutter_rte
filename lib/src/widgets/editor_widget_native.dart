import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rich_text_editor/src/models/callbacks.dart';
import 'package:flutter_rich_text_editor/src/models/html_editor_options.dart';
import 'package:flutter_rich_text_editor/src/models/html_toolbar_options.dart';
import 'package:flutter_rich_text_editor/src/widgets/toolbar_widget.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_rich_text_editor/src/controllers/editor_controller.dart';

/// The HTML Editor widget itself, for web (uses IFrameElement)
class HtmlEditorWidget extends StatefulWidget {
  HtmlEditorWidget({
    Key? key,
    required this.controller,
    this.height,
    this.minHeight,
    required this.initBC,
  })  : _viewId = controller.viewId,
        super(key: key);

  final HtmlEditorController controller;
  final double? height;
  final double? minHeight;
  final String _viewId;
  final BuildContext initBC;

  @override
  State<HtmlEditorWidget> createState() => _HtmlEditorWidgetState();
}

class _HtmlEditorWidgetState extends State<HtmlEditorWidget>
    with TickerProviderStateMixin {
  /// Tracks whether the editor was disabled onInit (to avoid re-disabling on reload)
  //bool alreadyDisabled = false;

  Callbacks? get callbacks => widget.controller.callbacks;

  //List<Plugins> get plugins => widget.controller.plugins;

  HtmlEditorOptions get editorOptions => widget.controller.editorOptions!;

  HtmlToolbarOptions get toolbarOptions => widget.controller.toolbarOptions!;

  /// if height if fixed = return fixed height, otherwise return
  /// greatest of `minHeight` and `contentHeight`.
  double get _height =>
      editorOptions.height ??
      widget.height ??
      math.max(
          widget.minHeight ?? 0,
          widget.controller.contentHeight.value +
              (toolbarOptions.toolbarPosition == ToolbarPosition.custom ||
                      !toolbarOptions.fixedToolbar
                  ? 0
                  : (widget.controller.toolbarHeight ?? 0)));

  ///
  bool showToolbar = false;

  ///
  Timer? timer;

  ///
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 350),
    vsync: this,
  );

  ///
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastOutSlowIn,
  );

  @override
  Widget build(BuildContext context) {
    if (widget.controller.toolbarHeight == null) {
      if (widget.controller.isReadOnly) {
        widget.controller.toolbarHeight = 0;
        if (!widget.controller.initialized) {
          widget.controller
              .initEditor(widget.initBC, editorOptions.height ?? _height);
        }
      } else {
        if (!widget.controller.initialized) {
          widget.controller.initEditor(
              widget.initBC, _height - (widget.controller.toolbarHeight ?? 0));
        }
        widget.controller.toolbarHeight = widget.controller.isReadOnly ||
                toolbarOptions.toolbarPosition == ToolbarPosition.custom
            ? 0
            : 51;
      }
    }
    return AnimatedBuilder(
        animation: widget.controller,
        builder: (context, _) {
          // log('======toolbar height = ${widget.controller.toolbarHeight}');
          // log('======content height = ${widget.controller.contentHeight.value}');

          if (toolbarOptions.fixedToolbar ||
              toolbarOptions.toolbarPosition == ToolbarPosition.custom) {
            return Container(
              decoration: editorOptions.decoration,
              height: _height,
              child: Column(
                verticalDirection: toolbarOptions.toolbarPosition ==
                        ToolbarPosition.aboveEditor
                    ? VerticalDirection.down
                    : VerticalDirection.up,
                children: <Widget>[
                  if (toolbarOptions.toolbarPosition != ToolbarPosition.custom)
                    _toolbar(),
                  Expanded(
                      child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: Stack(
                      children: [
                        _backgroundWidget(context),
                        _hintTextWidget(context),
                        widget.controller.initialized &&
                                widget.controller.toolbarHeight != null
                            ? view()
                            : SizedBox(),
                        _scrollPatch(context),
                        _sttDictationPreview(),
                      ],
                    ),
                  )),
                ],
              ),
            );
          }
          // auto hide
          if (widget.controller.hasFocus && _controller.value == 0) {
            timer?.cancel();
            timer = null;
            _controller
                .animateTo(1, duration: const Duration(seconds: 1))
                .then((value) {
              showToolbar = true;
            });
          } else if (!widget.controller.hasFocus &&
              _controller.value != 0 &&
              showToolbar) {
            timer = Timer(toolbarOptions.collapseDelay, () {
              _controller.reverse().then((_) {
                setState(() {
                  showToolbar = false;
                });
              });
            });
          }
          return Container(
            height: _height,
            decoration: editorOptions.decoration,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                    top: toolbarOptions.toolbarPosition ==
                            ToolbarPosition.aboveEditor
                        ? -51
                        : null,
                    left: 0,
                    right: 0,
                    bottom: toolbarOptions.toolbarPosition ==
                            ToolbarPosition.aboveEditor
                        ? null
                        : -51,
                    child:
                        FadeTransition(opacity: _animation, child: _toolbar())),
                _backgroundWidget(context),
                _hintTextWidget(context),
                widget.controller.initialized &&
                        widget.controller.toolbarHeight != null
                    ? view()
                    : SizedBox(),
                _scrollPatch(context),
                _sttDictationPreview(),
              ],
            ),
          );
        });
  }

  ///
  Widget view() {
    return WebView(
      javascriptMode: JavascriptMode.unrestricted,
      debuggingEnabled: true,
      onWebViewCreated: (c) async {
        widget.controller.editorController = c;

        await c.loadHtmlString(await widget.controller.getInitialContent(),
            baseUrl: '/');
      },
      javascriptChannels: {
        JavascriptChannel(
            name: 'toDart',
            onMessageReceived: (message) {
              print(message.message);
              widget.controller.processEvent(message.message);
            })
      },
      gestureRecognizers: {
        Factory<VerticalDragGestureRecognizer>(
            () => VerticalDragGestureRecognizer()),
        Factory<LongPressGestureRecognizer>(() => LongPressGestureRecognizer()),
      },
      onPageFinished: (_) async {
        print('Page finished');
        await _evaluateJavascript(data: {'type': 'toIframe: initEditor'});
      },
      navigationDelegate: (NavigationRequest request) =>
          NavigationDecision.navigate,
      onWebResourceError: (err) {
        print(err.toString());
        //throw Exception('${err.errorCode}:${err.description}');
      },
      backgroundColor: Colors.transparent,
    );
  }

  /// Helper function to run javascript and check current environment
  Future<void> _evaluateJavascript({required Map<String, Object?> data}) async {
    var js =
        'window.postMessage(\'${JsonEncoder().convert(data..['view'] = widget._viewId)}\')';
    await widget.controller.editorController.runJavascript(js);
  }

  ///
  Widget _toolbar() {
    return ToolbarWidget(
      key: widget.controller.toolbarKey,
      controller: widget.controller,
    );
  }

  ///STT popup
  Widget _sttDictationPreview() {
    if (!widget.controller.isRecording) return SizedBox();
    var textColor = editorOptions.dictationPreviewTextColor ??
        Theme.of(context).textTheme.bodyText1?.color;
    return PointerInterceptor(
      child: Positioned(
          left: 10,
          right: 10,
          bottom: 10,
          child: Container(
            decoration: editorOptions.dictationPreviewDecoration ??
                BoxDecoration(
                    color: Theme.of(context).canvasColor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 10,
                          spreadRadius: 0,
                          color: Colors.black38)
                    ]),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.mic_rounded,
                        color: textColor,
                      ),
                      Text(':',
                          style: TextStyle(
                            color: textColor,
                          )),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(widget.controller.sttBuffer,
                            style: TextStyle(
                              color: textColor,
                            )),
                      ),
                    ],
                  ),
                  Divider(
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.black26
                          : Colors.white24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: widget.controller.cancelRecording,
                          child: Text('Discard',
                              style: TextStyle(
                                color: textColor,
                              ))),
                      SizedBox(width: 24),
                      TextButton(
                          onPressed: widget.controller.stopRecording,
                          child: Text('Insert',
                              style: TextStyle(
                                color: textColor,
                              ))),
                    ],
                  )
                ],
              ),
            ),
          )),
    );
  }

  ///
  Widget _scrollPatch(BuildContext context) {
    // if (widget.controller.hasFocus && !widget.controller.alreadyDisabled) {
    return SizedBox();
    // }
    // return GestureDetector(
    //     onTap: () {
    //       widget.controller.setFocus();
    //     },
    //     child: PointerInterceptor(child: Positioned.fill(child: SizedBox())));
  }

  ///
  Widget _hintTextWidget(BuildContext context) {
    if (widget.controller.isContentEmpty && !widget.controller.hasFocus) {
      return Positioned.fill(
          child: Padding(
        padding: const EdgeInsets.only(top: 24.0, left: 56),
        child: Text(editorOptions.hint ?? '',
            style: editorOptions.hintStyle ??
                TextStyle(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: Theme.of(context)
                        .textTheme
                        .bodyText1
                        ?.color
                        ?.withOpacity(.3))),
      ));
    } else {
      return SizedBox();
    }
  }

  ///
  Widget _backgroundWidget(BuildContext context) {
    return Positioned.fill(
        child: Container(
            decoration: editorOptions.backgroundDecoration,
            color: editorOptions.backgroundColor));
  }
}
