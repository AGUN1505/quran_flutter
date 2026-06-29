import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/prayer_times_service.dart';
import '../services/notification_service.dart';
import 'notification_settings_controller.dart';

// Controller singleton untuk mengelola pemilihan wilayah dan jadwal waktu sholat
class PrayerTimesController extends ChangeNotifier {
  static final PrayerTimesController _instance = PrayerTimesController._internal();

  factory PrayerTimesController() {
    return _instance;
  }

  // Inisialisasi awal controller dan memuat wilayah terpilih sebelumnya dari penyimpanan
  PrayerTimesController._internal() {
    _loadSavedSelectionAndFetch();
  }

  final PrayerTimesService _service = PrayerTimesService();
  static const String _keyProvince = 'selected_prayer_province_v2';
  static const String _keyCity = 'selected_prayer_city_v2';

  List<String> _provinces = [];
  List<String> _cities = [];
  String _selectedProvince = 'DKI Jakarta';
  String _selectedCity = 'Kota Jakarta Pusat';
  PrayerTimings? _timings;
  bool _isLoading = true;
  String _errorMessage = '';

  List<String> get provinces => _provinces;
  List<String> get cities => _cities;
  String get selectedProvince => _selectedProvince;
  String get selectedCity => _selectedCity;
  PrayerTimings? get timings => _timings;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Memuat daftar provinsi, kota/kabupaten terpilih, lalu mengambil jadwal sholat terkait
  Future<void> _loadSavedSelectionAndFetch() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _provinces = await _service.fetchProvinces();
      if (_provinces.isEmpty) {
        throw Exception('Daftar provinsi kosong dari server.');
      }

      final prefs = await SharedPreferences.getInstance();
      _selectedProvince = prefs.getString(_keyProvince) ?? 'DKI Jakarta';
      if (!_provinces.contains(_selectedProvince)) {
        _selectedProvince = _provinces.contains('DKI Jakarta') ? 'DKI Jakarta' : _provinces.first;
      }

      _cities = await _service.fetchKabKota(_selectedProvince);
      if (_cities.isEmpty) {
        throw Exception('Daftar kabupaten/kota kosong dari server.');
      }

      _selectedCity = prefs.getString(_keyCity) ?? '';
      if (_selectedCity.isEmpty || !_cities.contains(_selectedCity)) {
        final preferred = _cities.firstWhere(
          (c) => c.contains('Jakarta Pusat') || c.contains('Jakarta'),
          orElse: () => _cities.first,
        );
        _selectedCity = preferred;
      }

      await fetchPrayerTimes();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  // Mengambil jadwal sholat aktual hari ini dari server dan menjadwalkan notifikasi adzan lokal
  Future<void> fetchPrayerTimes() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final now = DateTime.now();
      _timings = await _service.getPrayerTimes(
        provinsi: _selectedProvince,
        kabkota: _selectedCity,
        bulan: now.month,
        tahun: now.year,
        day: now.day,
      );
      _isLoading = false;
      // Jadwalkan ulang notifikasi berdasarkan jadwal terbaru
      await NotificationService.schedulePrayerNotifications(
        _timings!,
        NotificationSettingsController(),
      );
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
    }
    notifyListeners();
  }

  // Mengubah provinsi aktif, mengambil ulang daftar kabupaten/kota, dan memperbarui jadwal sholat
  Future<void> setProvince(String province) async {
    if (!_provinces.contains(province)) return;
    _selectedProvince = province;
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _cities = await _service.fetchKabKota(province);
      if (_cities.isNotEmpty) {
        _selectedCity = _cities.first;
      } else {
        _selectedCity = '';
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyProvince, province);
      await prefs.setString(_keyCity, _selectedCity);

      await fetchPrayerTimes();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  // Mengubah kabupaten/kota aktif dan memperbarui jadwal sholat terkait
  Future<void> setCity(String city) async {
    if (!_cities.contains(city)) return;
    _selectedCity = city;
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyCity, city);

      await fetchPrayerTimes();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }
}
