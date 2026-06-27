import 'dart:convert';
import 'package:http/http.dart' as http;

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

class SearchService {
  static const String baseUrl = 'https://api.alquran.cloud/v1';

  Future<List<SearchMatch>> searchAyah(String keyword) async {
    try {
      final encodedKeyword = Uri.encodeComponent(keyword);
      final response = await http.get(
        Uri.parse('$baseUrl/search/$encodedKeyword/all/id.indonesian'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['code'] == 200) {
          final matchesList = data['data']['matches'] as List<dynamic>;
          return matchesList
              .map((m) => SearchMatch.fromJson(m as Map<String, dynamic>))
              .toList();
        }
      }
      throw Exception('Gagal melakukan pencarian: ${response.statusCode}');
    } catch (e) {
      throw Exception('Gagal terhubung ke server pencarian: $e');
    }
  }
}
