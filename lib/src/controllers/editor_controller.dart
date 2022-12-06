import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rich_text_editor/flutter_rich_text_editor.dart';
import 'package:flutter_rich_text_editor/utils/utils.dart';

import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import 'package:flutter_rich_text_editor/src/controllers/editor_controller_mixin_stub.dart'
    if (dart.library.io) 'package:flutter_rich_text_editor/src/controllers/editor_controller_mixin_native.dart'
    if (dart.library.html) 'package:flutter_rich_text_editor/src/controllers/editor_controller_mixin_web.dart';

part 'controller_sink_extension.dart';
part 'dictation_extension.dart';

/// Controller for web
class HtmlEditorController with ChangeNotifier, PlatformSpecificMixin {
  HtmlEditorController({
    this.processInputHtml = true,
    this.processNewLineAsBr = false,
    this.processOutputHtml = true,
    this.editorOptions,
    this.toolbarOptions,
    this.context,
  }) {
    viewId = getRandString(10).substring(0, 14);
    editorOptions ??= HtmlEditorOptions();
    toolbarOptions ??= HtmlToolbarOptions();
  }

  ///
  BuildContext? context;

  /// Defines options for the html editor
  HtmlEditorOptions? editorOptions;

  /// Defines options for the editor toolbar
  HtmlToolbarOptions? toolbarOptions;

  //late List<Plugins> plugins;

  /// Puts editor in read-only mode, hiding its toollbar
  bool isReadOnly = false;

  /// If enabled - shows microphone icon and allows to use dictation within
  /// the editor
  bool enableDicatation = true;

  /// whether the interface is initialized successfully
  bool get initialized => _initialized;
  // ignore: prefer_final_fields
  bool _initialized = false;

  /// read only mode
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
  set actualHeight(double height) => contentHeight.value = height;

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

  ///
  final Map<String, Completer> _openRequests = {};

  /// Dictation controller
  SpeechToText? speechToText;

  /// is dictation available
  bool sttAvailable = false;

  // /// is dictation running
  bool isRecording = false;

  // /// Dictation result buffer
  String sttBuffer = '';

  @override
  void dispose() {
    super.dispose();
  }

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
    if (!isDisabled) evaluateJavascript(data: {'type': 'toIframe: setFocus'});
  }

  /// Clears the focus from the webview
  void clearFocus() =>
      evaluateJavascript(data: {'type': 'toIframe: clearFocus'});

  /// disables the Html editor
  Future<void> disable() async {
    if (isDisabled) return;
    toolbar?.disable();
    await evaluateJavascript(data: {'type': 'toIframe: disable'});
    await recalculateHeight();
    notifyListeners();
    isDisabled = true;
  }

  /// enables the Html editor
  Future<void> enable() async {
    toolbar?.enable();
    await evaluateJavascript(data: {'type': 'toIframe: enable'});
    await recalculateHeight();
    isDisabled = false;
    notifyListeners();
    setFocus();
  }

  /// Undoes the last action
  void undo() => evaluateJavascript(data: {'type': 'toIframe: undo'});

  /// Redoes the last action
  void redo() => evaluateJavascript(data: {'type': 'toIframe: redo'});

  /// Sets the text of the editor. Some pre-processing is applied to convert
  /// [String] elements like "\n" to HTML elements.
  void setText(String text) {
    evaluateJavascript(data: {'type': 'toIframe: setText', 'text': text});
    recalculateHeight();
  }

  /// Insert text at the end of the current HTML content in the editor
  /// Note: This method should only be used for plaintext strings
  Future<void> insertText(String text) async {
    await evaluateJavascript(
        data: {'type': 'toIframe: insertText', 'text': text});
  }

  /// Insert HTML at the position of the cursor in the editor
  /// Note: This method should not be used for plaintext strings
  Future<void> insertHtml(String html) async {
    await evaluateJavascript(data: {
      'type': 'toIframe: insertHtml',
      'html': _processHtml(html: html)
    });
  }

  /// Gets the text from the editor and returns it as a [String].
  Future<String> getText() async {
    if (_openRequests.keys.contains('toDart: getText')) {
      return _openRequests['toDart: getText']?.future as Future<String>;

      // _openRequests['toDart: getText']?.completeError('Duplicate request');
      // _openRequests.remove('toDart: getText');
    }
    _openRequests.addEntries({'toDart: getText': Completer<String>()}.entries);
    unawaited(evaluateJavascript(data: {'type': 'toIframe: getText'}));
    return _openRequests['toDart: getText']?.future as Future<String>;
  }

  /// Clears the editor of any text.
  Future<void> clear() async {
    await evaluateJavascript(data: {'type': 'toIframe: clear'});
  }

  /// toggles the codeview in the Html editor
  void toggleCodeView() {
    evaluateJavascript(data: {'type': 'toIframe: toggleCode'});
  }

  ///
  Future<String> getSelectedText() async {
    _openRequests
        .addEntries({'getSelectedTextHtml': Completer<String>()}.entries);
    unawaited(
        evaluateJavascript(data: {'type': 'toIframe: getSelectedTextHtml'}));
    return _openRequests['getSelectedTextHtml']!.future as Future<String>;
  }

  /// Insert a link at the position of the cursor in the editor
  Future<void> insertLink(String text, String url, bool isNewWindow) async {
    await evaluateJavascript(data: {
      'type': 'toIframe: makeLink',
      'text': text,
      'url': url,
      'isNewWindow': isNewWindow
    });
  }

  ///
  Future<void> removeLink() async {
    await evaluateJavascript(data: {'type': 'toIframe: removeLink'});
  }

  /// Recalculates the height of the editor to remove any vertical scrolling.
  /// This method will not do anything if [autoAdjustHeight] is turned off.
  Future<void> recalculateHeight() async {
    await evaluateJavascript(data: {
      'type': 'toIframe: getHeight',
    });
  }

  /// A function to quickly call a document.execCommand function in a readable format
  Future<void> execCommand(String command, {String? argument}) async {
    await evaluateJavascript(data: {
      'type': 'toIframe: execCommand',
      'command': command,
      'argument': argument
    });
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
  Future<void> initEditor(BuildContext initBC, double initHeight) async {
    if (initialized) throw Exception('Already initialized');
    await init(initBC, initHeight, this);
    _initialized = true;
    notifyListeners();
  }

  ///
  Future<String> getInitialContent() async {
    var initScript = 'const viewId = \'$viewId\';';
    if (kIsWeb) {
      initScript += '''
const isNativePlatform = false;
''';
    } else {
      initScript += '''
const isNativePlatform = true;
''';
    }
    var htmlString = await rootBundle.loadString(filePath);
    htmlString =
        htmlString.replaceFirst('/* - - - Init Script - - - */', initScript);

    /// if no explicit `height` is provided - hide the scrollbar as the
    /// container height will always adjust to the document height.
    /// If the height is set - add padding for the boxed layouts.
    var hideScrollbarCss = '';
    if (editorOptions!.height == null) {
      hideScrollbarCss = '''
  ::-webkit-scrollbar {
    width: 0px;
    height: 0px;
  }
''';
    } else {
      hideScrollbarCss = '''
  body {
    padding: .5em 1em;
  }
''';
    }

    htmlString = htmlString.replaceFirst(
        '/* - - - Hide Scrollbar - - - */', hideScrollbarCss);
    return htmlString;
  }
}
