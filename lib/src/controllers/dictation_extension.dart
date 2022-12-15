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
          fault = Exception('The error was thrown, but no details provided.');
        }
        cancelRecording();
        fault = Exception(
            'Speech-to-Text Error: ${err?.errorMsg} - ${err?.permanent}');
      },
      onStatus: log,
      debugLogging: kDebugMode,
    )
        .then((value) async {
      sttAvailable = value;
      notifyListeners();
    }).onError((error, stackTrace) {
      sttAvailable = false;
      notifyListeners();

      return Future.error(error.toString());
    });
    return sttAvailable;
  }

  /// Starts dictation
  Future<void> convertSpeechToText(Function(String v) onResult) async {
    if (!await _initSpeechToText()) return;
    isRecording = true;
    contentHeight += 100;
    notifyListeners();
    await speechToText?.listen(
        onResult: (SpeechRecognitionResult result) {
          if (!result.finalResult) {
            sttBuffer = result.recognizedWords;
            notifyListeners();
            return;
          } else {
            onResult(result.recognizedWords);
            if (isRecording) {
              isRecording = false;
              notifyListeners();
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
    await recalculateContentHeight();
    notifyListeners();
  }

  /// Does not trigger result from recognition
  Future<void> cancelRecording() async {
    await speechToText?.cancel();
    isRecording = false;
    await recalculateContentHeight();
    notifyListeners();
  }
}
