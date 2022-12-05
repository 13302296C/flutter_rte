import 'package:flutter/material.dart';
import 'package:flutter_rich_text_editor/src/controllers/editor_controller.dart';
import 'package:webview_flutter/webview_flutter.dart';

abstract class PlatformSpecificMixin {
  ///
  String viewId = '';

  ///
  final String filePath = '';

  /// Allows the [WebViewController] for the Html editor to be accessed
  /// outside of the package itself for endless control and customization.
  WebViewController get editorController =>
      throw Exception('Platform not supported');

  /// Internal method to set the [WebViewController] when webview initialization
  /// is complete
  set editorController(WebViewController controller) =>
      throw Exception('webview controller does not exist on web.');

  /// Helper function to run javascript and check current environment
  Future<void> evaluateJavascript({required Map<String, Object?> data}) async {
    throw Exception('Platform not supported');
  }

  ///
  Future<void> init(
      BuildContext initBC, double initHeight, HtmlEditorController c) async {
    throw Exception('Platform not supported');
  }

  ///
  void dispose() {
    throw Exception('Platform not supported');
  }
}
