import 'dart:convert';
import 'package:http/http.dart' as http;

// Model data untuk merepresentasikan satu hasil pencocokan ayat dalam pencarian global
class SearchMatch {
  final int number;
  final String text;
  final int surahNumber;
  final String surahName;
  final String surahEnglishName;
  final int numberInSurah;

  SearchMatch({
    required this.number,
    required this.text,
    required this.surahNumber,
    required this.surahName,
    required this.surahEnglishName,
    required this.numberInSurah,
  });

  // Membuat objek SearchMatch dari data JSON API Al-Quran Cloud
  factory SearchMatch.fromJson(Map<String, dynamic> json) {
    final surahMap = json['surah'] as Map<String, dynamic>;
    return SearchMatch(
      number: json['number'] as int,
      text: json['text'] as String,
      surahNumber: surahMap['number'] as int,
      surahName: surahMap['name'] as String,
      surahEnglishName: surahMap['englishName'] as String,
      numberInSurah: json['numberInSurah'] as int,
    );
  }
}

// Service API Client untuk mencari kata kunci terjemahan Al-Quran secara global
class SearchService {
  static const String baseUrl = 'https://api.alquran.cloud/v1';

  // Mengirim request pencarian kata kunci terjemahan bahasa Indonesia ke server API alquran.cloud
  Future<List<SearchMatch>> searchAyah(String keyword) async {
    try {
      final encodedKeyword = Uri.encodeComponent(keyword);
      final response = await http.get(
        Uri.parse('$baseUrl/search/$encodedKeyword/all/id.indonesian'),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['code'] == 200) {
          final matchesList = data['data']['matches'] as List<dynamic>;
          return matchesList
              .map((m) => SearchMatch.fromJson(m as Map<String, dynamic>))
              .toList();
        }
      } else if (response.statusCode == 404) {
        // HTTP 404 means no matches found in Al-Quran Cloud API
        return [];
      }
      throw Exception('Server merespon dengan kode ${response.statusCode}');
    } on http.ClientException {
      throw Exception('Tidak dapat terhubung ke server. Silakan periksa koneksi internet Anda.');
    } catch (e) {
      final errStr = e.toString();
      if (errStr.contains('SocketException') || errStr.contains('Network') || errStr.contains('connect')) {
        throw Exception('Koneksi internet tidak tersedia. Silakan hubungkan perangkat Anda ke internet.');
      }
      if (errStr.contains('TimeoutException')) {
        throw Exception('Waktu koneksi habis. Silakan coba beberapa saat lagi.');
      }
      throw Exception('Terjadi kesalahan saat mencari: $e');
    }
  }
}
