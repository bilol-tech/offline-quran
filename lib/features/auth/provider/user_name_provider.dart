import 'package:flutter/material.dart';

class NameProvider extends ChangeNotifier {
  String _name = '';

  String get name => _name;

  setName(String value) {
    _name = value;
    notifyListeners();
  }
}
