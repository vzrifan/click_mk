import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerService {
  AudioPlayerService._();
  static final AudioPlayerService instance = AudioPlayerService._();

  final AudioPlayer _player = AudioPlayer();

  String? _currentUrl;

  AudioPlayer get player => _player;
  String? get currentUrl => _currentUrl;

  Stream<PlayerState> get playerStateStream => _player.playerStateStream;
  Stream<Duration> get positionStream => _player.positionStream;

  bool isActive(String url) => _currentUrl == url;

  /// Kalau URL sama: toggle play/pause.
  /// Kalau URL beda: ganti sumber dan langsung play.
  Future<void> toggle(String url) async {
    if (_currentUrl == url) {
      if (_player.playing) {
        await _player.pause();
      } else {
        await _player.play();
      }
      return;
    }

    _currentUrl = url;
    try {
      await _player.setUrl(url);
      _player.play();
    } catch (e) {
      debugPrint('Audio error: $e');
      _currentUrl = null;
    }
  }

  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  Future<void> stop() async {
    await _player.stop();
    _currentUrl = null;
  }
}
