import 'package:flutter/material.dart';
import 'package:flutter_rich_text_editor/flutter_rich_text_editor.dart';

/// Fallback HtmlEditor class (should never be called)
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
    Callbacks? callbacks,
    this.htmlEditorOptions,
    this.htmlToolbarOptions,
    this.otherOptions,
    this.plugins = const [],
  }) : super(key: key);

  /// Shortcut for onChanged callback
  final void Function(String?)? onChanged;

  /// Defines options for the html editor
  final HtmlEditorOptions? htmlEditorOptions;

  /// Defines options for the editor toolbar
  final HtmlToolbarOptions? htmlToolbarOptions;

  /// Defines other options
  final OtherOptions? otherOptions;

  /// The controller that is passed to the widget, which allows multiple [HtmlEditor]
  /// widgets to be used on the same page independently.
  final HtmlEditorController controller;

  /// Sets the list of Summernote plugins enabled in the editor.
  final List<Plugins> plugins;

  /// Puts editor in read-only mode, hiding its toollbar
  final bool isReadOnly;

  /// Desired hight. 'Auto' if null.
  final double? height;

  /// If height is omited, the editor height
  /// will be equal or greater than `minHeight`.
  final double? minHeight;

  final String? initialValue;

  final String? hint;

  @override
  Widget build(BuildContext context) {
    return Text('Unsupported in this environment');
  }
}
