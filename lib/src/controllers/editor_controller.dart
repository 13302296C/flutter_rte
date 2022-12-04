import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_rich_text_editor/flutter_rich_text_editor.dart';
import 'package:flutter_rich_text_editor/utils/utils.dart';
import 'dart:html' as html;
// speech to text
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import 'editor_interface.dart';

part 'web/editor_interface_events.dart';

/// Controller for web
class HtmlEditorController extends ChangeNotifier {
  HtmlEditorController({
    this.processInputHtml = true,
    this.processNewLineAsBr = false,
    this.processOutputHtml = true,
    this.editorOptions,
    this.toolbarOptions,
  }) : _viewId = getRandString(10).substring(0, 14) {
    _interface = HtmlEditorInterface(_viewId);
    editorOptions ??= HtmlEditorOptions();
    toolbarOptions ??= HtmlToolbarOptions(); //TODO: remove color
  }

  late final HtmlEditorInterface _interface;

  /// Defines options for the html editor
  HtmlEditorOptions? editorOptions;

  /// Defines options for the editor toolbar
  HtmlToolbarOptions? toolbarOptions;

  //late List<Plugins> plugins;

  /// Puts editor in read-only mode, hiding its toollbar
  bool isReadOnly = false;

  /// whether the interface is initialized successfully
  bool initialized = false;

  /// reado only mode
  bool isDisabled = false;

  ///
  bool hasFocus = false;

  /// Toolbar widget state to call various methods. For internal use only.
  ToolbarWidgetState? toolbar;

  /// Sets & activates Summernote's callbacks. See the functions available in
  /// [Callbacks] for more details.
  Callbacks? callbacks;

  ///
  GlobalKey toolbarKey = GlobalKey();

  ///
  ValueNotifier<double> contentHeight = ValueNotifier(64);
  double get actualHeight => contentHeight.value;

  double? _toolbarHeight;
  double? get toolbarHeight => _toolbarHeight;
  set toolbarHeight(double? height) {
    _toolbarHeight = height;
    notifyListeners();
  }

  /// The editor will automatically adjust its height once the page is loaded to
  /// ensure there is no vertical scrolling or empty space. It will only perform
  /// the adjustment when the editor is the loaded page.
  ///
  /// It will also disable vertical scrolling on the webview, so scrolling on
  /// the webview will actually scroll the rest of the page rather than doing
  /// nothing because it is trying to scroll the webview container.
  ///
  /// The default value is true. It is recommended to leave this as true because
  /// it significantly improves the UX.
  bool get autoAdjustHeight => editorOptions!.height == null;

  /// Determines whether text processing should happen on input HTML, e.g.
  /// whether a new line should be converted to a <br>.
  ///
  /// The default value is true.
  final bool processInputHtml;

  /// Determines whether newlines (\n) should be written as <br>. This is not
  /// recommended for HTML documents.
  ///
  /// The default value is false.
  final bool processNewLineAsBr;

  /// Determines whether text processing should happen on output HTML, e.g.
  /// whether <p><br></p> is returned as "". For reference, Summernote uses
  /// that HTML as the default HTML (when no text is in the editor).
  ///
  /// The default value is true.
  final bool processOutputHtml;

  /// Internally tracks the character count in the editor
  int _characterCount = 0;

  /// Gets the current character count
  // ignore: unnecessary_getters_setters
  int get characterCount => _characterCount;

  /// Sets the current character count. Marked as internal method - this should
  /// not be used outside of the package itself.
  // ignore: unnecessary_getters_setters
  set characterCount(int count) => _characterCount = count;

  /// Allows the [InAppWebViewController] for the Html editor to be accessed
  /// outside of the package itself for endless control and customization.
  dynamic get editorController => null;

  /// Internal method to set the [InAppWebViewController] when webview initialization
  /// is complete
  set editorController(dynamic controller) => {};

  /// Internal method to set the view ID when iframe initialization
  /// is complete

  /// Dictation controller
  SpeechToText? speechToText;

  /// is dictation available
  bool sttAvailable = false;

  // /// is dictation running
  bool isRecording = false;

  // /// Dictation result buffer
  String sttBuffer = '';

  ///
  final Map<String, Completer> _openRequests = {};

  ///

  @override
  void dispose() {
    _interface.dispose();
    super.dispose();
  }

  /// Manages the view ID for the [HtmlEditorController] on web
  String _viewId;

  /// Internal method to set the view ID when iframe initialization
  /// is complete

  set viewId(String viewId) => _viewId = viewId;

  String get viewId => _viewId;

  // ignore: prefer_final_fields
  String _buffer = '';

  bool get isContentEmpty => _buffer == '';

