import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/saved_ayah.dart';

class SavedAyahProvider extends ChangeNotifier {
  List<SavedAyah> _savedAyahs = [];
  int _lastSavedAyahIndex = 0;


  List<SavedAyah> get savedAyahs => _savedAyahs;
  int get lastSavedAyahIndex => _lastSavedAyahIndex;


  static const String _prefsKey = 'saved_ayahs';

  SavedAyahProvider() {
    _loadSavedAyahs();
  }

  Future<void> _loadSavedAyahs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String savedAyahsJson = prefs.getString(_prefsKey) ?? '[]';
    List<dynamic> savedAyahsData = json.decode(savedAyahsJson);
    _savedAyahs = savedAyahsData.map((data) => SavedAyah.fromJson(data)).toList();
    notifyListeners();
  }

  Future<void> _saveAyahsToPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String savedAyahsJson = json.encode(_savedAyahs.map((ayah) => ayah.toJson()).toList());
    prefs.setString(_prefsKey, savedAyahsJson);
  }

  void saveAyah(int surahNumber, int index, String ayahNumber, String ayahText,
      String ayahTranslatedText, String surahName) {
    final savedAyah = SavedAyah(
      index: index,
      ayahNumber: ayahNumber,
      ayahText: ayahText,
      ayahTranslatedText: ayahTranslatedText,
      surahName: surahName,
      surahNumber: surahNumber,
    );
    _savedAyahs.insert(0, savedAyah);
    _saveAyahsToPrefs();
    _lastSavedAyahIndex = index;
    notifyListeners();
  }

  void removeAyahByIndex(int index) {
    _savedAyahs.removeAt(index);
    _saveAyahsToPrefs();
    notifyListeners();
  }


}
