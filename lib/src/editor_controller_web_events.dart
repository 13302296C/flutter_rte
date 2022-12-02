// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

part of 'editor_controller_web.dart';

extension StreamProcessor on HtmlEditorController {
  /// Process events coming from the iframe
  Future<void> _processEvent(html.MessageEvent event) async {
    // full response
    Map<String, dynamic> response = json.decode(event.data);
    _log('----- View ID = $viewId');
    if (response['view'] != viewId || response['type'] == null) return;
    if ((response['type'] as String).split(' ')[0] != 'toDart:') return;

    //
    //_log('Event stream data: ${event.data}');

    // channel method called
    var channelMethod = (response['type'] as String).split(' ')[1];

    switch (channelMethod) {
      case 'initEditor':
        if (response['result'] == 'Ok') {
          _log('======= $viewId INIT SUCCESSFUL ==========');
          if (htmlEditorOptions.initialText != null) {
            setText(htmlEditorOptions.initialText!);
          }
        } else {
          _log('======= $viewId INIT FAILED ==========');
        }
        break;
      case 'getSelectedText':
      case 'getSelectedHtml':
        if (_openRequests.keys.contains(channelMethod)) {
          _openRequests[channelMethod]?.complete(response['text']);
        }
        break;

      case 'getText':
        if (_openRequests.keys.contains(channelMethod)) {
          String text = response['text'];
          _buffer = text;
          if (processOutputHtml &&
              (text.isEmpty ||
                  text == '<p></p>' ||
                  text == '<p><br></p>' ||
                  text == '<p><br/></p>')) text = '';
          _openRequests[channelMethod]?.complete(text);
        }

        break;

      case 'setHeight':
        contentHeight.value = response['height'] ?? 0;
        break;

      case 'htmlHeight':
        var refresh =
            contentHeight.value != response['height'] && autoAdjustHeight;
        contentHeight.value = response['height'];

        if (refresh) {
          _log("------ Height: ${response['height']}");
          notifyListeners();
        }

        break;

      case 'updateToolbar':
        toolbar!.updateToolbar(response);
        break;

      // Callbacks = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
      case 'onBeforeCommand':
        callbacks?.onBeforeCommand?.call(response['contents']);
        break;

      case 'onChangeContent':
        if (autoAdjustHeight) unawaited(recalculateHeight());
        callbacks?.onChangeContent?.call(response['contents']);
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
        callbacks?.onFocus?.call();
        break;

      case 'onBlur':
        hasFocus = false;
        callbacks?.onBlur?.call();
        break;

      case 'onBlurCodeview':
        callbacks?.onBlurCodeview?.call();
        break;

      case 'onImageLinkInsert':
        callbacks?.onImageLinkInsert?.call(response['url']);
        break;

      case 'onImageUpload':
        var map = <String, dynamic>{
          'lastModified': response['lastModified'],
          'lastModifiedDate': response['lastModifiedDate'],
          'name': response['name'],
          'size': response['size'],
          'type': response['mimeType'],
          'base64': response['base64']
        };
        var jsonStr = json.encode(map);
        var file = fileUploadFromJson(jsonStr);
        callbacks?.onImageUpload?.call(file);
        break;

      case 'onImageUploadError':
        if (response['base64'] != null) {
          callbacks?.onImageUploadError?.call(
              null,
              response['base64'],
              response['error'].contains('base64')
                  ? UploadError.jsException
                  : response['error'].contains('unsupported')
                      ? UploadError.unsupportedFile
                      : UploadError.exceededMaxSize);
        } else {
          var map = <String, dynamic>{
            'lastModified': response['lastModified'],
            'lastModifiedDate': response['lastModifiedDate'],
            'name': response['name'],
            'size': response['size'],
            'type': response['mimeType']
          };
          var jsonStr = json.encode(map);
          var file = fileUploadFromJson(jsonStr);
          callbacks?.onImageUploadError?.call(
              file,
              null,
              response['error'].contains('base64')
                  ? UploadError.jsException
                  : response['error'].contains('unsupported')
                      ? UploadError.unsupportedFile
                      : UploadError.exceededMaxSize);
        }
        break;

      case 'onKeyDown':
        callbacks?.onKeyDown?.call(response['keyCode']);
        break;

      case 'onKeyUp':
        callbacks?.onKeyUp?.call(response['keyCode']);
        await recalculateHeight();
        break;

      case 'onMouseDown':
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
