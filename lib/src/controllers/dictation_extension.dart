// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

part of 'package:flutter_rich_text_editor/src/controllers/editor_controller.dart';

extension DictationController on HtmlEditorController {
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
      sttAvailable = false;
      notifyListeners();

      return Future.error(error.toString());
    });
    return sttAvailable;
  }

  /// Starts dictation
  Future<void> convertSpeechToText(Function(String v) onResult) async {
    if (!await _initSpeechToText()) return;
    actualHeight += 100;
    isRecording = true;
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
    await recalculateHeight();
    notifyListeners();
  }

  /// Does not trigger result from recognition
  Future<void> cancelRecording() async {
    await speechToText?.cancel();
    isRecording = false;
    await recalculateHeight();
    notifyListeners();
  }
}
