import 'package:flutter/material.dart';
import 'package:flutter_rich_text_editor/flutter_rich_text_editor.dart';

/// HTML rich text editor
class HtmlEditor extends StatelessWidget {
  HtmlEditor({
    Key? key,
    this.height,
    this.minHeight,
    this.hint,
    this.initialValue,
    this.onChanged,
    this.isReadOnly = false,
    this.controller,
    this.callbacks,
    //this.plugins = const [],
  }) : super(key: key) {
    initializeController();
  }

  /// Shortcut for onChanged callback
  final void Function(String?)? onChanged;

  /// Provides access to all options and features
  HtmlEditorController? controller;

  /// Sets the list of Summernote plugins enabled in the editor.
  //final List<Plugins> plugins;

  /// Puts editor in read-only mode, hiding its toollbar
  final bool isReadOnly;

  /// Desired hight. 'Auto' if null.
  final double? height;

  /// If height is omited, the editor height
  /// will be equal or greater than `minHeight`.
  final double? minHeight;

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
  Widget build(BuildContext context) {
    return HtmlEditorWidget(
      height: height,
      minHeight: minHeight,
      initBC: context,
      controller: controller!,
    );
  }

  /// If controller is provided to the editor - initialize its values
  void initializeController() {
    controller ??= HtmlEditorController();
    // if (initialValue != null &&
    //     controller!.editorOptions!.initialText != null &&
    //     !controller!.initialized) {
    //   throw Exception(
    //       'Cannot have both [initialValue] and [editorOptions.initialText]. Please choose one.');
    // }
    if (initialValue != null) {
      controller!.setInitialText(initialValue!);
    }
    if (hint != null) {
      controller!.editorOptions!.hint = hint;
    }

    if (height != null) {
      controller!.editorOptions!.height = height;
    }

    if (controller!.isReadOnly != isReadOnly) {
      controller!.isReadOnly = isReadOnly;
      controller!.toolbarHeight = null; // trigger recalc
      if (isReadOnly) {
        controller!.disable();
      } else {
        controller!.enable();
      }
    }

    controller!.callbacks = callbacks;
    //controller.plugins = plugins;
    if (callbacks == null) {
      controller!.callbacks = Callbacks(onChangeContent: onChanged);
    } else {
      if (controller!.callbacks!.onChangeContent != null && onChanged != null) {
        throw Exception(
            'Cannot have both onChanged and Callbacks.onChangeContent. Please pick one.');
      }
      if (onChanged != null) {
        controller!.callbacks!.onChangeContent = onChanged;
      }
    }
  }
}
