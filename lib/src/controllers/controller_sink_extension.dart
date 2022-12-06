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
        if (response['result'] == 'Ok') {
          if (editorOptions!.initialText != null) {
            setText(editorOptions!.initialText!);
          }
          callbacks?.onInit?.call();
        } else {
          _initialized = false;
          notifyListeners();
          throw Exception('HTML Editor failed to load');
        }
        notifyListeners();
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
        contentHeight.value = response['height'] ?? 0;
        break;

      case 'htmlHeight':
        if (contentHeight.value != response['height'] && autoAdjustHeight) {
          contentHeight.value = response['height'].toDouble();
          notifyListeners();
        }
        break;

      case 'updateToolbar':
        toolbar?.updateToolbar(response);
        break;

      // Callbacks = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
      case 'onBeforeCommand':
        callbacks?.onBeforeCommand?.call(response['contents']);
        break;

      case 'onChangeContent':
        _buffer = response['contents'];
        print(_buffer);
        callbacks?.onChangeContent?.call(response['contents']);
        if (context != null) {
          if (editorOptions!.shouldEnsureVisible &&
              Scrollable.of(context!) != null) {
            unawaited(Scrollable.of(context!)!.position.ensureVisible(
                context!.findRenderObject()!,
                duration: const Duration(milliseconds: 100),
                curve: Curves.easeIn));
          }
        }
        if (autoAdjustHeight) unawaited(recalculateHeight());
        break;

      case 'onChangeCodeview':
        callbacks?.onChangeCodeview?.call(response['contents']);
        break;

      case 'onDialogShown':
        callbacks?.onDialogShown?.call();
        break;

      case 'onEnter':
        callbacks?.onEnter?.call();
        break;

      case 'onFocus':
        hasFocus = true;
        notifyListeners();
        callbacks?.onFocus?.call();
        break;

      case 'onBlur':
        hasFocus = false;
        if (textHasNoValue(_buffer)) {
          _buffer = '';
          callbacks?.onChangeContent?.call(_buffer);
        }
        notifyListeners();
        callbacks?.onBlur?.call();
        break;

      case 'onBlurCodeview':
        callbacks?.onBlurCodeview?.call();
        break;

      // case 'onImageLinkInsert':
      //   callbacks?.onImageLinkInsert?.call(response['url']);
      //   break;

      // case 'onImageUpload':
      //   var map = <String, dynamic>{
      //     'lastModified': response['lastModified'],
      //     'lastModifiedDate': response['lastModifiedDate'],
      //     'name': response['name'],
      //     'size': response['size'],
      //     'type': response['mimeType'],
      //     'base64': response['base64']
      //   };
      //   var jsonStr = json.encode(map);
      //   var file = fileUploadFromJson(jsonStr);
      //   callbacks?.onImageUpload?.call(file);
      //   break;

      // case 'onImageUploadError':
      //   if (response['base64'] != null) {
      //     callbacks?.onImageUploadError?.call(
      //         null,
      //         response['base64'],
      //         response['error'].contains('base64')
      //             ? UploadError.jsException
      //             : response['error'].contains('unsupported')
      //                 ? UploadError.unsupportedFile
      //                 : UploadError.exceededMaxSize);
      //   } else {
      //     var map = <String, dynamic>{
      //       'lastModified': response['lastModified'],
      //       'lastModifiedDate': response['lastModifiedDate'],
      //       'name': response['name'],
      //       'size': response['size'],
      //       'type': response['mimeType']
      //     };
      //     var jsonStr = json.encode(map);
      //     var file = fileUploadFromJson(jsonStr);
      //     callbacks?.onImageUploadError?.call(
      //         file,
      //         null,
      //         response['error'].contains('base64')
      //             ? UploadError.jsException
      //             : response['error'].contains('unsupported')
      //                 ? UploadError.unsupportedFile
      //                 : UploadError.exceededMaxSize);
      //   }
      //   break;

      case 'onKeyDown':
      case 'onKeyPress':
        callbacks?.onKeyDown?.call(response['keyCode']);
        break;

      case 'onKeyUp':
        callbacks?.onKeyUp?.call(response['keyCode']);
        //await recalculateHeight();
        break;

      case 'onMouseDown':
      case 'mouseClick':
        callbacks?.onMouseDown?.call();
        break;

      case 'onMouseUp':
        callbacks?.onMouseUp?.call();
        break;

      case 'mouseIn':
        callbacks?.onMouseIn?.call();
        break;

      case 'mouseOut':
        callbacks?.onMouseOut?.call();
        break;

      case 'onPaste':
        callbacks?.onPaste?.call();
        break;

      case 'onScroll':
        callbacks?.onScroll?.call();
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
