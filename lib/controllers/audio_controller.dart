import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';

// Controller singleton untuk mengelola status dan kontrol pemutaran audio Murottal
class AudioController extends ChangeNotifier {
  static final AudioController _instance = AudioController._internal();

  factory AudioController() {
    return _instance;
  }

  final AudioPlayer _audioPlayer = AudioPlayer();
  int? _playingAyahIndex;
  bool _isSurahAudioPlaying = false;

  // Track metadata of active audio
  int? _playingSurahNo;
  String? _playingSurahName;
  int? _playingAyahNo;

  // Track position & duration
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  // Konstruktor internal untuk inisialisasi pendengar event pemutar audio
  AudioController._internal() {
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (state == PlayerState.completed || state == PlayerState.stopped) {
        _playingAyahIndex = null;
        _isSurahAudioPlaying = false;
        _playingSurahNo = null;
        _playingSurahName = null;
        _playingAyahNo = null;
        _duration = Duration.zero;
        _position = Duration.zero;
      }
      notifyListeners();
    });

    _audioPlayer.onDurationChanged.listen((d) {
      _duration = d;
      notifyListeners();
    });

    _audioPlayer.onPositionChanged.listen((p) {
      _position = p;
      notifyListeners();
    });
  }

  int? get playingAyahIndex => _playingAyahIndex;
  bool get isSurahAudioPlaying => _isSurahAudioPlaying;
  bool get isAnyAudioPlaying => _playingAyahIndex != null || _isSurahAudioPlaying;

  int? get playingSurahNo => _playingSurahNo;
  String? get playingSurahName => _playingSurahName;
  int? get playingAyahNo => _playingAyahNo;

  Duration get duration => _duration;
  Duration get position => _position;

  // Memutar audio murottal untuk ayat tertentu dari URL streaming
  Future<void> playAyah({
    required String url,
    required int index,
    required int surahNo,
    required String surahName,
    required int ayahNo,
  }) async {
    try {
      if (_playingAyahIndex == index && _playingSurahNo == surahNo) {
        await _audioPlayer.stop();
        _playingAyahIndex = null;
        _playingSurahNo = null;
        _playingSurahName = null;
        _playingAyahNo = null;
      } else {
        await _audioPlayer.stop();
        _isSurahAudioPlaying = false;
        _playingAyahIndex = index;
        _playingSurahNo = surahNo;
        _playingSurahName = surahName;
        _playingAyahNo = ayahNo;
        await _audioPlayer.play(UrlSource(url));
      }
      notifyListeners();
    } catch (e) {
      _playingAyahIndex = null;
      _playingSurahNo = null;
      _playingSurahName = null;
      _playingAyahNo = null;
      notifyListeners();
      rethrow;
    }
  }

  // Memutar audio murottal satu surat penuh dari URL streaming
  Future<void> playSurahFull({
    required String url,
    required int surahNo,
    required String surahName,
  }) async {
    try {
      if (_isSurahAudioPlaying && _playingSurahNo == surahNo) {
        await _audioPlayer.stop();
        _isSurahAudioPlaying = false;
        _playingSurahNo = null;
        _playingSurahName = null;
        _playingAyahNo = null;
      } else {
        await _audioPlayer.stop();
        _playingAyahIndex = null;
        _isSurahAudioPlaying = true;
        _playingSurahNo = surahNo;
        _playingSurahName = surahName;
        _playingAyahNo = null; // represents entire surah
        await _audioPlayer.play(UrlSource(url));
      }
      notifyListeners();
    } catch (e) {
      _isSurahAudioPlaying = false;
      _playingSurahNo = null;
      _playingSurahName = null;
      _playingAyahNo = null;
      notifyListeners();
      rethrow;
    }
  }

  // Melakukan pause atau resume pada pemutaran audio yang sedang aktif
  Future<void> togglePlayPause() async {
    if (_audioPlayer.state == PlayerState.playing) {
      await _audioPlayer.pause();
    } else if (_audioPlayer.state == PlayerState.paused) {
      await _audioPlayer.resume();
    }
    notifyListeners();
  }

  bool get isPlaying => _audioPlayer.state == PlayerState.playing;

  // Menghentikan pemutaran audio secara total dan mereset status controller
  Future<void> stop() async {
    await _audioPlayer.stop();
    _playingAyahIndex = null;
    _isSurahAudioPlaying = false;
    _playingSurahNo = null;
    _playingSurahName = null;
    _playingAyahNo = null;
    notifyListeners();
  }

  // Memindahkan posisi pemutaran audio ke durasi tertentu
  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
    notifyListeners();
  }

  // Do not dispose singleton player to allow app-wide reuse.
}
