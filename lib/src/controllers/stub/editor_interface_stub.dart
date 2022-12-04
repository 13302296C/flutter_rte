import 'package:flutter/material.dart';
import 'package:flutter_rich_text_editor/src/controllers/editor_controller.dart';
import 'dart:html' as html;

class HtmlEditorInterface {
  HtmlEditorInterface(String viewId) {
    throw Exception('Platform not supported');
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - //
  // - - - - - - - - METHODS API - - - - - - - - - - - - - - - - - - - - - //
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - //

  /// Sets the focus to the editor.
  void setFocus() => throw Exception('Unimplemented');

  /// Clears the focus from the webview
  void clearFocus() => throw Exception('Unimplemented');

  /// disables the Html editor
  Future<void> disable() => throw Exception('Unimplemented');

  /// enables the Html editor
  Future<void> enable() => throw Exception('Unimplemented');

  /// Undoes the last action
  void undo() => throw Exception('Unimplemented');

  /// Redoes the last action
  void redo() => throw Exception('Unimplemented');

  /// Sets the text of the editor. Some pre-processing is applied to convert
  /// [String] elements like "\n" to HTML elements.
  void setText(String text) => throw Exception('Unimplemented');

  /// Insert text at the end of the current HTML content in the editor
  /// Note: This method should only be used for plaintext strings
  Future<void> insertText(String text) async =>
      throw Exception('Unimplemented');

  /// Insert HTML at the position of the cursor in the editor
  /// Note: This method should not be used for plaintext strings
  Future<void> insertHtml(String html) async =>
      throw Exception('Unimplemented');

  /// Gets the text from the editor and returns it as a [String].
  Future<void> getText() async => throw Exception('Unimplemented');

  /// Clears the editor of any text.
  Future<void> clear() async => throw Exception('Unimplemented');

  /// toggles the codeview in the Html editor
  void toggleCodeView() => throw Exception('Unimplemented');

  ///
  Future<void> getSelectedText() async => throw Exception('Unimplemented');

  /// Insert a link at the position of the cursor in the editor
  Future<void> insertLink(String text, String url, bool isNewWindow) async =>
      throw Exception('Unimplemented');

  ///
  Future<void> removeLink() async => throw Exception('Unimplemented');

  /// Recalculates the height of the editor to remove any vertical scrolling.
  /// This method will not do anything if [autoAdjustHeight] is turned off.
  Future<void> recalculateHeight() async => throw Exception('Unimplemented');

  /// A function to quickly call a document.execCommand function in a readable format
  Future<void> execCommand(String command, {String? argument}) async =>
      throw Exception('Unimplemented');

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - //
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - //

  Future<void> processEvent(html.MessageEvent event) async =>
      throw Exception('Unimplemented');

  Future<void> init(BuildContext initBC, double initHeight,
          HtmlEditorController c) async =>
      throw Exception('Unimplemented');

  void dispose() => throw Exception('Unimplemented');
}
