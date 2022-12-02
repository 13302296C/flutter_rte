import 'package:flutter_rich_text_editor/flutter_rich_text_editor.dart';
import 'package:flutter_rich_text_editor/src/widgets/editor_widget_web.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// HtmlEditor class for web
class HtmlEditor extends StatelessWidget {
  HtmlEditor({
    Key? key,
    this.height,
    this.minHeight,
    this.hint,
    this.initialValue,
    this.onChanged,
    this.isReadOnly = false,
    required this.controller,
    this.callbacks,
    //this.plugins = const [],
  }) : super(key: key) {
    if (initialValue != null &&
        controller.htmlEditorOptions.initialText != null &&
        !controller.initialized) {
      throw Exception(
          'Cannot have both [initialValue] and [htmlEditorOptions.initialText]. Please choose one.');
    }
    if (initialValue != null) {
      controller.htmlEditorOptions.initialText = initialValue;
    }
    if (hint != null) {
      controller.htmlEditorOptions.hint = hint;
    }
    if (controller.isReadOnly != isReadOnly) {
      controller.isReadOnly = isReadOnly;
      controller.toolbarHeight = null; // trigger recalc
      if (isReadOnly) {
        controller.disable();
      } else {
        controller.enable();
      }
    }

    controller.callbacks = callbacks;
    //controller.plugins = plugins;
    if (callbacks == null) {
      controller.callbacks = Callbacks(onChangeContent: onChanged);
    } else {
      if (controller.callbacks!.onChangeContent != null && onChanged != null) {
        throw Exception(
            'Cannot have both onChanged and Callbacks.onChangeContent. Please pick one.');
      }
      if (onChanged != null) {
        controller.callbacks!.onChangeContent = onChanged;
      }
    }
  }

  /// Shortcut for onChanged callback
  final void Function(String?)? onChanged;

  /// The controller that is passed to the widget, which allows multiple [HtmlEditor]
  /// widgets to be used on the same page independently.
  final HtmlEditorController controller;

  /// Puts editor in read-only mode, hiding its toollbar
  final bool isReadOnly;

  final double? height;

  /// If height is omited, the editor height
  /// will be equal or greater than `minHeight`.
  final double? minHeight;

  final String? hint;

  final String? initialValue;

  /// Sets & activates Summernote's callbacks. See the functions available in
  /// [Callbacks] for more details.
  final Callbacks? callbacks;

  /// Sets the list of Summernote plugins enabled in the editor.
  //final List<Plugins> plugins;

  @override
  Widget build(BuildContext context) {
    return HtmlEditorWidget(
      controller: controller,
      height: height,
      minHeight: minHeight,
      initBC: context,
    );
  }
}
