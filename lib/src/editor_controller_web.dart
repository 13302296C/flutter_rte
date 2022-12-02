import 'dart:async';
import 'dart:convert';
import 'dart:developer';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rich_text_editor/flutter_rich_text_editor.dart';
import 'package:flutter_rich_text_editor/src/editor_controller_unsupported.dart'
    as unsupported;
import 'package:flutter_rich_text_editor/utils/shims/dart_ui.dart' as ui;
import 'package:flutter_rich_text_editor/utils/utils.dart';

// speech to text
import 'dart:developer';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

part 'editor_controller_web_events.dart';
part 'editor_controller_web_fn.dart';

/// Controller for web
class HtmlEditorController extends unsupported.HtmlEditorController {
  HtmlEditorController({
    this.processInputHtml = true,
    this.processNewLineAsBr = false,
    this.processOutputHtml = true,
    HtmlEditorOptions? htmlEditorOptions,
    HtmlToolbarOptions? htmlToolbarOptions,
    OtherOptions? otherOptions,
  })  : _viewId = getRandString(10).substring(0, 14),
        super(
            htmlEditorOptions: htmlEditorOptions ??
                HtmlEditorOptions(hint: 'Enter text here ...'),
            htmlToolbarOptions: htmlToolbarOptions ??
                HtmlToolbarOptions(buttonColor: Colors.grey),
            otherOptions: otherOptions ?? OtherOptions());

  /// Dictation controller
  // SpeechToText? speechToText;

  /// is dictation available
  bool sttAvailable = false;

  // /// is dictation running
  // bool isRecording = false;

  // /// Dictation result buffer
  // String sttBuffer = '';

  // bool hasFocus = false;

  ///
  StreamSubscription<html.MessageEvent>? _eventSub;

  ///
  final Map<String, Completer> _openRequests = {};

  ///
  @override
  void dispose() {
    _eventSub?.cancel();
    // initialized = false;
    // _evaluateJavascriptWeb(data: {'type': 'toIframe: dispose'});
    // log('=================== CONTROLLER DISPOSED ===================');
    super.dispose();
  }

  /// Toolbar widget state to call various methods. For internal use only.
  @override
  ToolbarWidgetState? toolbar;

  /// Determines whether text processing should happen on input HTML, e.g.
  /// whether a new line should be converted to a <br>.
  ///
  /// The default value is true.
  @override
  final bool processInputHtml;

  /// Determines whether newlines (\n) should be written as <br>. This is not
  /// recommended for HTML documents.
  ///
  /// The default value is false.
  @override
  final bool processNewLineAsBr;

  /// Determines whether text processing should happen on output HTML, e.g.
  /// whether <p><br></p> is returned as "". For reference, Summernote uses
  /// that HTML as the default HTML (when no text is in the editor).
  ///
  /// The default value is true.
  @override
  final bool processOutputHtml;

  /// Manages the view ID for the [HtmlEditorController] on web
  String? _viewId;

  /// Internal method to set the view ID when iframe initialization
  /// is complete
  @override
  set viewId(String? viewId) => _viewId = viewId;
  @override
  String get viewId => _viewId!;

  // ignore: prefer_final_fields
  String _buffer = '';

  @override
  bool get isContentEmpty => _buffer == '';

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - //
  // - - - - - - - - METHODS API - - - - - - - - - - - - - - - - - - - - - //
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - //

  /// Sets the focus to the editor.
  @override
  void setFocus() {
    if (!alreadyDisabled) {
      _evaluateJavascriptWeb(data: {'type': 'toIframe: setFocus'});
    }
  }

  /// Clears the focus from the webview
  @override
  void clearFocus() {
    _evaluateJavascriptWeb(data: {'type': 'toIframe: clearFocus'});
  }

  /// disables the Html editor
  @override
  Future<void> disable() async {
    if (alreadyDisabled) return;
    toolbar?.disable();
    await _evaluateJavascriptWeb(data: {'type': 'toIframe: disable'});
    await recalculateHeight();
    notifyListeners();
    alreadyDisabled = true;
  }

  /// enables the Html editor
  @override
  Future<void> enable() async {
    toolbar?.enable();
    await _evaluateJavascriptWeb(data: {'type': 'toIframe: enable'});
    await recalculateHeight();
    notifyListeners();
    setFocus();
    alreadyDisabled = false;
  }

