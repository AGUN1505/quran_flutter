import 'dart:convert';
import 'package:http/http.dart' as http;

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

// Service API Client untuk mengambil data wilayah sholat dan jadwal sholat Indonesia
class PrayerTimesService {
  static const String baseUrl = 'https://equran.id/api/v2/shalat';

  // Mengambil daftar provinsi lengkap di Indonesia dari server API
  Future<List<String>> fetchProvinces() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/provinsi'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['code'] == 200) {
          final list = data['data'] as List;
          return list.map((e) => e.toString()).toList();
        }
      }
      throw Exception('Gagal memuat daftar provinsi: ${response.statusCode}');
    } catch (e) {
      throw Exception('Gagal terhubung ke server provinsi: $e');
    }
  }

  // Mengambil daftar kabupaten/kota berdasarkan provinsi dari server API
  Future<List<String>> fetchKabKota(String provinsi) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/kabkota'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'provinsi': provinsi}),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['code'] == 200) {
          final list = data['data'] as List;
          return list.map((e) => e.toString()).toList();
        }
      }
      throw Exception('Gagal memuat kabupaten/kota: ${response.statusCode}');
    } catch (e) {
      throw Exception('Gagal terhubung ke server kabupaten/kota: $e');
    }
  }

  // Mengambil jadwal sholat bulanan dan memfilter untuk hari tertentu
  Future<PrayerTimings> getPrayerTimes({
    required String provinsi,
    required String kabkota,
    required int bulan,
    required int tahun,
    required int day,
  }) async {
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
          return PrayerTimings.fromEquranJson(data['data'] as Map<String, dynamic>, day);
        }
      }
      throw Exception('Gagal memuat jadwal sholat: ${response.statusCode}');
    } catch (e) {
      throw Exception('Gagal terhubung ke server jadwal sholat: $e');
    }
  }
}
