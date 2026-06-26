import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioController extends ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  int? _playingAyahIndex;
  bool _isSurahAudioPlaying = false;

  AudioController() {
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (state == PlayerState.completed || state == PlayerState.stopped) {
        _playingAyahIndex = null;
        _isSurahAudioPlaying = false;
        notifyListeners();
      }
    });
  }

  int? get playingAyahIndex => _playingAyahIndex;
  bool get isSurahAudioPlaying => _isSurahAudioPlaying;

  Future<void> playAyah(String url, int index) async {
    try {
      if (_playingAyahIndex == index) {
        await _audioPlayer.stop();
        _playingAyahIndex = null;
      } else {
        await _audioPlayer.stop();
        _isSurahAudioPlaying = false;
        _playingAyahIndex = index;
        await _audioPlayer.play(UrlSource(url));
      }
      notifyListeners();
    } catch (e) {
      _playingAyahIndex = null;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> playSurahFull(String url) async {
    try {
      if (_isSurahAudioPlaying) {
        await _audioPlayer.stop();
        _isSurahAudioPlaying = false;
      } else {
        await _audioPlayer.stop();
        _playingAyahIndex = null;
        _isSurahAudioPlaying = true;
        await _audioPlayer.play(UrlSource(url));
      }
      notifyListeners();
    } catch (e) {
      _isSurahAudioPlaying = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
    _playingAyahIndex = null;
    _isSurahAudioPlaying = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
