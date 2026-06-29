import 'package:flutter/foundation.dart';
import '../models/surah.dart';
import '../services/quran_api_service.dart';

// Controller untuk mengelola pengambilan data ayat detail dari satu surat tertentu
class SurahDetailController extends ChangeNotifier {
  final QuranApiService _apiService = QuranApiService();
  SurahDetail? _surahDetail;
  bool _isLoading = true;
  String _errorMessage = '';

  SurahDetail? get surahDetail => _surahDetail;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Mengambil detail surat dan ayat-ayatnya berdasarkan nomor surat
  Future<void> fetchDetail(int nomor) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _surahDetail = await _apiService.getSurahDetail(nomor);
      _isLoading = false;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
    }
    notifyListeners();
  }
}
