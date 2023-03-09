// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

part of 'package:flutter_rte/src/controllers/editor_controller.dart';

extension DictationController on HtmlEditorController {
  ///
  Future<bool> _initSpeechToText() async {
    if (sttAvailable) return true;
    speechToText ??= SpeechToText();

    await speechToText!
        .initialize(
      onError: (SpeechRecognitionError? err) {
        if (err == null) {
          fault = Exception('Speech-to-Text Error: no details provided.');
        }
        cancelRecording();
        fault = Exception(
            'Speech-to-Text Error: ${err?.errorMsg}'); // - ${err?.permanent}
        sttAvailable = false;
        notifyListeners();
      },
      onStatus: (String? status) {
        log('Speech-to-Text Status: $status');
        if (status == 'notListening' || status == 'done') {
          if (isRecording) {
            isRecording = false;
            notifyListeners();
          }
        } else if (status == 'listening') {
          if (!isRecording) {
            isRecording = true;
            notifyListeners();
          }
        }
      },
      debugLogging: kDebugMode,
    )
        .then((value) async {
      sttAvailable = value;
      notifyListeners();
    }).onError((error, stackTrace) {
      log("Speech to text init error:", error: error, stackTrace: stackTrace);
      sttAvailable = false;
      notifyListeners();
      return Future.error(error.toString());
    });
    return sttAvailable;
  }

  /// Starts dictation
  Future<void> convertSpeechToText(Function(String v) onResult) async {
    if (!await _initSpeechToText()) return;
    sttBuffer = '';
    await speechToText?.listen(
        onResult: (SpeechRecognitionResult result) async {
          if (!result.finalResult) {
            sttBuffer = result.recognizedWords;
            notifyListeners();
            return;
          } else {
            if (result.recognizedWords.isNotEmpty) {
              await insertHtml(result.recognizedWords);
            }
            onResult(result.recognizedWords);
            sttBuffer = '';
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
    await recalculateContentHeight();
  }

  /// Does not trigger result from recognition
  Future<void> cancelRecording() async {
    await speechToText?.cancel();
    await recalculateContentHeight();
  }
}
