import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/surah.dart';

class QuranApiService {
  static const String baseUrl = 'https://equran.id/api/v2';

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
