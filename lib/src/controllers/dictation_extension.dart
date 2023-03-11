// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

part of 'package:flutter_rte/src/controllers/editor_controller.dart';

extension DictationController on HtmlEditorController {
  ///
  Future<bool> _initSpeechToText() async {
    if (SpeechToText().hasError) return false;
    await SpeechToText()
        .initialize(
      onError: (SpeechRecognitionError? err) {
        if (err == null) {
          fault = Exception('Speech-to-Text Error: no details provided.');
        }
        cancelRecording();
        setFault(Exception(
            'Speech-to-Text Error: ${err?.errorMsg}')); // - ${err?.permanent}
        notifyListeners();
      },
      debugLogging: kDebugMode,
    )
        .then((value) async {
      notifyListeners();
      return value;
    }).onError((error, stackTrace) {
      log("Speech to text init error:", error: error, stackTrace: stackTrace);
      notifyListeners();
      return false;
    });
    return sttAvailable;
  }

  /// Starts dictation
  Future<void> convertSpeechToText(Function(String v) onResult) async {
    if (!await _initSpeechToText()) return;
    sttBuffer = '';
    //setIsRecording(true);
    SpeechToText().statusListener = (String? status) {
      log('Speech-to-Text Status: $status');
      if (status == 'notListening' || status == 'done') {
        if (isRecording) {
          setIsRecording(false);
        }
      } else if (status == 'listening') {
        if (!isRecording) {
          setIsRecording(true);
        }
      }
    };
    await SpeechToText().listen(
        onResult: (SpeechRecognitionResult result) async {
          if (!result.finalResult) {
            setSttBuffer(result.recognizedWords);
            return;
          } else {
            if (result.recognizedWords.isNotEmpty) {
              await insertHtml(result.recognizedWords);
            }
            onResult(result.recognizedWords);
          }
        },
        listenFor: const Duration(seconds: 300),
        pauseFor: const Duration(seconds: 5),
        partialResults: true,
        cancelOnError: true,
        listenMode: ListenMode.dictation);
  }

  /// Triggers result from recognition
  Future<void> stopRecording() async {
    setIsRecording(false);
    await SpeechToText().stop();
    await recalculateContentHeight();
  }

  /// Does not trigger result from recognition
  Future<void> cancelRecording() async {
    setIsRecording(false);
    await SpeechToText().cancel();
    await recalculateContentHeight();
  }
}
