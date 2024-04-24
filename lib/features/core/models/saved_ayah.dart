class SavedAyah {
  final int index;
  final String ayahNumber;
  final String ayahText;
  final String ayahTranslatedText;
  final String surahName;
  final int surahNumber;

  SavedAyah({
    required this.index,
    required this.ayahNumber,
    required this.ayahText,
    required this.ayahTranslatedText,
    required this.surahName,
    required this.surahNumber,
  });

  factory SavedAyah.fromJson(Map<String, dynamic> json) {
    return SavedAyah(
      index: json['index'],
      ayahNumber: json['ayahNumber'],
      ayahText: json['ayahText'],
      ayahTranslatedText: json['ayahTranslatedText'],
      surahName: json['surahName'],
      surahNumber: json['surahNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'ayahNumber': ayahNumber,
      'ayahText': ayahText,
      'ayahTranslatedText': ayahTranslatedText,
      'surahName': surahName,
      'surahNumber': surahNumber,
    };
  }
}
