import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LatinTextSizeProvider extends ChangeNotifier {
  double _currentLatinTextSize = 16;
  static const String _latinTextSizeKey = 'latin_text_size';

  LatinTextSizeProvider() {
    _loadLatinTextSize();
  }

  double get currentLatinTextSize => _currentLatinTextSize;

  void _loadLatinTextSize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double? savedSize = prefs.getDouble(_latinTextSizeKey);
    if (savedSize != null) {
      _currentLatinTextSize = savedSize;
      notifyListeners();
    }
  }

  void updateLatinTextSize(double newSize) async {
    _currentLatinTextSize = newSize;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_latinTextSizeKey, newSize);
  }
}

class ArabicTextSizeProvider extends ChangeNotifier {
  double _currentArabicTextSize = 18;
  static const String _arabicTextSizeKey = 'arabic_text_size';

  ArabicTextSizeProvider() {
    _loadArabicTextSize();
  }

  double get currentArabicTextSize => _currentArabicTextSize;

  void _loadArabicTextSize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double? savedSize = prefs.getDouble(_arabicTextSizeKey);
    if (savedSize != null) {
      _currentArabicTextSize = savedSize;
      notifyListeners();
    }
  }

  void updateArabicTextSize(double newSize) async {
    _currentArabicTextSize = newSize;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_arabicTextSizeKey, newSize);
  }
}
