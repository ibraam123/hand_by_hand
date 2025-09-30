import 'package:flutter_tts/flutter_tts.dart';

class TTSService {
  final FlutterTts _flutterTts = FlutterTts();

  TTSService(String code) {
    _flutterTts.setLanguage(code);
    _flutterTts.setPitch(1.0);
    _flutterTts.setSpeechRate(0.5);   // slower for clarity
  }

  Future<void> speak(String text) async {
    await _flutterTts.stop(); // stop previous speech
    await _flutterTts.speak(text);
  }

  Future<void> stop() async {
    await _flutterTts.stop();
  }
  Future<void> setLanguage(String code) async {
    await _flutterTts.setLanguage(code);
  }
}
