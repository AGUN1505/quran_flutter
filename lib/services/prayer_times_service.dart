import 'dart:convert';
import 'package:http/http.dart' as http;
import 'cache_service.dart';

// Model data untuk merepresentasikan waktu sholat harian lengkap
class PrayerTimings {
  final String subuh;
  final String sunrise;
  final String dhuha;
  final String dzuhur;
  final String ashar;
  final String maghrib;
  final String isya;
  final String imsak;
  final String dateReadable;

  PrayerTimings({
    required this.subuh,
    required this.sunrise,
    required this.dhuha,
    required this.dzuhur,
    required this.ashar,
    required this.maghrib,
    required this.isya,
    required this.imsak,
    required this.dateReadable,
  });

  // Membuat objek PrayerTimings dari data JSON API eQuran shalat
  factory PrayerTimings.fromEquranJson(Map<String, dynamic> data, int day) {
    final list = data['jadwal'] as List;
    final item = list.firstWhere(
      (j) => j['tanggal'] == day || j['tanggal'].toString() == day.toString(),
      orElse: () => list.first,
    ) as Map<String, dynamic>;

    return PrayerTimings(
      subuh: item['subuh'] as String? ?? '',
      sunrise: item['terbit'] as String? ?? '',
      dhuha: item['dhuha'] as String? ?? '',
      dzuhur: item['dzuhur'] as String? ?? '',
      ashar: item['ashar'] as String? ?? '',
      maghrib: item['maghrib'] as String? ?? '',
      isya: item['isya'] as String? ?? '',
      imsak: item['imsak'] as String? ?? '',
      dateReadable: '${item['hari'] ?? ''}, ${item['tanggal_lengkap'] ?? ''}',
    );
  }
}

// Service API Client untuk mengambil data wilayah sholat dan jadwal sholat Indonesia dengan dukungan cache lokal
class PrayerTimesService {
  static const String baseUrl = 'https://equran.id/api/v2/shalat';
  final CacheService _cacheService = CacheService();

  // Menerjemahkan exception jaringan menjadi pesan kesalahan bahasa Indonesia yang ramah pengguna
  Exception _handleError(dynamic e, String defaultMessage) {
    final errStr = e.toString().toLowerCase();
    if (errStr.contains('socketexception') ||
        errStr.contains('clientexception') ||
        errStr.contains('failed host lookup') ||
        errStr.contains('failed to connect') ||
        errStr.contains('handshake') ||
        errStr.contains('network') ||
        errStr.contains('timeout')) {
      return Exception('Koneksi internet tidak tersedia atau tidak stabil. Silakan periksa koneksi internet Anda.');
    }
    return Exception('$defaultMessage: ${e.toString().replaceAll('Exception: ', '')}');
  }

  // Mengambil daftar provinsi lengkap di Indonesia dari server API (mendukung offline cache)
  Future<List<String>> fetchProvinces() async {
    const String cacheKey = 'provinces.json';
    try {
      final response = await http.get(Uri.parse('$baseUrl/provinsi'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['code'] == 200) {
          await _cacheService.writeCache(cacheKey, response.body);
          final list = data['data'] as List;
          return list.map((e) => e.toString()).toList();
        }
      }
      throw Exception('Gagal memuat daftar provinsi: ${response.statusCode}');
    } catch (e) {
      final cachedContent = await _cacheService.readCache(cacheKey);
      if (cachedContent != null) {
        final Map<String, dynamic> data = json.decode(cachedContent);
        if (data['code'] == 200) {
          final list = data['data'] as List;
          return list.map((e) => e.toString()).toList();
        }
      }
      throw _handleError(e, 'Gagal memuat daftar provinsi');
    }
  }

  // Mengambil daftar kabupaten/kota berdasarkan provinsi dari server API (mendukung offline cache)
  Future<List<String>> fetchKabKota(String provinsi) async {
    final String cacheKey = 'kabkota_$provinsi.json';
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/kabkota'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'provinsi': provinsi}),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['code'] == 200) {
          await _cacheService.writeCache(cacheKey, response.body);
          final list = data['data'] as List;
          return list.map((e) => e.toString()).toList();
        }
      }
      throw Exception('Gagal memuat kabupaten/kota: ${response.statusCode}');
    } catch (e) {
      final cachedContent = await _cacheService.readCache(cacheKey);
      if (cachedContent != null) {
        final Map<String, dynamic> data = json.decode(cachedContent);
        if (data['code'] == 200) {
          final list = data['data'] as List;
          return list.map((e) => e.toString()).toList();
        }
      }
      throw _handleError(e, 'Gagal memuat kabupaten/kota');
    }
  }

  // Mengambil jadwal sholat bulanan dan memfilter untuk hari tertentu (mendukung offline cache bulanan)
  Future<PrayerTimings> getPrayerTimes({
    required String provinsi,
    required String kabkota,
    required int bulan,
    required int tahun,
    required int day,
  }) async {
    final String cacheKey = 'prayer_times_${provinsi}_${kabkota}_${bulan}_$tahun.json';
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'provinsi': provinsi,
          'kabkota': kabkota,
          'bulan': bulan,
          'tahun': tahun,
        }),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['code'] == 200) {
          await _cacheService.writeCache(cacheKey, response.body);
          return PrayerTimings.fromEquranJson(data['data'] as Map<String, dynamic>, day);
        }
      }
      throw Exception('Gagal memuat jadwal sholat: ${response.statusCode}');
    } catch (e) {
      final cachedContent = await _cacheService.readCache(cacheKey);
      if (cachedContent != null) {
        final Map<String, dynamic> data = json.decode(cachedContent);
        if (data['code'] == 200) {
          return PrayerTimings.fromEquranJson(data['data'] as Map<String, dynamic>, day);
        }
      }
      throw _handleError(e, 'Gagal memuat jadwal sholat');
    }
  }
}
