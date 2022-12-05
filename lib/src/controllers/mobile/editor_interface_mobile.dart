import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rich_text_editor/src/controllers/editor_controller.dart';
import 'package:pedantic/pedantic.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HtmlEditorInterface {
  HtmlEditorInterface(String viewId) : _viewId = viewId;

  ///
  WebViewController? get webviewController =>
      _editorController!.editorController;

  HtmlEditorController? _editorController;

  late final JavascriptChannel _channel;

  final String filePath =
      'packages/flutter_rich_text_editor/lib/assets/document.html';

  ///
  Widget platformView(String id) => WebView(
        javascriptMode: JavascriptMode.unrestricted,
        debuggingEnabled: true,
        onWebViewCreated: (c) async {
          //webviewController = c;
          await webviewController!.loadHtmlString(initialContent, baseUrl: '/');
        },
        javascriptChannels: {_channel},
        gestureRecognizers: {
          Factory<VerticalDragGestureRecognizer>(
              () => VerticalDragGestureRecognizer()),
          Factory<LongPressGestureRecognizer>(
              () => LongPressGestureRecognizer()),
        },
        onPageFinished: (_) async {
          print('Page finished');
          await _evaluateJavascript(data: {'type': 'toIframe: initEditor'});
        },
        navigationDelegate: (NavigationRequest request) =>
            NavigationDecision.navigate,
        onWebResourceError: (err) {
          print(err.toString());
          //throw Exception('${err.errorCode}:${err.description}');
        },
        backgroundColor: Colors.transparent,
      );

  late String initialContent;

  ///
  final String _viewId;

  /// Helper function to run javascript and check current environment
  Future<void> _evaluateJavascript({required Map<String, Object?> data}) async {
    var js =
        'window.postMessage(\'${JsonEncoder().convert(data..['view'] = _viewId)}\')';
    await webviewController!.runJavascript(js);
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - //
  // - - - - - - - - METHODS API - - - - - - - - - - - - - - - - - - - - - //
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - //

  /// Sets the focus to the editor.
  void setFocus() => _evaluateJavascript(data: {'type': 'toIframe: setFocus'});

  /// Clears the focus from the webview
  void clearFocus() =>
      _evaluateJavascript(data: {'type': 'toIframe: clearFocus'});

  /// disables the Html editor
  Future<void> disable() async =>
      await _evaluateJavascript(data: {'type': 'toIframe: disable'});

  /// enables the Html editor
  Future<void> enable() async =>
      await _evaluateJavascript(data: {'type': 'toIframe: enable'});

  /// Undoes the last action
  void undo() {
    _evaluateJavascript(data: {'type': 'toIframe: undo'});
  }

  /// Redoes the last action
  void redo() {
    _evaluateJavascript(data: {'type': 'toIframe: redo'});
  }

  /// Sets the text of the editor. Some pre-processing is applied to convert
  /// [String] elements like "\n" to HTML elements.
  void setText(String text) {
    _evaluateJavascript(data: {'type': 'toIframe: setText', 'text': text});
  }

  /// Insert text at the end of the current HTML content in the editor
  /// Note: This method should only be used for plaintext strings
  Future<void> insertText(String text) async {
    await _evaluateJavascript(
        data: {'type': 'toIframe: insertText', 'text': text});
  }

  /// Insert HTML at the position of the cursor in the editor
  /// Note: This method should not be used for plaintext strings
  Future<void> insertHtml(String html) async {
    await _evaluateJavascript(
        data: {'type': 'toIframe: insertHtml', 'html': html});
  }

  /// Gets the text from the editor and returns it as a [String].
  Future<void> getText() async {
    unawaited(_evaluateJavascript(data: {'type': 'toIframe: getText'}));
  }

  /// Clears the editor of any text.
  Future<void> clear() async {
    await _evaluateJavascript(data: {'type': 'toIframe: clear'});
  }

  /// toggles the codeview in the Html editor
  void toggleCodeView() {
    _evaluateJavascript(data: {'type': 'toIframe: toggleCode'});
  }

  ///
  Future<void> getSelectedText() async {
    //if (withHtmlTags) {

    unawaited(
        _evaluateJavascript(data: {'type': 'toIframe: getSelectedTextHtml'}));

    // } else {
    //   _openRequests
    //       .addEntries({'toDart: getSelectedText': Completer<String>()}.entries);
    //   unawaited(
    //       _evaluateJavascript(data: {'type': 'toIframe: getSelectedText'}));
    //   return _openRequests['toDart: getSelectedText']!.future as Future<String>;
    // }

    // var e = await html.window.onMessage.firstWhere((element) =>
    //     json.decode(element.data)['type'] == 'toDart: getSelectedText');
    // return _openRequests['toDart: getSelectedText']
    //     .future; // json.decode(e.data)['text'];
  }

  /// Insert a link at the position of the cursor in the editor
  Future<void> insertLink(String text, String url, bool isNewWindow) async {
    await _evaluateJavascript(data: {
      'type': 'toIframe: makeLink',
      'text': text,
      'url': url,
      'isNewWindow': isNewWindow
    });
  }

  ///
  Future<void> removeLink() async {
    await _evaluateJavascript(data: {'type': 'toIframe: removeLink'});
  }

  /// Recalculates the height of the editor to remove any vertical scrolling.
  /// This method will not do anything if [autoAdjustHeight] is turned off.
  Future<void> recalculateHeight() async {
    await _evaluateJavascript(data: {
      'type': 'toIframe: getHeight',
    });
  }

  /// A function to quickly call a document.execCommand function in a readable format
  Future<void> execCommand(String command, {String? argument}) async {
    await _evaluateJavascript(data: {
      'type': 'toIframe: execCommand',
      'command': command,
      'argument': argument
    });
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - //
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - //

  Future<void> init(
      BuildContext initBC, double initHeight, HtmlEditorController c) async {
    _editorController = c;

    _channel = JavascriptChannel(
        name: 'toDart',
        onMessageReceived: (message) {
          print(message.message);
          c.processEvent(message.message);
        });

    //var headString = '';
    var summernoteCallbacks = '''callbacks: {
        onKeydown: function(e) {
            var chars = \$(".note-editable").text();
            var totalChars = chars.length;
            ${c.editorOptions!.characterLimit != null ? '''allowedKeys = (
                e.which === 8 ||  /* BACKSPACE */
                e.which === 35 || /* END */
                e.which === 36 || /* HOME */
                e.which === 37 || /* LEFT */
                e.which === 38 || /* UP */
                e.which === 39 || /* RIGHT*/
                e.which === 40 || /* DOWN */
                e.which === 46 || /* DEL*/
                e.ctrlKey === true && e.which === 65 || /* CTRL + A */
                e.ctrlKey === true && e.which === 88 || /* CTRL + X */
                e.ctrlKey === true && e.which === 67 || /* CTRL + C */
                e.ctrlKey === true && e.which === 86 || /* CTRL + V */
                e.ctrlKey === true && e.which === 90    /* CTRL + Z */
            );
            if (!allowedKeys && \$(e.target).text().length >= ${c.editorOptions!.characterLimit}) {
                e.preventDefault();
            }''' : ''}
            window.parent.postMessage(JSON.stringify({"view": "$_viewId", "type": "toDart: characterCount", "totalChars": totalChars}), "*");
        },
    ''';
    //var maximumFileSize = 10485760;
    // for (var p in plugins) {
    //   headString = headString + p.getHeadString() + '\n';
    //   if (p is SummernoteAtMention) {
    //     summernoteCallbacks = summernoteCallbacks +
    //         '''
    //         \nsummernoteAtMention: {
    //           getSuggestions: (value) => {
    //             const mentions = ${p.getMentionsWeb()};
    //             return mentions.filter((mention) => {
    //               return mention.includes(value);
    //             });
    //           },
    //           onSelect: (value) => {
    //             window.parent.postMessage(JSON.stringify({"view": "$viewId", "type": "toDart: onSelectMention", "value": value}), "*");
    //           },
    //         },
    //       ''';
    //     if (p.onSelect != null) {
    //       html.window.onMessage.listen((event) {
    //         var data = json.decode(event.data);
    //         if (data['type'] != null &&
    //             data['type'].contains('toDart:') &&
    //             data['view'] == viewId &&
    //             data['type'].contains('onSelectMention')) {
    //           p.onSelect!.call(data['value']);
    //         }
    //       });
    //     }
    //   }
    // }

    // summernoteCallbacks = summernoteCallbacks + '}';
    // if ((Theme.of(initBC).brightness == Brightness.dark ||
    //         editorOptions!.darkMode == true) &&
    //     editorOptions!.darkMode != false) {}
    // var userScripts = '';
    // if (editorOptions!.webInitialScripts != null) {
    //   editorOptions!.webInitialScripts!.forEach((element) {
    //     userScripts = userScripts +
    //         '''
    //       if (data["type"].includes("${element.name}")) {
    //         ${element.script}
    //       }
    //     ''' +
    //         '\n';
    //   });
    // }
    var initScript = 'const viewId = \'$_viewId\';';

    // if (c.editorOptions!.filePath != null) {
    //   filePath = c.editorOptions!.filePath!;
    // }
    var htmlString = await rootBundle.loadString(filePath);
    htmlString =
        htmlString.replaceFirst('/* - - - Init Script - - - */', initScript);

    // if no explicit `height` is provided - hide the scrollbar as the
    // container height will always adjust to the document height
    if (c.editorOptions!.height == null) {
      var hideScrollbarCss = '''
  ::-webkit-scrollbar {
    width: 0px;
    height: 0px;
  }
''';
      htmlString = htmlString.replaceFirst(
          '/* - - - Hide Scrollbar - - - */', hideScrollbarCss);
    }

    initialContent = htmlString;

    // html.window.onMessage.listen((event) {
    //   var data = json.decode(event.data);

    //   if (data['type'] != null &&
    //       data['type'].contains('toDart: onChangeContent') &&
    //       data['view'] == viewId) {
    //     if (editorOptions!.shouldEnsureVisible &&
    //         Scrollable.of(context) != null) {
    //       Scrollable.of(context)!.position.ensureVisible(
    //           context.findRenderObject()!,
    //           duration: const Duration(milliseconds: 100),
    //           curve: Curves.easeIn);
    //     }
    //   }
    // });
  }

  void dispose() {}
}
