import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/surah.dart';

// Service API Client untuk mengambil data Al-Quran, detail ayat, dan tafsir dari equran.id
class QuranApiService {
  static const String baseUrl = 'https://equran.id/api/v2';

  // Mengambil daftar 114 surat Al-Quran lengkap dengan deskripsi singkat
  Future<List<Surah>> getSurahList() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/surat'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['code'] == 200) {
          List<dynamic> list = data['data'];
          return list.map((json) => Surah.fromJson(json)).toList();
        }
      }
      throw Exception('Gagal memuat daftar surat: ${response.statusCode}');
    } catch (e) {
      throw Exception('Gagal terhubung ke server: $e');
    }
  }

  // Mengambil data detail ayat-ayat suatu surat berdasarkan nomor suratnya
  Future<SurahDetail> getSurahDetail(int nomor) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/surat/$nomor'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['code'] == 200) {
          return SurahDetail.fromJson(data['data']);
        }
      }
      throw Exception('Gagal memuat detail surat: ${response.statusCode}');
    } catch (e) {
      throw Exception('Gagal terhubung ke server: $e');
    }
  }

  // Mengambil data penjelasan tafsir lengkap suatu surat berdasarkan nomor suratnya
  Future<TafsirDetail> getTafsir(int nomor) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/tafsir/$nomor'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['code'] == 200) {
          return TafsirDetail.fromJson(data['data']);
        }
      }
      throw Exception('Gagal memuat tafsir surat: ${response.statusCode}');
    } catch (e) {
      throw Exception('Gagal terhubung ke server: $e');
    }
  }
}