  /// Undoes the last action
  @override
  void undo() {
    _evaluateJavascriptWeb(data: {'type': 'toIframe: undo'});
  }

  /// Redoes the last action
  @override
  void redo() {
    _evaluateJavascriptWeb(data: {'type': 'toIframe: redo'});
  }

  /// Sets the text of the editor. Some pre-processing is applied to convert
  /// [String] elements like "\n" to HTML elements.
  @override
  void setText(String text) {
    text = _processHtml(html: text);
    _evaluateJavascriptWeb(data: {'type': 'toIframe: setText', 'text': text});
    recalculateHeight();
  }

  /// Insert text at the end of the current HTML content in the editor
  /// Note: This method should only be used for plaintext strings
  @override
  Future<void> insertText(String text) async {
    await _evaluateJavascriptWeb(
        data: {'type': 'toIframe: insertText', 'text': text});
  }

  /// Insert HTML at the position of the cursor in the editor
  /// Note: This method should not be used for plaintext strings
  @override
  Future<void> insertHtml(String html) async {
    html = _processHtml(html: html);
    await _evaluateJavascriptWeb(
        data: {'type': 'toIframe: insertHtml', 'html': html});
  }

  /// Gets the text from the editor and returns it as a [String].
  @override
  Future<String> getText() async {
    if (_openRequests.keys.contains('toDart: getText')) {
      _openRequests['toDart: getText']?.completeError('Duplicate request');
      _openRequests.remove('toDart: getText');
    }
    _openRequests.addEntries({'toDart: getText': Completer<String>()}.entries);
    unawaited(_evaluateJavascriptWeb(data: {'type': 'toIframe: getText'}));
    return _openRequests['toDart: getText']?.future as Future<String>;
  }

  /// Clears the editor of any text.
  @override
  Future<void> clear() async {
    await _evaluateJavascriptWeb(data: {'type': 'toIframe: clear'});
  }

