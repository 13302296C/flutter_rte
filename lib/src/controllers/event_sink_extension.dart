// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
part of 'editor_controller.dart';

extension StreamProcessor on HtmlEditorController {
  /// checks if text provided is just an empty paragraph
  bool textHasNoValue(String text) {
    // check if the text starts with empty paragraph
    var pattern1 = r'^<\s*p[^>]*>(<br[ ]?\/?>|&nbsp;|[ ]?)<\s*\/\s*p>';
    // count how many paragraphs we have in that text
    var pattern2 = r'<\s*p[^>]*>(.*?)<\s*\/\s*p>';
    var regex1 = RegExp(pattern1);
    var regex2 = RegExp(pattern2);
    return regex1.hasMatch(text) && regex2.allMatches(text).length == 1;
  }

  /// checks scroll settings and scrolls if needed
  void maybeScrollIntoView() {
    if (context == null || isDisabled || isReadOnly) return;
    // scroll into view with a short delay, to let the keyboard unfold
    // and make experience more smooth
    unawaited(Future.delayed(const Duration(milliseconds: 300)).then((_) {
      unawaited(Scrollable.of(context!).position.ensureVisible(
          context!.findRenderObject()!,
          alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtEnd,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn));
    }));
  }

  /// Process events coming from the iframe
  Future<void> processEvent(String data) async {
    // full response
    Map<String, dynamic> response = json.decode(data);
    if (response['view'] != viewId || response['type'] == null) return;
    if ((response['type'] as String).split(' ')[0] != 'toDart:') return;

    // channel method called
    var channelMethod = (response['type'] as String).split(' ')[1];
    switch (channelMethod) {
      case 'initEditor':
        // success
        if (response['result'] == 'Ok') {
          // On native platform html injection is restricted, so we need
          // to reload the page with new content in it. After the page is loaded,
          // we need to prevent onInit callback and call onChaged instead.
          if (_blockInitCallback) {
            _blockInitCallback = false;
            callbacks.onChangeContent?.call(_buffer);
          } else {
            if (isReadOnly || isDisabled) {
              await disable();
            }
            _initialized = true;
            notifyListeners();
            callbacks.onInit?.call();
          }
          await recalculateContentHeight();
        } else {
          // fail
          _initialized = false;
          notifyListeners();
          throw Exception('HTML Editor failed to load');
        }
        break;

      case 'getSelectedText':
      case 'getSelectedTextHtml':
        if (_openRequests.keys.contains(channelMethod)) {
          _openRequests[channelMethod]?.complete(response['text']);
        }
        break;

      case 'getText':
        if (_openRequests.keys.contains(channelMethod)) {
          String text = response['text'];
          if (processOutputHtml && textHasNoValue(text)) text = '';
          _buffer = text;
          _openRequests[channelMethod]?.complete(text);
        }
        break;

      case 'setHeight':
        contentHeight = response['height'] ?? 0;
        break;

      case 'htmlHeight':
        contentHeight = response['height'].toDouble();
        break;

      case 'updateToolbar':
        toolbar?.updateToolbar(response);
        break;

      // Callbacks = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
      case 'onBeforeCommand':
        callbacks.onBeforeCommand?.call(response['contents']);
        break;

      case 'onChangeContent':
        var previouslyEmpty = _buffer.isEmpty;
        _buffer = response['contents'];
        callbacks.onChangeContent?.call(response['contents']);
        maybeScrollIntoView();
        if (autoAdjustHeight) unawaited(recalculateContentHeight());
        if (previouslyEmpty) notifyListeners();
        break;

      case 'onEnter':
        callbacks.onEnter?.call();
        break;

      case 'onFocus':
        hasFocus = true;
        focusNode?.requestFocus();
        maybeScrollIntoView();
        callbacks.onFocus?.call();
        notifyListeners();
        unawaited(updateToolbar());
        break;

      case 'onBlur':
        hasFocus = false;
        if (textHasNoValue(_buffer)) {
          _buffer = '';
          callbacks.onChangeContent?.call(_buffer);
        }
        callbacks.onBlur?.call();
        break;

      case 'onKeyDown':
      case 'onKeyPress':
        callbacks.onKeyDown?.call(response['keyCode']);
        break;

      case 'onKeyUp':
        callbacks.onKeyUp?.call(response['keyCode']);
        //await recalculateHeight();
        break;

      case 'onMouseDown':
      case 'mouseClick':
        callbacks.onMouseDown?.call();
        break;

      case 'onMouseUp':
        callbacks.onMouseUp?.call();
        break;

      case 'mouseIn':
        callbacks.onMouseIn?.call();
        break;

      case 'mouseOut':
        callbacks.onMouseOut?.call();
        break;

      case 'onPaste':
        callbacks.onPaste?.call();
        break;

      case 'onScroll':
        callbacks.onScroll?.call();
        break;

      case 'characterCount':
        characterCount = response['totalChars'];
        break;

      default:
        _log('Untracked event: $channelMethod');
        break;
    }
    _openRequests.remove(channelMethod);
  }

  void _log(String what, {String tag = 'HtmlEditorController'}) {
    log('${DateTime.now()}[$tag]: $what');
  }
}
