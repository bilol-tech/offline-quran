import 'package:flutter/material.dart';

enum ThemeModeType { light, dark, system }

class ThemeProvider extends ChangeNotifier {
  ThemeModeType _themeModeType = ThemeModeType.system;

  ThemeModeType get themeModeType => _themeModeType;

  void setThemeMode(ThemeModeType mode) {
    _themeModeType = mode;
    notifyListeners();
  }
}