  /// toggles the codeview in the Html editor
  @override
  void toggleCodeView() {
    _evaluateJavascriptWeb(data: {'type': 'toIframe: toggleCode'});
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - //
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - //

  @override
  Future<String> getSelectedTextWeb({bool withHtmlTags = false}) async {
    if (withHtmlTags) {
      _openRequests.addEntries(
          {'toIframe: getSelectedTextHtml': Completer<String>()}.entries);
      unawaited(_evaluateJavascriptWeb(
          data: {'type': 'toIframe: getSelectedTextHtml'}));
      return _openRequests['toIframe: getSelectedTextHtml']!.future
          as Future<String>;
    } else {
      _openRequests
          .addEntries({'toDart: getSelectedText': Completer<String>()}.entries);
      unawaited(
          _evaluateJavascriptWeb(data: {'type': 'toIframe: getSelectedText'}));
      return _openRequests['toDart: getSelectedText']!.future as Future<String>;
    }

    // var e = await html.window.onMessage.firstWhere((element) =>
    //     json.decode(element.data)['type'] == 'toDart: getSelectedText');
    // return _openRequests['toDart: getSelectedText']
    //     .future; // json.decode(e.data)['text'];
  }

  /// Sets the editor to full-screen mode.
  // @override
  // void setFullScreen() {
  //   _evaluateJavascriptWeb(data: {'type': 'toIframe: setFullScreen'});
  // }

  /// Sets the hint for the editor.
  // @override
  // void setHint(String text) {
  //   text = _processHtml(html: text);
  //   _evaluateJavascriptWeb(data: {'type': 'toIframe: setHint', 'text': text});
  // }

  /// Insert a link at the position of the cursor in the editor
  @override
  Future<void> insertLink(String text, String url, bool isNewWindow) async {
    await _evaluateJavascriptWeb(data: {
      'type': 'toIframe: makeLink',
      'text': text,
      'url': url,
      'isNewWindow': isNewWindow
    });
  }

  /// Resets the height of the editor back to the original if it was changed to
  /// accommodate the keyboard. This should only be used on mobile, and only
  /// when [adjustHeightForKeyboard] is enabled.
  @override
  void resetHeight() {
    throw Exception(
        'Flutter Web environment detected, please make sure you are importing package:flutter_rich_text_editor/html_editor.dart and check kIsWeb before calling this method.');
  }

  /// Refresh the page
  ///
  /// Note: This should only be used in Flutter Web!!!
  @override
  void reloadWeb() {
    _evaluateJavascriptWeb(data: {'type': 'toIframe: reload'});
  }

  /// Recalculates the height of the editor to remove any vertical scrolling.
  /// This method will not do anything if [autoAdjustHeight] is turned off.
  @override
  Future<void> recalculateHeight() async {
    await _evaluateJavascriptWeb(data: {
      'type': 'toIframe: getHeight',
    });
  }

  /// A function to quickly call a document.execCommand function in a readable format
  @override
  Future<void> execCommand(String command, {String? argument}) async {
    await _evaluateJavascriptWeb(data: {
      'type': 'toIframe: execCommand',
      'command': command,
      'argument': argument
    });
  }

  /// A function to execute JS passed as a [WebScript] to the editor. This should
  /// only be used on Flutter Web.
  @override
  Future<dynamic> evaluateJavascriptWeb(String name,
      {bool hasReturnValue = false}) async {
    if (hasReturnValue) {
      if (_openRequests.keys.contains('toDart: $name') &&
          !_openRequests['toDart: $name']!.isCompleted) {
        _openRequests['toDart: $name']
            ?.completeError('duplicate request on $name');
        _openRequests.remove('toDart: $name');
      }
      _openRequests.addEntries({'toDart: $name': Completer()}.entries);
      unawaited(_evaluateJavascriptWeb(data: {'type': 'toIframe: $name'}));
      return _openRequests['toDart: $name']!.future;
    } else {
      unawaited(_evaluateJavascriptWeb(data: {'type': 'toIframe: $name'}));
    }
  }

  /// Internal function to change list style on Web
  @override
  void changeListStyle(String changed) {
    _evaluateJavascriptWeb(
        data: {'type': 'toIframe: changeListStyle', 'changed': changed});
  }

  /// Internal function to change line height on Web
  @override
  void changeLineHeight(String changed) {
    _evaluateJavascriptWeb(
        data: {'type': 'toIframe: changeLineHeight', 'changed': changed});
  }

  /// Internal function to change text direction on Web
  @override
  void changeTextDirection(String direction) {
    _evaluateJavascriptWeb(data: {
      'type': 'toIframe: changeTextDirection',
      'direction': direction
    });
  }

  /// Internal function to change case on Web
  @override
  void changeCase(String changed) {
    _evaluateJavascriptWeb(
        data: {'type': 'toIframe: changeCase', 'case': changed});
  }

  /// Internal function to insert table on Web
  @override
  void insertTable(String dimensions) {
    _evaluateJavascriptWeb(
        data: {'type': 'toIframe: insertTable', 'dimensions': dimensions});
  }

  /// Helper function to process input html
  String _processHtml({required html}) {
    if (processInputHtml) {
      html = html.replaceAll('\r', '').replaceAll('\r\n', '');
    }
    if (processNewLineAsBr) {
      html = html.replaceAll('\n', '<br/>').replaceAll('\n\n', '<br/>');
    } else {
      html = html.replaceAll('\n', '').replaceAll('\n\n', '');
    }
    return html;
  }

  /// Helper function to run javascript and check current environment
  Future<void> _evaluateJavascriptWeb(
      {required Map<String, Object?> data}) async {
    if (kIsWeb) {
      data['view'] = _viewId;
      final jsonEncoder = JsonEncoder();
      var json = jsonEncoder.convert(data);
      html.window.postMessage(json, '*');
    } else {
      throw Exception(
          'Non-Flutter Web environment detected, please make sure you are importing package:flutter_rich_text_editor/html_editor.dart');
    }
  }

  ///
  Future<bool> _initSpeechToText() async {
    if (sttAvailable) return true;
    speechToText ??= SpeechToText();

    await speechToText!
        .initialize(
      onError: (SpeechRecognitionError? error) {
        if (error == null) {
          throw Exception('The error was thrown, but no details provided.');
        }
        cancelRecording();
        throw Exception(
            'Speech-to-Text Error: ${error.errorMsg} - ${error.permanent}');
      },
      onStatus: log,
      debugLogging: true,
    )
        .then((value) async {
      sttAvailable = value;
    }).onError((error, stackTrace) {
      //setState(mounted, this.setState, () {
      sttAvailable = false;
      //});
      notifyListeners();

      return Future.error(error.toString());
    });
    return sttAvailable;
  }

  ///
  @override
  Future<void> convertSpeechToText(Function(String v) onResult) async {
    if (!await _initSpeechToText()) return;
    //setState(mounted, this.setState, () => isRecording = true);
    isRecording = true;
    notifyListeners();
    await speechToText?.listen(
        onResult: (SpeechRecognitionResult result) {
          if (!result.finalResult) {
            sttBuffer = result.recognizedWords;
            notifyListeners();
            // setState(mounted, this.setState, () {
            //   sttBuffer = result.recognizedWords;
            // });
            return;
          } else {
            onResult(result.recognizedWords);
            if (isRecording) {
              isRecording = false;
              notifyListeners();
              //setState(mounted, this.setState, () => isRecording = false);
            }
          }
        },
        listenFor: const Duration(seconds: 300),
        pauseFor: const Duration(seconds: 300),
        partialResults: true,
        cancelOnError: true,
        listenMode: ListenMode.dictation);
  }

  /// Triggers result from recognition
  @override
  Future<void> stopRecording() async {
    await speechToText?.stop();
    isRecording = false;
    notifyListeners();
    //setState(mounted, this.setState, () => isRecording = false);
    // Save dictation.
    // this delay is needed to let controller inject new text.
    // Otherwise it won't save.
    // Future.delayed(Duration(seconds: 1)).then((value) {
    //   context.read<IRForm>().update(doValidation: false, doUiRefresh: false);
    //   _sttBuffer = '';
    // });
  }

  /// Does not trigger result from recognition
  @override
  Future<void> cancelRecording() async {
    await speechToText?.cancel();
    isRecording = false;
    notifyListeners();
    //setState(mounted, this.setState, () => isRecording = false);
  }

  @override
  Future<void> initEditor(BuildContext initBC, double initHeight) async {
    if (initialized) throw Exception('Already initialized');
    log('================== INIT CALLED ======================');
    log('height: $initHeight');
    await _eventSub?.cancel();
    _eventSub = html.window.onMessage.listen((event) {
      _processEvent(event);
    }, onError: (e, s) {
      _log('Event stream error: ${e.toString()}');
      _log('Stack trace: ${s.toString()}');
    }, onDone: () {
      _log('Event stream done.');
    });

    var headString = '';
    var summernoteCallbacks = '''callbacks: {
        onKeydown: function(e) {
            var chars = \$(".note-editable").text();
            var totalChars = chars.length;
            ${htmlEditorOptions.characterLimit != null ? '''allowedKeys = (
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
            if (!allowedKeys && \$(e.target).text().length >= ${htmlEditorOptions.characterLimit}) {
                e.preventDefault();
            }''' : ''}
            window.parent.postMessage(JSON.stringify({"view": "$viewId", "type": "toDart: characterCount", "totalChars": totalChars}), "*");
        },
    ''';
    var maximumFileSize = 10485760;
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

    summernoteCallbacks = summernoteCallbacks + '}';
    if ((Theme.of(initBC).brightness == Brightness.dark ||
            htmlEditorOptions.darkMode == true) &&
        htmlEditorOptions.darkMode != false) {}
    var userScripts = '';
    if (htmlEditorOptions.webInitialScripts != null) {
      htmlEditorOptions.webInitialScripts!.forEach((element) {
        userScripts = userScripts +
            '''
          if (data["type"].includes("${element.name}")) {
            ${element.script}
          }
        ''' +
            '\n';
      });
    }
    var initScript = 'const viewId = \'$viewId\';';
    var filePath = 'packages/flutter_rich_text_editor/lib/assets/document.html';
    if (htmlEditorOptions.filePath != null) {
      filePath = htmlEditorOptions.filePath!;
    }
    var htmlString = await rootBundle.loadString(filePath);
    htmlString =
        htmlString.replaceFirst('/* - - - Init Script - - - */', initScript);

    /// if no discrete height is provided - hide the scrollbar as the
    /// container height will always adjust to the document height
    if (otherOptions.height == null) {
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
        if (isReadOnly && !alreadyDisabled) {
          await disable();
        }
        if (callbacks != null && callbacks!.onInit != null) {
          callbacks!.onInit!.call();
        }

        // html.window.onMessage.listen((event) {
        //   var data = json.decode(event.data);

        //   if (data['type'] != null &&
        //       data['type'].contains('toDart: onChangeContent') &&
        //       data['view'] == viewId) {
        //     if (htmlEditorOptions.shouldEnsureVisible &&
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
    initialized = true;
    notifyListeners();
  }
}
