import 'package:speech_to_text/speech_to_text.dart' as stt;

/// Wraps the `speech_to_text` plugin, which uses the device's
/// built-in (OS-level) speech recognition — NOT a large cloud AI
/// model — so voice input stays fast, free, and lightweight.
///
/// This lets the user tap the mic button and speak their message
/// instead of typing it.
class VoiceService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isInitialized = false;

  Future<bool> initialize() async {
    if (_isInitialized) return true;
    _isInitialized = await _speech.initialize(
      onError: (error) => print('Speech recognition error: $error'),
      onStatus: (status) => print('Speech recognition status: $status'),
    );
    return _isInitialized;
  }

  bool get isListening => _speech.isListening;

  bool get isAvailable => _speech.isAvailable;

  /// Starts listening and streams partial/final transcriptions via
  /// [onResult]. Call [stopListening] to end early.
  Future<void> startListening({
    required void Function(String text) onResult,
  }) async {
    final available = await initialize();
    if (!available) {
      throw Exception(
        "Voice input isn't available on this device/browser. "
        "Please check microphone permissions.",
      );
    }

    await _speech.listen(
      onResult: (result) => onResult(result.recognizedWords),
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 4),
      partialResults: true,
      cancelOnError: true,
    );
  }

  Future<void> stopListening() async {
    await _speech.stop();
  }
}
