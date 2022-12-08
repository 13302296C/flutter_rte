import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rich_text_editor/src/controllers/editor_controller.dart';
import 'package:webview_flutter/webview_flutter.dart';

abstract class PlatformSpecificMixin {
  String viewId = '';

  /// Allows the [WebViewController] for the Html editor to be accessed
  /// outside of the package itself for endless control and customization.
  WebViewController get editorController => _ec!;

  WebViewController? _ec;

  /// Internal method to set the [WebViewController] when webview initialization
  /// is complete
  set editorController(WebViewController controller) {
    _ec = controller;
  }

  final String filePath =
      'packages/flutter_rich_text_editor/lib/assets/document.html';

  /// Helper function to run javascript and check current environment
  Future<void> evaluateJavascript({required Map<String, Object?> data}) async {
    if (_ec == null) return;
    var js =
        'window.postMessage(\'${JsonEncoder().convert(data..['view'] = viewId)}\')';
    await editorController.runJavascript(js);
  }

  ///
  Future<void> init(
      BuildContext initBC, double initHeight, HtmlEditorController c) async {
    //do nothing
  }

  ///
  void dispose() {
    // do nothing
  }

  ///
  Widget view(HtmlEditorController controller) {
    return WebView(
      javascriptMode: JavascriptMode.unrestricted,
      debuggingEnabled: true,
      onWebViewCreated: (c) async {
        editorController = c;
        var st = await controller.getInitialContent();
        await c.loadHtmlString(st);
      },
      javascriptChannels: {
        JavascriptChannel(
            name: 'toDart',
            onMessageReceived: (message) =>
                controller.processEvent(message.message))
      },
      gestureRecognizers: {
        Factory<VerticalDragGestureRecognizer>(
            () => VerticalDragGestureRecognizer()),
        Factory<LongPressGestureRecognizer>(
            () => LongPressGestureRecognizer(duration: Duration(seconds: 1))),
      },
      onPageFinished: (_) async {
        await evaluateJavascript(data: {'type': 'toIframe: initEditor'});
        if (controller.isReadOnly || controller.isDisabled) {
          await controller.disable();
        }
      },
      navigationDelegate: (NavigationRequest request) {
        if (request.url != 'about:blank') return NavigationDecision.prevent;
        return NavigationDecision.navigate;
      },
      onWebResourceError: (err) {
        throw Exception('${err.errorCode}: ${err.description}');
      },
      backgroundColor: Colors.transparent,
    );
  }
}
