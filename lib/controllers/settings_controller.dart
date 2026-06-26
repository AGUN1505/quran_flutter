import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends ChangeNotifier {
  static final SettingsController _instance = SettingsController._internal();

  factory SettingsController() {
    return _instance;
  }

  SettingsController._internal() {
    _loadSettings();
  }

  static const String _keyThemeMode = 'theme_mode';
  static const String _keyArabicFontSize = 'arabic_font_size';
  static const String _keyTranslationFontSize = 'translation_font_size';

  ThemeMode _themeMode = ThemeMode.light;
  double _arabicFontSize = 26.0;
  double _translationFontSize = 13.0;

  ThemeMode get themeMode => _themeMode;
  double get arabicFontSize => _arabicFontSize;
  double get translationFontSize => _translationFontSize;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(_keyThemeMode) ?? 0;
    _themeMode = ThemeMode.values[themeIndex];
    _arabicFontSize = prefs.getDouble(_keyArabicFontSize) ?? 26.0;
    _translationFontSize = prefs.getDouble(_keyTranslationFontSize) ?? 13.0;
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyThemeMode, mode.index);
  }

  Future<void> setArabicFontSize(double size) async {
    _arabicFontSize = size;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_keyArabicFontSize, size);
  }

  Future<void> setTranslationFontSize(double size) async {
    _translationFontSize = size;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_keyTranslationFontSize, size);
  }

  Future<void> toggleTheme(bool isDark) async {
    await setThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
  }
}
