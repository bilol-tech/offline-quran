import 'package:offline_quran_app/features/core/models/para_details_surah.dart';

class ParaDetailsTranslatedAyah {
  final int number;
  final String text;
  final ParaDetailsSurah surah;
  final int numberInSurah;
  final int juz;
  final int manzil;
  final int page;
  final int ruku;
  final int hizbQuarter;
  final bool sajda;

  ParaDetailsTranslatedAyah({
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

  factory ParaDetailsTranslatedAyah.fromJson(Map<String, dynamic> json) {
    return ParaDetailsTranslatedAyah(
      number: json['number'],
      text: json['text'],
      surah: ParaDetailsSurah.fromJson(json['surah']),
      numberInSurah: json['numberInSurah'],
      juz: json['juz'],
      manzil: json['manzil'],
      page: json['page'],
      ruku: json['ruku'],
      hizbQuarter: json['hizbQuarter'],
      sajda: json['sajda'],
    );
  }
}
