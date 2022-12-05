import 'package:flutter/material.dart';
import 'package:flutter_rich_text_editor/src/controllers/editor_controller.dart';

abstract class PlatformSpecificMixin {
  String viewId = '';

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
