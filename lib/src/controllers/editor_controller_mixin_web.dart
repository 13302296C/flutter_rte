import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:html' as html;
import 'package:flutter/services.dart';
import 'package:flutter_rich_text_editor/utils/shims/dart_ui.dart' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_rich_text_editor/src/controllers/editor_controller.dart';

abstract class PlatformSpecificMixin {
  String viewId = '';

  ///
  StreamSubscription<html.MessageEvent>? _eventSub;

  ///
  /// Helper function to run javascript and check current environment
  Future<void> evaluateJavascript({required Map<String, Object?> data}) async {
    data['view'] = viewId;
    final jsonEncoder = JsonEncoder();
    var json = jsonEncoder.convert(data);
    html.window.postMessage(json, '*');
  }

  ///
  Future<void> init(
      BuildContext initBC, double initHeight, HtmlEditorController c) async {
    await _eventSub?.cancel();
    _eventSub = html.window.onMessage.listen((event) {
      c.processEvent(event.data);
    }, onError: (e, s) {
      log('Event stream error: ${e.toString()}');
      log('Stack trace: ${s.toString()}');
    }, onDone: () {
      log('Event stream done.');
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
            window.parent.postMessage(JSON.stringify({"view": "$viewId", "type": "toDart: characterCount", "totalChars": totalChars}), "*");
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
    var initScript = '''
const viewId = \'$viewId\';
var toDart = window.parent;
''';
    var filePath = 'packages/flutter_rich_text_editor/lib/assets/document.html';
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

    final iframe = html.IFrameElement()
      ..width = MediaQuery.of(initBC).size.width.toString() //'800'
      ..height = '100%'
      // ignore: unsafe_html, necessary to load HTML string
      ..srcdoc = htmlString
      ..style.border = 'none'
      ..style.overflow = 'hidden'
      ..id = viewId
      ..onLoad.listen((event) async {
        if (c.isReadOnly && !c.isDisabled) {
          await c.disable();
        }
        if (c.callbacks != null && c.callbacks!.onInit != null) {
          c.callbacks!.onInit!.call();
        }

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

        var data = <String, Object>{'type': 'toIframe: initEditor'};
        data['view'] = viewId;
        final jsonEncoder = JsonEncoder();
        var jsonStr = jsonEncoder.convert(data);
        html.window.postMessage(jsonStr, '*');
      });
    ui.platformViewRegistry.registerViewFactory(viewId, (int viewId) => iframe);
  }

  ///
  void dispose() {
    _eventSub?.cancel();
  }
}
