import 'dart:io' as io;
import 'dart:math' as math;
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_rte/flutter_rte.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

/// HTML rich text editor
class HtmlEditor extends StatefulWidget {
  const HtmlEditor({
    Key? key,
    this.height,
    this.minHeight,
    this.expandFullHeight = false,
    this.hint,
    this.initialValue,
    this.onChanged,
    this.isReadOnly,
    this.enableDictation,
    this.controller,
    this.callbacks,
    //this.plugins = const [],
  })  : assert(minHeight == null || minHeight >= 64),
        assert(height == null || height >= 64),
        super(key: key);

  /// Shortcut for onChanged callback
  final void Function(String?)? onChanged;

  /// Provides access to all options and features
  final HtmlEditorController? controller;

  /// Sets the list of Summernote plugins enabled in the editor.
  //final List<Plugins> plugins;

  /// Puts editor in read-only mode, hiding its toollbar
  final bool? isReadOnly;

  /// If enabled - shows microphone icon and allows to use dictation within
  /// the editor
  final bool? enableDictation;

  /// Desired hight. 'Auto' if null.
  final double? height;

  /// If height is omited, the editor height
  /// will be equal or greater than `minHeight`.
  final double? minHeight;

  /// if set to `true` - the editor is trying to occupy all available space
  final bool expandFullHeight;

  /// Initial text to load into the editor
  final String? initialValue;

  /// Hint text to display when the editor is empty.
  ///
  /// Defaults to [ ***Your text here...*** ]
  final String? hint;

  /// Sets & activates callbacks. See the functions available in
  /// [Callbacks] for more details.
  final Callbacks? callbacks;

  @override
  State<HtmlEditor> createState() => _HtmlEditorState();
}

class _HtmlEditorState extends State<HtmlEditor> with TickerProviderStateMixin {
  late final HtmlEditorController _controller;
  Callbacks? get callbacks => _controller.callbacks;

  //List<Plugins> get plugins => widget.controller.plugins;

  HtmlEditorOptions get editorOptions => _controller.editorOptions;

  HtmlToolbarOptions get toolbarOptions => _controller.toolbarOptions;

  /// logic that calculates and sets the explicit height of the container.
  double? get _height {
    double? h;

    if (widget.expandFullHeight) {
      h = MediaQuery.of(context).size.height;
    } else

    // if no need to show toolbar - return the content height only
    if (toolbarOptions.toolbarPosition == ToolbarPosition.custom ||
        _controller.isDisabled ||
        _controller.isReadOnly) {
      h = editorOptions.height ??
          math.max(widget.minHeight ?? 0, _controller.contentHeight);
    } else {
      // if height if fixed = return fixed height, otherwise return
      // greatest of `minHeight` and `contentHeight`.
      h = editorOptions.height ??
          (_controller.toolbarHeight == null
              ? null
              : math.max(widget.minHeight ?? 0,
                  _controller.contentHeight + _controller.toolbarHeight!));
    }

    // account for conteiner padding, if one is provided
    if (h != null) {
      h = h + _controller.verticalPadding;
    }

    // finally, check if we are recording.
    // If we are - make sure that the container height is not to small
    // to prevent the recorder widget from overflowing the editor
    if (_controller.isRecording && (h ?? 150) < 150) {
      h = 150;
    }

    return h;
  }

  ///
  bool showToolbar = false;

  ///
  @internal
  Timer? timer;

