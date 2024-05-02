import 'package:flutter/cupertino.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../../../../../constant/color.dart';
import '../../../models/surah_home_page_model.dart';
import '../../main_screen.dart';
import '../../tafsir/surah/surah_details.dart';

class SurahHomeScreen extends StatefulWidget {
  const SurahHomeScreen({super.key});

  @override
  State<SurahHomeScreen> createState() => _SurahHomeScreenState();
}

class _SurahHomeScreenState extends State<SurahHomeScreen> {
  late List<SurahHomePageModel> surahs = [];

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

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    final themeData = Theme.of(context);
    final light = themeData.brightness == Brightness.light;
    print(themeData.brightness == Brightness.light ? 'Light Mode' : 'Dark Mode');
    return surahs.isEmpty
        ? Padding(
        padding: EdgeInsets.only(top: screenWidth * 0.55),
        child: Lottie.asset("assets/animation/loading.json", width: screenWidth * 0.250)
    )
        : Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: light ? lightBackgroundWhite : gray,
          border: Border.all(color: text, width: 0.11),
          borderRadius: const BorderRadius.all(Radius.circular(8))
      ),
      child: Padding(
        padding: EdgeInsets.only(top: screenWidth * 0.02),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.025),
              child: Row(
                children: [
                  Text("Surahs", style: GoogleFonts.poppins(fontSize: screenWidth * 0.045, color: light ? black : white, fontWeight: FontWeight.w500),),
                  const Spacer(),
                  GestureDetector(onTap: (){
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => const MainScreen(selectedIndex: 0,),
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
                    SurahHomePageModel surah = surahs[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            pageBuilder: (_, __, ___) => SurahDetails(
                              surah.number,
                              surah.englishName,
                              surah.englishNameTranslation,
                              surah.revelationType,
                              surah.numberOfAyahs, specificAyah: 0,
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
                          Text(
                            surah.number.toString(),
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
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    surah.englishName,
                                    style: GoogleFonts.poppins(
                                        color: light ? black : white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: screenWidth * 0.036),
                                  ),
                                  SizedBox(
                                    height: screenWidth * 0.010,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        surah.revelationType,
                                        style: GoogleFonts.poppins(
                                            color: text,
                                            fontWeight: FontWeight.w500,
                                            fontSize: screenWidth * 0.026),
                                      ),
                                      SizedBox(
                                        width: screenWidth * 0.012,
                                      ),
                                      Container(
                                        width: screenWidth * 0.010,
                                        height: screenWidth * 0.010,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(2),
                                            color: text),
                                      ),
                                      SizedBox(
                                        width: screenWidth * 0.012,
                                      ),
                                      Text(
                                        "${surah.numberOfAyahs} Ayat",
                                        style: GoogleFonts.poppins(
                                            color: text,
                                            fontWeight: FontWeight.w500,
                                            fontSize: screenWidth * 0.027),
                                      ),
                                    ],
                                  )
                                ],
                              )),
                          Text(
                            surah.name
                                .split(' ')
                                .skip(1)
                                .join(' '),
                            style: GoogleFonts.amiri(
                                color: primary,
                                fontSize: screenWidth * 0.034,
                                fontWeight: FontWeight.bold),
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
