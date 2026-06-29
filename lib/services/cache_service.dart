import 'dart:io';
import 'package:path_provider/path_provider.dart';

// Service untuk mengelola caching respon API ke dalam berkas fisik secara lokal
class CacheService {
  static final CacheService _instance = CacheService._internal();

  factory CacheService() => _instance;

  CacheService._internal();

  // Mendapatkan path direktori dokumen lokal perangkat
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  // Mendapatkan referensi berkas File berdasarkan kunci cache yang aman dari karakter ilegal
  Future<File> _getLocalFile(String key) async {
    final path = await _localPath;
    final safeKey = key.replaceAll(RegExp(r'[^a-zA-Z0-9_\-\.]'), '_');
    return File('$path/$safeKey');
  }

  // Menulis konten teks (JSON) ke dalam berkas cache lokal
  Future<void> writeCache(String key, String content) async {
    try {
      final file = await _getLocalFile(key);
      await file.writeAsString(content);
    } catch (_) {}
  }

  // Membaca isi berkas cache lokal jika berkas tersebut ada
  Future<String?> readCache(String key) async {
    try {
      final file = await _getLocalFile(key);
      if (await file.exists()) {
        return await file.readAsString();
      }
    } catch (_) {
      return null;
    }
    return null;
  }

  // Memeriksa apakah berkas cache lokal dengan kunci tertentu tersedia
  Future<bool> hasCache(String key) async {
    try {
      final file = await _getLocalFile(key);
      return await file.exists();
    } catch (_) {
      return false;
    }
  }

  // Menghapus seluruh berkas JSON cache lokal yang tersimpan
  Future<void> clearCache() async {
    try {
      final path = await _localPath;
      final dir = Directory(path);
      if (await dir.exists()) {
        await for (final entity in dir.list()) {
          if (entity is File && entity.path.endsWith('.json')) {
            await entity.delete();
          }
        }
      }
    } catch (_) {}
  }
}