  @override
  void initState() {
    _initializeController();
    _controller.focusNode = FocusNode();
    //if (!_controller.initialized) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _controller.initEditor(context).then((value) {
        if (mounted && !kIsWeb) setState(() {});
      });
    });

    //}
    super.initState();
  }

  @override
  void dispose() {
    _controller.focusNode?.dispose();
    _controller.focusNode = null;
    _controller.deinitialize();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          padding: editorOptions.padding,
          decoration: editorOptions.decoration,
          height: _height,
          child: _controller.hasFault ? _faultWidget : _editorWidget(child!),
        );
      },
      child: _controller.view(_controller),
    );
  }

  ///
  Widget _editorWidget(Widget child) => Column(
        mainAxisSize: MainAxisSize.min,
        verticalDirection:
            toolbarOptions.toolbarPosition == ToolbarPosition.aboveEditor
                ? VerticalDirection.down
                : VerticalDirection.up,
        children: <Widget>[
          if (toolbarOptions.toolbarPosition != ToolbarPosition.custom)
            ToolbarWidget(
              key: _controller.toolbarKey,
              controller: _controller,
            ),
          // on native - sow editor right away,
          // on web - wait intil initialized
          if (kIsWeb && _controller.initialized || !kIsWeb)
            Expanded(
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: Stack(
                  children: [
                    _backgroundWidget(),
                    _hintTextWidget(),
                    child,
                    _scrollPatch(),
                    _sttDictationPreview(),
                  ],
                ),
              ),
            ),
        ],
      );

  ///
  Widget get _faultWidget => Center(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Text('Editor Error:'),
            const SizedBox(height: 16),
            Text(_controller.fault.toString()),
          ],
        ),
      ));

  ///STT popup
  Widget _sttDictationPreview() {
    if (!_controller.isRecording) return const SizedBox();
    var textColor = editorOptions.dictationPreviewTextColor ??
        Theme.of(context).textTheme.bodyMedium?.color;
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
                    boxShadow: const [
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
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(_controller.sttBuffer,
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
                          onPressed: _controller.cancelRecording,
                          child: Text('Discard',
                              style: TextStyle(
                                color: textColor,
                              ))),
                      const SizedBox(width: 24),
                      TextButton(
                          onPressed: _controller.stopRecording,
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

  /// This top overlay widget patches scrolling issues on iOS and Web
  Widget _scrollPatch() {
    // when work fullscreen - don't block anything
    if (_controller.editorOptions.expandFullHeight) {
      return const SizedBox();
    }
    //if disabled or read-only - intercept all events
    if (_controller.isReadOnly || _controller.isDisabled) {
      // if (kIsWeb) {
      //   return Positioned.fill(
      //       child: PointerInterceptor(child: SizedBox.expand()));
      // }
      if (!kIsWeb) {
        return const Positioned.fill(
            child: AbsorbPointer(child: SizedBox.expand()));
      }
    } else if (!_controller.hasFocus ||
        (kIsWeb && _controller.contentIsEmpty)) {
      if (kIsWeb) {
        return Positioned.fill(
          child: Listener(
              onPointerUp: (e) {
                _controller.setFocus();
              },
              child: const PointerInterceptor(child: SizedBox.expand())),
        );
      } else if (io.Platform.isIOS) {
        return Positioned.fill(
          child: GestureDetector(
              onTap: () {
                _controller.setFocus();
              },
              child: const AbsorbPointer(child: SizedBox.expand())),
        );
      }
    }
    // Android doesn't need special treatment :)
    return const SizedBox();
  }

  ///
  Widget _hintTextWidget() {
    if (_controller.contentIsEmpty &&
        !_controller.hasFocus &&
        !_controller.isReadOnly) {
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
                        .bodyMedium
                        ?.color
                        ?.withOpacity(.3))),
      ));
    } else {
      return const SizedBox();
    }
  }

  ///
  Widget _backgroundWidget() {
    return Positioned.fill(
        child: Container(
            decoration: editorOptions.backgroundDecoration,
            color: editorOptions.backgroundColor));
  }

  /// If controller is provided to the editor - initialize its values
  /// otherwise create internal controller with the values provided
  void _initializeController() {
    Exception? fault;
    // redundancy fuse: can't set both controller and widget callbacks set
    if (widget.controller != null) {
      if (widget.callbacks != null) {
        fault = Exception(
            'Cannot have widget callbacks when controller is provided. Please use controller callbacks.');
      }
    }
    // redundancy fuse: can't set both widget.onChanged and callbacks.onChanged set
    if (widget.callbacks != null && widget.onChanged != null) {
      fault = Exception(
          'Cannot have both onChanged and Callbacks.onChangeContent. Please pick one.');
    }

    // redundancy fuse: can't set both widget.onChanged and callbacks.onChanged set
    if (widget.controller != null && widget.onChanged != null) {
      fault = Exception(
          'Cannot have both onChanged and controller. Please use constroller callbacks.');
    }

    // if controller is not provided - initialize internal controller
    // and assign it widget callbacks. but if they are null -
    // init Callbacks with widget.onChanged callack set
    _controller = widget.controller ??
        HtmlEditorController(
            callbacks: widget.callbacks ??
                Callbacks(onChangeContent: widget.onChanged));

    _controller.context = context;
    _controller.editorOptions.expandFullHeight = widget.expandFullHeight;
    if (widget.initialValue != null) {
      _controller.setInitialText(widget.initialValue!);
    }
    if (widget.hint != null) {
      _controller.editorOptions.hint = widget.hint;
    }

    if (widget.height != null) {
      _controller.editorOptions.height = widget.height;
    }

    if (widget.enableDictation != null) {
      _controller.enableDictation = widget.enableDictation!;
    }

    if (widget.isReadOnly != null) {
      _controller.isReadOnly = widget.isReadOnly!;
    }
    _controller.fault = fault;
  }
}
