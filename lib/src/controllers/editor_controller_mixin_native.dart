import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rte/src/controllers/editor_controller.dart';
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

  /// path to asset html file
  final String filePath = 'packages/flutter_rte/lib/assets/document.html';

  HtmlEditorController? _c;

  /// Helper function to run javascript and check current environment
  Future<void> evaluateJavascript({required Map<String, Object?> data}) async {
    if (_ec == null) return;
    if (_c == null) return;
    if (!(_c?.initialized ?? false) && data['type'] != 'toIframe: initEditor') {
      log('HtmlEditorController error:',
          error:
              'HtmlEditorController called an editor widget that doesn\'t exist.'
              '\nThis may happen because the widget '
              'initialization has been called but not completed, '
              'or because the editor widget was destroyed.\n'
              'Method called: [${data['type']}]');
      return;
    }
    var js =
        'window.postMessage(\'${JsonEncoder().convert(data..['view'] = viewId)}\')';
    await editorController.runJavaScript(js);
  }

  ///
  Future<void> init(
      BuildContext initBC, double initHeight, HtmlEditorController c) async {
    _c = c;
    _ec = WebViewController();
    await _ec!.addJavaScriptChannel('toDart',
        onMessageReceived: (message) => _c!.processEvent(message.message));
    await _ec!.setJavaScriptMode(JavaScriptMode.unrestricted);
    await _ec!.setNavigationDelegate(
      NavigationDelegate(
        onNavigationRequest: (NavigationRequest request) {
          if (request.url != 'about:blank') return NavigationDecision.prevent;
          return NavigationDecision.navigate;
        },
        onPageFinished: (_) async {
          await evaluateJavascript(data: {'type': 'toIframe: initEditor'});
        },
        onWebResourceError: (err) {
          throw Exception('${err.errorCode}: ${err.description}');
        },
      ),
    );
    await _ec!.setBackgroundColor(Colors.transparent);
    await _ec!.loadHtmlString(await c.getInitialContent());
  }

  ///
  void dispose() {
    // do nothing
  }

  ///
  Widget view(HtmlEditorController controller) {
    _c = controller;
    if (_ec == null) return SizedBox();
    return WebViewWidget(
      controller: _ec!,
      gestureRecognizers: {
        Factory<VerticalDragGestureRecognizer>(
            () => VerticalDragGestureRecognizer()),
        Factory<LongPressGestureRecognizer>(
            () => LongPressGestureRecognizer(duration: Duration(seconds: 1))),
      },
    );
  }
}
