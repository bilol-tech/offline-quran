import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../constant/color.dart';
import '../../main_screen.dart';
import '../../../models/sajda_ayah_home_screen_model.dart';
import '../../tafsir/surah/surah_details.dart';

class SajdaHomeScreen extends StatefulWidget {
  const SajdaHomeScreen({super.key});

  @override
  State<SajdaHomeScreen> createState() => _SajdaHomeScreenState();
}

class _SajdaHomeScreenState extends State<SajdaHomeScreen> {

  List<SajdaAyahs> sajdaAyahs = [];

  @override
  void initState() {
    super.initState();
    loadSajdaAyahs();
  }

  Future<void> loadSajdaAyahs() async {
    String data = await rootBundle.loadString('assets/surah_data/sajda_ayah/sajda_ayah.json');
    List<dynamic> jsonData = json.decode(data);
    setState(() {
      sajdaAyahs = jsonData.map((data) => SajdaAyahs.fromJson(data)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    final themeData = Theme.of(context);
    final light = themeData.brightness == Brightness.light;
    print(themeData.brightness == Brightness.light ? 'Light Mode' : 'Dark Mode');

    return sajdaAyahs.isEmpty
        ? const SizedBox.shrink()
        : Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: light ? lightBackgroundWhite : gray,
          border: Border.all(color: text, width: 0.11),
          borderRadius: const BorderRadius.all(Radius.circular(8))
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.025),
              child: Row(
                children: [
                  Text("Sajda Ayahs", style: GoogleFonts.poppins(fontSize: screenWidth * 0.045, color: light ? black : white, fontWeight: FontWeight.w500),),
                  const Spacer(),
                  GestureDetector(onTap: (){
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => const MainScreen(selectedIndex: 2,),
                        transitionsBuilder: (_, animation, __, child) {
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(1.0, 0.0), // Start from right side
                              end: Offset.zero, // Move to the center
                            ).animate(animation),
                            child: child,
                          );
                        },
                      ),
                    );
                  },child: Text("See all", style: TextStyle(color: primary, fontSize: screenWidth * 0.03),)),
                ],
              ),
            ),
            Divider(color: const Color(0xFF7B80AD).withOpacity(.35)),
            SizedBox(
              height: screenWidth * 0.333,
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
                    SajdaAyahs sajdaAyah = sajdaAyahs[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            pageBuilder: (_, __, ___) => SurahDetails(
                              sajdaAyah.surah.number,
                              sajdaAyah.surah.englishName,
                              sajdaAyah.surah.englishName,
                              sajdaAyah.surah.revelationType,
                              sajdaAyah.surah.numberOfAyahs,
                              specificAyah: sajdaAyah.numberInSurah - 1,
                            ),
                            transitionsBuilder: (_, animation, __, child) {
                              return SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(1.0, 0.0), // Start from right side
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
                          Text("${sajdaAyahs.indexWhere((element) => element == sajdaAyah) + 1}",
                            style: GoogleFonts.poppins(
                                color: text,
                                fontSize: screenWidth * 0.035,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            width: screenWidth * 0.035,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Text(
                              "${sajdaAyah.surah.englishName}, ${sajdaAyah.numberInSurah}-Ayat",
                              style: GoogleFonts.poppins(
                                  color: light ? black : white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: screenWidth * 0.036),
                            ),
                          ),
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
