class ParaIndex {
  final int number;
  final String englishName;
  final int numberInSurah;


  ParaIndex({
    required this.number,
    required this.englishName,
    required this.numberInSurah,
  });

  factory ParaIndex.fromJson(Map<String, dynamic> json) {
    return ParaIndex(
      number: json['number'],
      englishName: json['englishName'],
      numberInSurah: json['numberInSurah'],
    );
  }
}