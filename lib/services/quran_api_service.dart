import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/surah.dart';
import 'cache_service.dart';

// Service API Client untuk mengambil data Al-Quran, detail ayat, dan tafsir dari equran.id dengan dukungan cache lokal
class QuranApiService {
  static const String baseUrl = 'https://equran.id/api/v2';
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

  // Mengambil daftar 114 surat Al-Quran lengkap dengan deskripsi singkat (mendukung offline cache)
  Future<List<Surah>> getSurahList() async {
    const String cacheKey = 'surah_list.json';
    try {
      final response = await http.get(Uri.parse('$baseUrl/surat'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['code'] == 200) {
          await _cacheService.writeCache(cacheKey, response.body);
          List<dynamic> list = data['data'];
          return list.map((json) => Surah.fromJson(json)).toList();
        }
      }
      throw Exception('Gagal memuat daftar surat: ${response.statusCode}');
    } catch (e) {
      final cachedContent = await _cacheService.readCache(cacheKey);
      if (cachedContent != null) {
        final data = json.decode(cachedContent);
        if (data['code'] == 200) {
          List<dynamic> list = data['data'];
          return list.map((json) => Surah.fromJson(json)).toList();
        }
      }
      throw _handleError(e, 'Gagal memuat daftar surat');
    }
  }

  // Mengambil data detail ayat-ayat suatu surat berdasarkan nomor suratnya (mendukung offline cache)
  Future<SurahDetail> getSurahDetail(int nomor) async {
    final String cacheKey = 'surah_detail_$nomor.json';
    try {
      final response = await http.get(Uri.parse('$baseUrl/surat/$nomor'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['code'] == 200) {
          await _cacheService.writeCache(cacheKey, response.body);
          return SurahDetail.fromJson(data['data']);
        }
      }
      throw Exception('Gagal memuat detail surat: ${response.statusCode}');
    } catch (e) {
      final cachedContent = await _cacheService.readCache(cacheKey);
      if (cachedContent != null) {
        final data = json.decode(cachedContent);
        if (data['code'] == 200) {
          return SurahDetail.fromJson(data['data']);
        }
      }
      throw _handleError(e, 'Gagal memuat detail surat');
    }
  }

  // Mengambil data penjelasan tafsir lengkap suatu surat berdasarkan nomor suratnya (mendukung offline cache)
  Future<TafsirDetail> getTafsir(int nomor) async {
    final String cacheKey = 'tafsir_detail_$nomor.json';
    try {
      final response = await http.get(Uri.parse('$baseUrl/tafsir/$nomor'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['code'] == 200) {
          await _cacheService.writeCache(cacheKey, response.body);
          return TafsirDetail.fromJson(data['data']);
        }
      }
      throw Exception('Gagal memuat tafsir surat: ${response.statusCode}');
    } catch (e) {
      final cachedContent = await _cacheService.readCache(cacheKey);
      if (cachedContent != null) {
        final data = json.decode(cachedContent);
        if (data['code'] == 200) {
          return TafsirDetail.fromJson(data['data']);
        }
      }
      throw _handleError(e, 'Gagal memuat tafsir surat');
    }
  }
}
