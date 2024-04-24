import 'package:offline_quran_app/features/core/models/sajda_home_screen_model.dart';
import 'package:offline_quran_app/features/core/models/sajda_surah_home_screen_model.dart';

class SajdaAyahs {
  final int number;
  final String text;
  final SajdaSurah surah;
  final int numberInSurah;
  final int juz;
  final int manzil;
  final int page;
  final int ruku;
  final int hizbQuarter;
  final Sajda sajda;

  SajdaAyahs({
    required this.number,
    required this.text,
    required this.surah,
    required this.numberInSurah,
    required this.juz,
    required this.manzil,
    required this.page,
    required this.ruku,
    required this.hizbQuarter,
    required this.sajda,
  });

  factory SajdaAyahs.fromJson(Map<String, dynamic> json) {
    return SajdaAyahs(
      number: json['number'],
      text: json['text'],
      surah: SajdaSurah.fromJson(json['surah']),
      numberInSurah: json['numberInSurah'],
      juz: json['juz'],
      manzil: json['manzil'],
      page: json['page'],
      ruku: json['ruku'],
      hizbQuarter: json['hizbQuarter'],
      sajda: Sajda.fromJson(json['sajda']),
    );
  }
}
