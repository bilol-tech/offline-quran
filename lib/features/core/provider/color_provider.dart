import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constant/color.dart';

class ColorModel extends ChangeNotifier {
  Color? selectedColor;
  static const String _selectedColorKey = 'selected_color';

  ColorModel() {
    _loadSelectedColor();
  }

  void _loadSelectedColor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? colorValue = prefs.getInt(_selectedColorKey);
    if (colorValue != null && Color(colorValue) != null) {
      selectedColor = Color(colorValue);
    } else {
      selectedColor = mode_3; // Set a default color
    }
    notifyListeners();
  }

  void setSelectedColor(Color color) async {
    selectedColor = color;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_selectedColorKey, color.value);
  }
}
