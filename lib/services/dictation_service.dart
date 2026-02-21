import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

/// Service that manages speech-to-text dictation.
/// Initialize once per app session; use [startListening], [stopListening], [toggle].
class DictationService extends ChangeNotifier {
  DictationService() {
    _init();
  }

  final SpeechToText _speech = SpeechToText();

  bool _isInitialized = false;
  bool _isListening = false;
  String _transcript = '';
  String _partialWords = '';
  String? _initError;

  bool get isInitialized => _isInitialized;
  bool get isListening => _isListening;
  String get transcript => _transcript;
  String get partialWords => _partialWords;
  String? get initError => _initError;

  /// Combined display: transcript + any in-progress partial words.
  String get displayText {
    if (_partialWords.isNotEmpty) {
      return _transcript.isEmpty ? _partialWords : '$_transcript $_partialWords';
    }
    return _transcript;
  }

  Future<void> _init() async {
    _isInitialized = await _speech.initialize(
      onStatus: (status) => debugPrint('Speech status: $status'),
      onError: (error) {
        debugPrint('Speech error: $error');
        _initError = error.errorMsg;
        notifyListeners();
      },
    );
    notifyListeners();
  }

  Future<void> startListening() async {
    if (!_isInitialized || _isListening) return;

    _isListening = true;
    _partialWords = '';
    notifyListeners();

    await _speech.listen(
      onResult: _onSpeechResult,
      listenFor: const Duration(seconds: 60),
      pauseFor: const Duration(seconds: 5),
      listenOptions: SpeechListenOptions(partialResults: true),
    );
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    if (result.finalResult) {
      if (result.recognizedWords.isNotEmpty) {
        _transcript = _transcript.isEmpty
            ? result.recognizedWords
            : '$_transcript ${result.recognizedWords}';
      }
      _partialWords = '';
    } else {
      _partialWords = result.recognizedWords;
    }
    notifyListeners();
  }

  Future<void> stopListening() async {
    if (!_isListening) return;

    await _speech.stop();
    _isListening = false;
    _partialWords = '';
    notifyListeners();
  }

  Future<void> toggle() async {
    if (_isListening) {
      await stopListening();
    } else {
      await startListening();
    }
  }

  void clearTranscript() {
    _transcript = '';
    _partialWords = '';
    notifyListeners();
  }
}
