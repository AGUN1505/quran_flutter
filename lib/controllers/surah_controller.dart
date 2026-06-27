import 'package:flutter/foundation.dart';
import '../models/surah.dart';
import '../services/quran_api_service.dart';

class SurahController extends ChangeNotifier {
  static final SurahController _instance = SurahController._internal();

  factory SurahController() {
    return _instance;
  }

  SurahController._internal();

  final QuranApiService _apiService = QuranApiService();
  List<Surah> _allSurah = [];
  List<Surah> _filteredSurah = [];
  bool _isLoading = true;
  String _errorMessage = '';

  List<Surah> get allSurah => _allSurah;
  List<Surah> get filteredSurah => _filteredSurah;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchSurahList() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final list = await _apiService.getSurahList();
      _allSurah = list;
      _filteredSurah = list;
      _isLoading = false;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
    }
    notifyListeners();
  }

  void filterSearch(String query) {
    _filteredSurah = _allSurah
        .where((surah) =>
            surah.namaLatin.toLowerCase().contains(query.toLowerCase()) ||
            surah.arti.toLowerCase().contains(query.toLowerCase()) ||
            surah.nomor.toString() == query)
        .toList();
    notifyListeners();
  }
}
