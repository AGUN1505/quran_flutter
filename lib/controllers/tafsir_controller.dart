import 'package:flutter/foundation.dart';
import '../models/surah.dart';
import '../services/quran_api_service.dart';

// Controller untuk mengelola pengambilan data tafsir dari satu surat tertentu
class TafsirController extends ChangeNotifier {
  final QuranApiService _apiService = QuranApiService();
  TafsirDetail? _tafsirDetail;
  bool _isLoading = true;
  String _errorMessage = '';

  TafsirDetail? get tafsirDetail => _tafsirDetail;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Mengambil penjelasan tafsir surat berdasarkan nomor surat
  Future<void> fetchTafsir(int nomor) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _tafsirDetail = await _apiService.getTafsir(nomor);
      _isLoading = false;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
    }
    notifyListeners();
  }
}
