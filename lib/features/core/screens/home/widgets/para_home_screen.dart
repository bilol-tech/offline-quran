import 'package:flutter/cupertino.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../constant/color.dart';
import '../../main_screen.dart';
import '../../../models/para_index_model.dart';
import '../../tafsir/para/para_details.dart';

class ParaHomeScreen extends StatefulWidget {
  const ParaHomeScreen({super.key});

  @override
  State<ParaHomeScreen> createState() => _ParaHomeScreenState();
}

class _ParaHomeScreenState extends State<ParaHomeScreen> {
  late List<ParaIndex> juzNumbers = [];

  @override
  void initState() {
    super.initState();
    loadSurahData();
  }

  Future<void> loadSurahData() async {
    String data = await rootBundle
        .loadString('assets/surah_data/juz_details/juz_index/juz_index.json');
    List<dynamic> jsonData = json.decode(data);
    setState(() {
      juzNumbers = jsonData.map((data) => ParaIndex.fromJson(data)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    final themeData = Theme.of(context);
    final light = themeData.brightness == Brightness.light;
    print(themeData.brightness == Brightness.light ? 'Light Mode' : 'Dark Mode');

    return juzNumbers.isEmpty
        ? const SizedBox.shrink()
        : Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: light ? lightBackgroundWhite : gray,
                border: Border.all(color: text, width: 0.11),
                borderRadius: const BorderRadius.all(Radius.circular(8))),
            child: Padding(
              padding: EdgeInsets.only(top: screenWidth * 0.02),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.025),
                    child: Row(
                      children: [
                        Text(
                          "Para",
                          style: GoogleFonts.poppins(
                              fontSize: screenWidth * 0.045,
                              color: light ? black : white,
                              fontWeight: FontWeight.w500),
                        ),
                        const Spacer(),
                        GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  pageBuilder: (_, __, ___) => const MainScreen(
                                    selectedIndex: 1,
                                  ),
                                  transitionsBuilder:
                                      (_, animation, __, child) {
                                    return SlideTransition(
                                      position: Tween<Offset>(
                                        begin: const Offset(1.0, 0.0),
                                        // Start from right side
                                        end: Offset.zero, // Move to the center
                                      ).animate(animation),
                                      child: child,
                                    );
                                  },
                                ),
                              );
                            },
                            child: Text(
                              "See all",
                              style: TextStyle(color: primary, fontSize: screenWidth * 0.03),
                            )),
                      ],
                    ),
                  ),
                  Divider(color: const Color(0xFF7B80AD).withOpacity(.35)),
                  SizedBox(
                    height: screenWidth * 0.415,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.035),
                      child: ListView.separated(
                        itemCount: 3,
                        physics: const NeverScrollableScrollPhysics(),
                        separatorBuilder: (context, index) => Padding(
                          padding: EdgeInsets.only(left: screenWidth * 0.045),
                          child: Divider(
                              color: const Color(0xFF7B80AD).withOpacity(.35)),
                        ),
                        itemBuilder: (context, index) {
                          ParaIndex juzNumber = juzNumbers[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  pageBuilder: (_, __, ___) =>
                                      ParaDetailsScreen(
                                    surahName: juzNumber.englishName,
                                    numberInSurah: juzNumber.numberInSurah,
                                    juzNumber: juzNumber.number,
                                  ),
                                  transitionsBuilder:
                                      (_, animation, __, child) {
                                    return SlideTransition(
                                      position: Tween<Offset>(
                                        begin: const Offset(1.0, 0.0),
                                        // Start from right side
                                        end: Offset.zero, // Move to the center
                                      ).animate(animation),
                                      child: child,
                                    );
                                  },
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                Text(
                                  juzNumber.number.toString(),
                                  style: GoogleFonts.poppins(
                                      color: text,
                                      fontSize: screenWidth * 0.035,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  width: screenWidth * 0.035,
                                ),
                                Expanded(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${juzNumber.number.toString()}-Para",
                                      style: GoogleFonts.poppins(
                                          color: light ? black :white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: screenWidth * 0.036),
                                    ),
                                    SizedBox(
                                      height: screenWidth * 0.010,
                                    ),
                                    Text(
                                      "${juzNumber.englishName}, start from ${juzNumber.numberInSurah} ayah",
                                      style: GoogleFonts.poppins(
                                          color: text,
                                          fontWeight: FontWeight.w500,
                                          fontSize: screenWidth * 0.027),
                                    )
                                  ],
                                )),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