  void setInitialText(String text) {
    _buffer = text;
    editorOptions!.initialText = text;
    //
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - //
  // - - - - - - - - METHODS API - - - - - - - - - - - - - - - - - - - - - //
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - //

  /// Sets the focus to the editor.
  void setFocus() {
    if (!isDisabled) {
      _interface.setFocus();
    }
  }

  /// Clears the focus from the webview
  void clearFocus() => _interface.clearFocus();

  /// disables the Html editor
  Future<void> disable() async {
    if (isDisabled) return;
    toolbar?.disable();
    await _interface.disable();
    await recalculateHeight();
    notifyListeners();
    isDisabled = true;
  }

  /// enables the Html editor
  Future<void> enable() async {
    toolbar?.enable();
    await _interface.enable();
    await recalculateHeight();
    notifyListeners();
    setFocus();
    isDisabled = false;
  }

  /// Undoes the last action
  void undo() => _interface.undo();

  /// Redoes the last action
  void redo() => _interface.redo();

  /// Sets the text of the editor. Some pre-processing is applied to convert
  /// [String] elements like "\n" to HTML elements.
  void setText(String text) {
    _interface.setText(_processHtml(html: text));
    recalculateHeight();
  }

  /// Insert text at the end of the current HTML content in the editor
  /// Note: This method should only be used for plaintext strings
  Future<void> insertText(String text) async {
    await _interface.insertText(text);
  }

  /// Insert HTML at the position of the cursor in the editor
  /// Note: This method should not be used for plaintext strings
  Future<void> insertHtml(String html) async {
    html = _processHtml(html: html);
    await _interface.insertHtml(html);
  }

  /// Gets the text from the editor and returns it as a [String].
  Future<String> getText() async {
    if (_openRequests.keys.contains('toDart: getText')) {
      return _openRequests['toDart: getText']?.future as Future<String>;

      // _openRequests['toDart: getText']?.completeError('Duplicate request');
      // _openRequests.remove('toDart: getText');
    }
    _openRequests.addEntries({'toDart: getText': Completer<String>()}.entries);
    unawaited(_interface.getText());
    return _openRequests['toDart: getText']?.future as Future<String>;
  }

  /// Clears the editor of any text.
  Future<void> clear() async {
    await _interface.clear();
  }

  /// toggles the codeview in the Html editor
  void toggleCodeView() {
    _interface.toggleCodeView();
  }

  ///
  Future<String> getSelectedText() async {
    //if (withHtmlTags) {
    _openRequests.addEntries(
        {'toIframe: getSelectedTextHtml': Completer<String>()}.entries);
    unawaited(_interface.getSelectedText());
    return _openRequests['toIframe: getSelectedTextHtml']!.future
        as Future<String>;
    // } else {
    //   _openRequests
    //       .addEntries({'toDart: getSelectedText': Completer<String>()}.entries);
    //   unawaited(
    //       _evaluateJavascriptWeb(data: {'type': 'toIframe: getSelectedText'}));
    //   return _openRequests['toDart: getSelectedText']!.future as Future<String>;
    // }

    // var e = await html.window.onMessage.firstWhere((element) =>
    //     json.decode(element.data)['type'] == 'toDart: getSelectedText');
    // return _openRequests['toDart: getSelectedText']
    //     .future; // json.decode(e.data)['text'];
  }

  /// Insert a link at the position of the cursor in the editor
  Future<void> insertLink(String text, String url, bool isNewWindow) async {
    await _interface.insertLink(text, url, isNewWindow);
  }

  ///
  Future<void> removeLink() async {
    await _interface.removeLink();
  }

  /// Recalculates the height of the editor to remove any vertical scrolling.
  /// This method will not do anything if [autoAdjustHeight] is turned off.
  Future<void> recalculateHeight() async {
    await _interface.recalculateHeight();
  }

  /// A function to quickly call a document.execCommand function in a readable format
  Future<void> execCommand(String command, {String? argument}) async {
    await _interface.execCommand(command, argument: argument);
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - //
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - //

  /// A function to execute JS passed as a [WebScript] to the editor. This should
  /// only be used on Flutter Web.
  // Future<dynamic> evaluateJavascriptWeb(String name,
  //     {bool hasReturnValue = false}) async {
  //   if (hasReturnValue) {
  //     if (_openRequests.keys.contains('toDart: $name') &&
  //         !_openRequests['toDart: $name']!.isCompleted) {
  //       _openRequests['toDart: $name']
  //           ?.completeError('duplicate request on $name');
  //       _openRequests.remove('toDart: $name');
  //     }
  //     _openRequests.addEntries({'toDart: $name': Completer()}.entries);
  //     unawaited(_evaluateJavascriptWeb(data: {'type': 'toIframe: $name'}));
  //     return _openRequests['toDart: $name']!.future;
  //   } else {
  //     unawaited(_evaluateJavascriptWeb(data: {'type': 'toIframe: $name'}));
  //   }
  // }

  /// Internal function to change list style on Web

  // void changeListStyle(String changed) {
  //   _evaluateJavascriptWeb(
  //       data: {'type': 'toIframe: changeListStyle', 'changed': changed});
  // }

  /// Internal function to change line height on Web

  // void changeLineHeight(String changed) {
  //   _evaluateJavascriptWeb(
  //       data: {'type': 'toIframe: changeLineHeight', 'changed': changed});
  // }

  /// Internal function to change text direction on Web

  // void changeTextDirection(String direction) {
  //   _evaluateJavascriptWeb(data: {
  //     'type': 'toIframe: changeTextDirection',
  //     'direction': direction
  //   });
  // }

  // /// Internal function to change case on Web

  // void changeCase(String changed) {
  //   _evaluateJavascriptWeb(
  //       data: {'type': 'toIframe: changeCase', 'case': changed});
  // }

  // /// Internal function to insert table on Web

  // void insertTable(String dimensions) {
  //   _evaluateJavascriptWeb(
  //       data: {'type': 'toIframe: insertTable', 'dimensions': dimensions});
  // }

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

  Future<void> cancelRecording() async {
    await speechToText?.cancel();
    isRecording = false;
    notifyListeners();
    //setState(mounted, this.setState, () => isRecording = false);
  }

  Future<void> initEditor(BuildContext initBC, double initHeight) async {
    if (initialized) throw Exception('Already initialized');
    await _interface.init(initBC, initHeight, this);
    initialized = true;
    notifyListeners();
  }
}
