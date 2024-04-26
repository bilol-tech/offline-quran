import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../features/core/models/surah_ayah_model.dart';
import '../../features/core/models/surah_home_page_model.dart';

class SurahAyahDropdown extends StatefulWidget {
  @override
  _SurahAyahDropdownState createState() => _SurahAyahDropdownState();
}

class _SurahAyahDropdownState extends State<SurahAyahDropdown> {
  List<SurahHomePageModel> surahs = [];
  List<SurahAyah> ayahs = [];
  SurahHomePageModel? selectedSurah;
  SurahAyah? selectedAyah;

  @override
  void initState() {
    super.initState();
    loadSurahData();
  }

  Future<void> loadSurahData() async {
    String data = await rootBundle.loadString('assets/surah_data/surah_details/surah_data.json');
    List<dynamic> jsonData = json.decode(data);
    setState(() {
      surahs = jsonData.map((data) => SurahHomePageModel.fromJson(data)).toList();
    });
  }

  Future<void> ayahArabicData(int surahNumber) async {
    String data = await rootBundle.loadString('assets/surah_data/surah_details/ayah_arabic/surah_$surahNumber.json');
    List<dynamic> jsonData = json.decode(data);
    setState(() {
      ayahs = jsonData.map((data) => SurahAyah.fromJson(data)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // if (selectedSurah != null && selectedAyah != null) {
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => AnotherPage(selectedSurah!, selectedAyah!),
                //     ),
                //   );
                // } else {
                //   // Handle case where surah or ayah is not selected
                // }
                _showModalBottomSheet(context);
              },
              child: Text('Navigate to Another Page'),
            ),
          ],
        ),
      ),
    );
  }

  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: StatefulBuilder(
                      builder: (BuildContext context, void Function(void Function()) setState) {
                        return DropdownButton<SurahHomePageModel>(
                          value: selectedSurah,
                          onChanged: (newValue) {
                            setState(() {
                              selectedSurah = newValue;
                              ayahArabicData(newValue!.number);
                              selectedAyah = null; // Reset selected ayah when changing surah
                            });
                          },
                          items: surahs.map<DropdownMenuItem<SurahHomePageModel>>((SurahHomePageModel surah) {
                            return DropdownMenuItem<SurahHomePageModel>(
                              value: surah,
                              child: Text(surah.name),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: StatefulBuilder(
                      builder: (BuildContext context, void Function(void Function()) setState) {
                        return DropdownButton<SurahAyah>(
                          hint: selectedAyah == null ? Text('Select Ayah') : Text('Ayah ${selectedAyah!.number}: ${selectedAyah!.text}'),
                          value: selectedAyah,
                          onChanged: (newValue) {
                            setState(() {
                              selectedAyah = newValue;
                            });
                          },
                          items: ayahs.map<DropdownMenuItem<SurahAyah>>((SurahAyah ayah) {
                            return DropdownMenuItem<SurahAyah>(
                              value: ayah,
                              child: Text('Ayah ${ayah.number}'),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  // if (selectedSurah != null && selectedAyah != null) {
                  //   Navigator.pop(context); // Close the bottom sheet
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => AnotherPage(selectedSurah!, selectedAyah!),
                  //     ),
                  //   );
                  // } else {
                  //   // Handle case where surah or ayah is not selected
                  // }
                },
                child: Text('Navigate to Another Page'),
              ),
            ],
          ),
        );
      },
    );
  }


}