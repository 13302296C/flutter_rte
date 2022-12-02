export 'dart:html';

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_rich_text_editor/flutter_rich_text_editor.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

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

class _HtmlEditorWidgetState extends State<HtmlEditorWidget> {
  /// Tracks whether the editor was disabled onInit (to avoid re-disabling on reload)
  //bool alreadyDisabled = false;

  Callbacks? get callbacks => widget.controller.callbacks;

  //List<Plugins> get plugins => widget.controller.plugins;

  HtmlEditorOptions get htmlEditorOptions =>
      widget.controller.htmlEditorOptions;

  OtherOptions get otherOptions => widget.controller.otherOptions;

  HtmlToolbarOptions get htmlToolbarOptions =>
      widget.controller.htmlToolbarOptions;

  /// if height if fixed = return fixed height, otherwise return
  /// greatest of `minHeight` and `contentHeight`.
  double get _height =>
      otherOptions.height ??
      math.max(
          widget.minHeight ?? 0,
          widget.controller.contentHeight.value +
              (widget.controller.toolbarHeight ?? 0));

  @override
  Widget build(BuildContext context) {
    if (widget.controller.toolbarHeight == null) {
      if (widget.controller.isReadOnly) {
        widget.controller.toolbarHeight = 0;
        if (!widget.controller.initialized) {
          widget.controller
              .initEditor(widget.initBC, otherOptions.height ?? _height);
        }
        //log('======toolbar height = ${controller.toolbarHeight}');
      } else {
        if (!widget.controller.initialized) {
          widget.controller.initEditor(
              widget.initBC, _height - widget.controller.toolbarHeight!);
        }
        widget.controller.toolbarHeight = widget.controller.isReadOnly ? 0 : 51;
        //log('======toolbar height = ${controller.toolbarHeight}');

      }
    }
    return AnimatedBuilder(
        animation: widget.controller,
        builder: (context, _) {
          return Container(
            height: _height,
            child: Column(
              children: <Widget>[
                if (htmlToolbarOptions.toolbarPosition ==
                    ToolbarPosition.aboveEditor)
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
                          ? HtmlElementView(
                              viewType: widget._viewId,
                            )
                          : SizedBox(),
                      _scrollPatch(context),
                      _sttDictationPreview(),
                    ],
                  ),
                )),
                if (htmlToolbarOptions.toolbarPosition ==
                    ToolbarPosition.belowEditor)
                  _toolbar(),
              ],
            ),
          );
        });
  }

  ///
  Widget _toolbar() {
    return ToolbarWidget(
        key: widget.controller.toolbarKey,
        controller: widget.controller,
        htmlToolbarOptions: htmlToolbarOptions,
        callbacks: callbacks);
  }

  ///STT popup
  Widget _sttDictationPreview() {
    if (!widget.controller.isRecording) return SizedBox();
    var textColor = htmlEditorOptions.dictationPreviewTextColor ??
        Theme.of(context).textTheme.bodyText1?.color;
    return PointerInterceptor(
      child: Positioned(
          left: 10,
          right: 10,
          bottom: 10,
          child: Container(
            decoration: htmlEditorOptions.dictationPreviewDecoration ??
                BoxDecoration(
                    color: Theme.of(context).canvasColor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 5, spreadRadius: 1, color: Colors.black38)
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
                  ...widget.controller.sttBuffer.isNotEmpty
                      ? [
                          Divider(
                              color: Theme.of(context).brightness ==
                                      Brightness.light
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
                        ]
                      : []
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
    if (widget.controller.isContentEmpty) {
      return Positioned.fill(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(widget.controller.htmlEditorOptions.hint ?? '',
            style: widget.controller.htmlEditorOptions.hintStyle ??
                TextStyle(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: Theme.of(context)
                        .textTheme
                        .bodyText1
                        ?.color
                        ?.withOpacity(.5))),
      ));
    } else {
      return SizedBox();
    }
  }

  ///
  Widget _backgroundWidget(BuildContext context) {
    return Positioned.fill(
        child: Container(
            color: widget.controller.htmlEditorOptions.backgroundColor));
  }
}
