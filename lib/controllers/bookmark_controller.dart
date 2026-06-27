import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookmarkItem {
  final int surahNo;
  final String surahName;
  final int ayahNo;

  BookmarkItem({
    required this.surahNo,
    required this.surahName,
    required this.ayahNo,
  });

  Map<String, dynamic> toJson() => {
        'surahNo': surahNo,
        'surahName': surahName,
        'ayahNo': ayahNo,
      };

  factory BookmarkItem.fromJson(Map<String, dynamic> json) => BookmarkItem(
        surahNo: json['surahNo'] as int,
        surahName: json['surahName'] as String,
        ayahNo: json['ayahNo'] as int,
      );
}

class BookmarkController extends ChangeNotifier {
  static final BookmarkController _instance = BookmarkController._internal();

  factory BookmarkController() {
    return _instance;
  }

  BookmarkController._internal() {
    _loadData();
  }

  static const String _keyLastReadSurahNo = 'last_read_surah_no';
  static const String _keyLastReadSurahName = 'last_read_surah_name';
  static const String _keyLastReadAyahNo = 'last_read_ayah_no';
  static const String _keyBookmarks = 'bookmarks_list';

  int? _lastReadSurahNo;
  String? _lastReadSurahName;
  int? _lastReadAyahNo;
  List<BookmarkItem> _bookmarks = [];

  int? get lastReadSurahNo => _lastReadSurahNo;
  String? get lastReadSurahName => _lastReadSurahName;
  int? get lastReadAyahNo => _lastReadAyahNo;
  List<BookmarkItem> get bookmarks => _bookmarks;

  bool get hasLastRead => _lastReadSurahNo != null && _lastReadAyahNo != null;

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    _lastReadSurahNo = prefs.getInt(_keyLastReadSurahNo);
    _lastReadSurahName = prefs.getString(_keyLastReadSurahName);
    _lastReadAyahNo = prefs.getInt(_keyLastReadAyahNo);

    final bookmarksJson = prefs.getStringList(_keyBookmarks) ?? [];
    _bookmarks = bookmarksJson.map((item) {
      try {
        return BookmarkItem.fromJson(json.decode(item) as Map<String, dynamic>);
      } catch (_) {
        return null;
      }
    }).whereType<BookmarkItem>().toList();

    notifyListeners();
  }

  Future<void> saveLastRead(int surahNo, String surahName, int ayahNo) async {
    _lastReadSurahNo = surahNo;
    _lastReadSurahName = surahName;
    _lastReadAyahNo = ayahNo;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyLastReadSurahNo, surahNo);
    await prefs.setString(_keyLastReadSurahName, surahName);
    await prefs.setInt(_keyLastReadAyahNo, ayahNo);
  }

  Future<void> toggleBookmark(int surahNo, String surahName, int ayahNo) async {
    final index = _bookmarks.indexWhere(
        (b) => b.surahNo == surahNo && b.ayahNo == ayahNo);

    if (index >= 0) {
      _bookmarks.removeAt(index);
    } else {
      _bookmarks.add(BookmarkItem(
        surahNo: surahNo,
        surahName: surahName,
        ayahNo: ayahNo,
      ));
    }
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final jsonList = _bookmarks.map((b) => json.encode(b.toJson())).toList();
    await prefs.setStringList(_keyBookmarks, jsonList);
  }

  bool isBookmarked(int surahNo, int ayahNo) {
    return _bookmarks.any((b) => b.surahNo == surahNo && b.ayahNo == ayahNo);
  }
}
