
import 'package:offline_quran_app/features/core/screens/search/models/surah.dart';
import 'edition.dart';

class SearchResult {
  final int number;
  final String text;
  final Edition edition;
  final Surah surah;
  final int numberInSurah;

  SearchResult({
    required this.number,
    required this.text,
    required this.edition,
    required this.surah,
    required this.numberInSurah,
  });

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(
      number: json['number'],
      text: json['text'],
      edition: Edition.fromJson(json['edition']),
      surah: Surah.fromJson(json['surah']),
      numberInSurah: json['numberInSurah'],
    );
  }
}