import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Pilihan suara adzan untuk notifikasi
enum AdzanSound {
  mekah,      // Adzan Masjidil Haram
  madinah,    // Adzan Masjid Nabawi
  pendek,     // Adzan versi pendek
  defaultSystem, // Suara notifikasi bawaan HP
}

// Ekstensi untuk mendapatkan atribut representatif dari tipe suara AdzanSound
extension AdzanSoundExtension on AdzanSound {
  // Mendapatkan label teks nama suara adzan dalam Bahasa Indonesia
  String get label {
    switch (this) {
      case AdzanSound.mekah:     return 'Adzan Mekah';
      case AdzanSound.madinah:   return 'Adzan Madinah';
      case AdzanSound.pendek:    return 'Adzan Pendek';
      case AdzanSound.defaultSystem: return 'Suara Bawaan HP';
    }
  }

  /// Nama file di android/app/src/main/res/raw/ (tanpa ekstensi)
  String? get rawFileName {
    switch (this) {
      case AdzanSound.mekah:     return 'adzan_mekah';
      case AdzanSound.madinah:   return 'adzan_madinah';
      case AdzanSound.pendek:    return 'adzan_pendek';
      case AdzanSound.defaultSystem: return null;
    }
  }

  /// ID channel notifikasi Android (berbeda per suara agar Android bisa mengganti sound)
  String get channelId {
    switch (this) {
      case AdzanSound.mekah:     return 'prayer_adzan_mekah';
      case AdzanSound.madinah:   return 'prayer_adzan_madinah';
      case AdzanSound.pendek:    return 'prayer_adzan_pendek';
      case AdzanSound.defaultSystem: return 'prayer_default';
    }
  }

  // Mendapatkan nama deskriptif dari channel notifikasi Android
  String get channelName {
    switch (this) {
      case AdzanSound.mekah:     return 'Waktu Sholat (Adzan Mekah)';
      case AdzanSound.madinah:   return 'Waktu Sholat (Adzan Madinah)';
      case AdzanSound.pendek:    return 'Waktu Sholat (Adzan Pendek)';
      case AdzanSound.defaultSystem: return 'Waktu Sholat';
    }
  }
}

// Controller singleton untuk mengelola pengaturan aktifasi notifikasi dan suara adzan per waktu sholat
class NotificationSettingsController extends ChangeNotifier {
  static final NotificationSettingsController _instance =
      NotificationSettingsController._internal();

  factory NotificationSettingsController() => _instance;

  // Inisialisasi awal controller dan memuat data preferensi tersimpan
  NotificationSettingsController._internal() {
    _loadSettings();
  }

  static const String _keySound        = 'notif_sound';
  static const String _keyEnabled      = 'notif_enabled_global';
  static const String _keyImsak        = 'notif_imsak';
  static const String _keySubuh        = 'notif_subuh';
  static const String _keyDzuhur       = 'notif_dzuhur';
  static const String _keyAshar        = 'notif_ashar';
  static const String _keyMaghrib      = 'notif_maghrib';
  static const String _keyIsya         = 'notif_isya';

  AdzanSound _selectedSound = AdzanSound.mekah;
  bool _globalEnabled = true;
  bool _imsakEnabled  = true;
  bool _subuhEnabled  = true;
  bool _dzuhurEnabled = true;
  bool _asharEnabled  = true;
  bool _maghribEnabled = true;
  bool _isyaEnabled   = true;

  AdzanSound get selectedSound => _selectedSound;
  bool get globalEnabled  => _globalEnabled;
  bool get imsakEnabled   => _imsakEnabled;
  bool get subuhEnabled   => _subuhEnabled;
  bool get dzuhurEnabled  => _dzuhurEnabled;
  bool get asharEnabled   => _asharEnabled;
  bool get maghribEnabled => _maghribEnabled;
  bool get isyaEnabled    => _isyaEnabled;

  // Memuat pengaturan notifikasi dari SharedPreferences penyimpanan lokal
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final soundIndex = prefs.getInt(_keySound) ?? 0;
    _selectedSound   = AdzanSound.values[soundIndex.clamp(0, AdzanSound.values.length - 1)];
    _globalEnabled   = prefs.getBool(_keyEnabled)  ?? true;
    _imsakEnabled    = prefs.getBool(_keyImsak)    ?? true;
    _subuhEnabled    = prefs.getBool(_keySubuh)    ?? true;
    _dzuhurEnabled   = prefs.getBool(_keyDzuhur)   ?? true;
    _asharEnabled    = prefs.getBool(_keyAshar)    ?? true;
    _maghribEnabled  = prefs.getBool(_keyMaghrib)  ?? true;
    _isyaEnabled     = prefs.getBool(_keyIsya)     ?? true;
    notifyListeners();
  }

  // Menyimpan suara adzan pilihan baru ke penyimpanan lokal
  Future<void> setSound(AdzanSound sound) async {
    _selectedSound = sound;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keySound, sound.index);
  }

  // Menyimpan status aktifasi notifikasi global ke penyimpanan lokal
  Future<void> setGlobalEnabled(bool value) async {
    _globalEnabled = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyEnabled, value);
  }

  // Menyimpan status aktifasi notifikasi waktu Imsak ke penyimpanan lokal
  Future<void> setImsakEnabled(bool value) async {
    _imsakEnabled = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyImsak, value);
  }

  // Menyimpan status aktifasi notifikasi waktu Subuh ke penyimpanan lokal
  Future<void> setSubuhEnabled(bool value) async {
    _subuhEnabled = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keySubuh, value);
  }

  // Menyimpan status aktifasi notifikasi waktu Dzuhur ke penyimpanan lokal
  Future<void> setDzuhurEnabled(bool value) async {
    _dzuhurEnabled = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyDzuhur, value);
  }

  // Menyimpan status aktifasi notifikasi waktu Ashar ke penyimpanan lokal
  Future<void> setAsharEnabled(bool value) async {
    _asharEnabled = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyAshar, value);
  }

  // Menyimpan status aktifasi notifikasi waktu Maghrib ke penyimpanan lokal
  Future<void> setMaghribEnabled(bool value) async {
    _maghribEnabled = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyMaghrib, value);
  }

  // Menyimpan status aktifasi notifikasi waktu Isya ke penyimpanan lokal
  Future<void> setIsyaEnabled(bool value) async {
    _isyaEnabled = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsya, value);
  }
}
