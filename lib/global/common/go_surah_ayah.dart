import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../constant/color.dart';
import '../../features/core/models/surah_ayah_model.dart';
import '../../features/core/models/surah_home_page_model.dart';
import '../../features/core/provider/color_provider.dart';
import '../../features/core/provider/text_size_provider.dart';
import '../../features/core/screens/audio/audio_details.dart';
import '../../features/core/screens/tafsir/surah/surah_details.dart';

class GoAyahSurah extends StatefulWidget {
  final String pageName;
  const GoAyahSurah({super.key, required this.pageName});

  @override
  State<GoAyahSurah> createState() => _GoAyahSurahState();
}

class _GoAyahSurahState extends State<GoAyahSurah> {

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
    String data = await rootBundle
        .loadString('assets/surah_data/surah_details/surah_data.json');
    List<dynamic> jsonData = json.decode(data);
    setState(() {
      surahs =
          jsonData.map((data) => SurahHomePageModel.fromJson(data)).toList();
    });
  }

  Future<void> ayahArabicData(int surahNumber) async {
    String data = await rootBundle.loadString(
        'assets/surah_data/surah_details/ayah_arabic/surah_$surahNumber.json');
    List<dynamic> jsonData = json.decode(data);
    setState(() {
      ayahs = jsonData.map((data) => SurahAyah.fromJson(data)).toList();
    });
  }

  GlobalKey _popupMenuKey = GlobalKey();
  Color? selectedColor;

  @override
  Widget build(BuildContext context) {

    Color? selectedColor = Provider.of<ColorModel>(context).selectedColor;
    final latinTextSizeProvider = Provider.of<LatinTextSizeProvider>(context);
    final arabicTextSizeProvider = Provider.of<ArabicTextSizeProvider>(context);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    final themeData = Theme.of(context);
    final light = themeData.brightness == Brightness.light;
    print(themeData.brightness == Brightness.light ? 'Light Mode' : 'Dark Mode');

    return Scaffold(
      backgroundColor: light ? lightBackgroundYellow : background,
      appBar: AppBar(
        backgroundColor: light ? white : gray,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Row(children: [
          IconButton(
              onPressed: (() => Navigator.of(context).pop()),
              icon: SvgPicture.asset('assets/svgs/back-icon.svg', width: screenWidth * 0.055, color: light ? Colors.black87 : text)),
          SizedBox(
            width: screenHeight * 0.024,
          ),
          Text(
            'Go Ayah & Surah',
            style: GoogleFonts.poppins(
                fontSize: screenHeight * 0.022,
                fontWeight: FontWeight.bold,
                color: light ? black : white.withOpacity(0.8)),
          ),
        ]),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Container(
              height: screenHeight * 0.15,
              decoration: BoxDecoration(
                color: light ? white : gray,
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                border: Border.all(color: text, width: 0.11),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: screenHeight * 0.012, top: screenHeight * 0.012),
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Surah",
                              style: TextStyle(color: light ? black : white),
                            ),
                            SizedBox(
                              height: screenHeight * 0.005,
                            ),
                            Container(
                              // width: MediaQuery.of(context)
                              //         .size
                              //         .width *
                              //     0.38,
                              height: screenHeight * 0.036,
                              decoration: BoxDecoration(
                                borderRadius:
                                const BorderRadius.all(
                                    Radius.circular(6)),
                                color: light ? const Color(0xffEFEFEF) : modalSheetColor,
                              ),
                              child: StatefulBuilder(
                                builder: (BuildContext context,
                                    void Function(void Function())
                                    setState) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.010),
                                    child: DropdownButton<
                                        SurahHomePageModel>(
                                      hint: selectedSurah == null
                                          ? Text(
                                        'Select Surah',
                                        style: TextStyle(
                                            fontSize: screenHeight * 0.012,
                                            color: light ? black : white),
                                      )
                                          : Text(
                                          'Ayah ${selectedSurah!.number}.${selectedSurah!.englishName}',
                                          style: TextStyle(
                                              fontSize: screenHeight * 0.012,
                                              color: light ? black : white)),
                                      value: selectedSurah,
                                      onChanged: (newValue) {
                                        setState(() {
                                          selectedSurah = newValue;
                                          ayahArabicData(newValue!.number);
                                          selectedAyah = null;
                                        });
                                      },
                                      underline: Container(),
                                      alignment: Alignment.centerLeft,
                                      borderRadius:
                                      BorderRadius.circular(8),
                                      dropdownColor: light ? white : background,
                                      icon: Icon(
                                          Icons.arrow_drop_down,
                                          color: light ? black : white),
                                      items: surahs.map<
                                          DropdownMenuItem<
                                              SurahHomePageModel>>(
                                              (SurahHomePageModel surah) {
                                            return DropdownMenuItem<
                                                SurahHomePageModel>(
                                              value: surah,
                                              child: Text(
                                                  "${surah.number}. ${surah.englishName}",
                                                  style: TextStyle(
                                                      color: light ? black : white,
                                                      fontSize: screenHeight * 0.012)),
                                            );
                                          }).toList(),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Ayah",
                              style: TextStyle(color: light ? black :  white),
                            ),
                            SizedBox(
                              height: screenHeight * 0.005,
                            ),
                            Container(
                              height: screenHeight * 0.036,
                              decoration: BoxDecoration(
                                borderRadius:
                                const BorderRadius.all(
                                    Radius.circular(6)),
                                color: light ? const Color(0xffEFEFEF) : modalSheetColor,
                              ),
                              child: StatefulBuilder(
                                builder: (BuildContext context,
                                    void Function(void Function())
                                    setState) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.010),
                                    child: DropdownButton<SurahAyah>(
                                      hint: selectedAyah == null
                                          ? Text(
                                        'Select Ayah',
                                        style: TextStyle(
                                            fontSize: screenHeight * 0.012,
                                            color: light ? black : white),
                                      )
                                          : Text(
                                          'Ayah ${selectedAyah!.numberInSurah}',
                                          style: TextStyle(
                                              fontSize: screenHeight * 0.012,
                                              color: light ? black : white)),
                                      value: selectedAyah,
                                      onChanged: (newValue) {
                                        setState(() {
                                          selectedAyah = newValue;
                                        });
                                      },
                                      underline: Container(),
                                      alignment: Alignment.centerLeft,
                                      borderRadius:
                                      BorderRadius.circular(8),
                                      dropdownColor: light ? white : background,
                                      icon: Padding(
                                        padding: EdgeInsets.only(left: screenHeight * 0.010),
                                        child: Icon(
                                            Icons.arrow_drop_down,
                                            color: light ? black : white),
                                      ),
                                      items: ayahs.map<
                                          DropdownMenuItem<
                                              SurahAyah>>(
                                              (SurahAyah ayah) {
                                            return DropdownMenuItem<
                                                SurahAyah>(
                                              value: ayah,
                                              child: Text(
                                                'Ayah ${ayah.numberInSurah}'
                                                    .toString(),
                                                style: TextStyle(
                                                    color: light ? black : white,
                                                    fontSize: screenHeight * 0.012),
                                              ),
                                            );
                                          }).toList(),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.015,
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: screenHeight * 0.021),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              selectedSurah = null;
                              // selectedAyah = null;
                            });
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: screenHeight * 0.090,
                            height: screenHeight * 0.028,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(6)),
                            ),
                            child: Center(
                                child: Text(
                                  "cancel".toUpperCase(),
                                  style: TextStyle(
                                      color: light ? black : white, fontSize: screenHeight * 0.012),
                                )),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            if (selectedSurah != null &&
                                selectedAyah != null) {
                              final surahNumber = selectedSurah?.number;
                              final surahName = selectedSurah?.name;
                              final englishName = selectedSurah?.englishName;
                              final revelationType = selectedSurah?.revelationType;
                              final numberOfAyahs = selectedSurah?.numberOfAyahs;
                              print('Selected Surah Number: $surahNumber');
                              print('Selected Surah Name: $surahName');
                              print('Selected Surah EnglishNumber: $englishName');
                              print('Selected Surah revelationType: $revelationType');
                              print('Selected Surah numberOfAyahs: $numberOfAyahs');

                              final ayahNumberInSurah = selectedSurah?.number;
                              print(ayahNumberInSurah);
                              // final ayahName = selectedSurah?.name;
                              // final englishName = selectedSurah?.englishName;
                              // final revelationType = selectedSurah?.revelationType;
                              // final numberOfAyahs = selectedSurah?.numberOfAyahs;

                              if(widget.pageName == "SurahDetails"){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => SurahDetails(
                                      selectedSurah!.number,
                                      selectedSurah!.englishName,
                                      selectedSurah!.englishName,
                                      selectedSurah!.revelationType,
                                      selectedSurah!.numberOfAyahs,
                                      specificAyah: selectedAyah!.numberInSurah - 1,
                                    ),
                                  ),
                                ).then((_) {
                                  // Close the popup menu after navigating back
                                  if (mounted) {
                                    Navigator.pop(context);
                                  }
                                });
                              } else if(widget.pageName == "AudioDetails"){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => AudioSurahDetails(
                                      selectedSurah!.number,
                                      selectedSurah!.englishName,
                                      selectedSurah!.englishName,
                                      selectedSurah!.revelationType,
                                      selectedSurah!.numberOfAyahs,
                                      specificAyah: selectedAyah!.numberInSurah - 1,
                                    ),
                                  ),
                                ).then((_) {
                                  if (mounted) {
                                    Navigator.pop(context);
                                  }
                                });
                              }
                            }
                          },
                          child: Container(
                            width: screenHeight * 0.090,
                            height: screenHeight * 0.028,
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(6)),
                                color: Colors.green),
                            child: Center(
                                child: Text(
                                  "save".toUpperCase(),
                                  style: TextStyle(
                                      color: white, fontSize: screenHeight * 0.012),
                                )),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
