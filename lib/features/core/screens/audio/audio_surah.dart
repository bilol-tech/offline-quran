import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../constant/color.dart';
import '../../../auth/screens/sign_in/sign_in.dart';
import '../../models/surah_home_page_model.dart';
import '../search/search_bar.dart';
import 'audio_details.dart';

class AudioSurah extends StatefulWidget {
  const AudioSurah({Key? key}) : super(key: key);

  @override
  _AudioSurahState createState() => _AudioSurahState();
}

class _AudioSurahState extends State<AudioSurah> {
  List<Map<String, dynamic>> surahList = [];
  var auth = FirebaseAuth.instance;
  User? user;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    loadSurahData();
    user = FirebaseAuth.instance.currentUser;
  }

  late List<SurahHomePageModel> surahs = [];

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

    return Scaffold(
      backgroundColor: light ? lightBackgroundYellow : background,
      appBar: AppBar(
        backgroundColor: light ? lightBackgroundWhite : gray,
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: false,
        title: Padding(
          padding: EdgeInsets.only(left: screenHeight * 0.010),
          child: Text(
            'Audio',
            style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.055,
                fontWeight: FontWeight.bold,
                color: light ? black : white.withOpacity(0.8)),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: screenHeight * 0.010),
            child: IconButton(
              icon: SvgPicture.asset('assets/svgs/search-icon.svg', width: screenWidth * 0.055, color: light ? Colors.black87 : text),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: CustomSearch(context),
                );
              },
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: user != null
            ? Padding(
                padding: EdgeInsets.only(left: screenWidth * 0.035, right: screenWidth * 0.035),
                child: surahs.isEmpty
                    ? Center(
                    child: Lottie.asset("assets/animation/loading.json", width: screenWidth * 0.250)
                )
                    : ListView.separated(
                        itemCount: surahs.length,
                        separatorBuilder: (context, index) => Divider(
                            color: const Color(0xFF7B80AD).withOpacity(.35)),
                        itemBuilder: (context, index) {
                          SurahHomePageModel surah = surahs[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  pageBuilder: (_, __, ___) =>
                                      AudioSurahDetails(
                                    surah.number,
                                    surah.englishName,
                                    surah.englishNameTranslation,
                                    surah.revelationType,
                                    surah.number,
                                  ),
                                  transitionsBuilder:
                                      (_, animation, __, child) {
                                    return SlideTransition(
                                      position: Tween<Offset>(
                                        begin: const Offset(
                                            1.0, 0.0), // Start from right side
                                        end: Offset.zero, // Move to the center
                                      ).animate(animation),
                                      child: child,
                                    );
                                  },
                                ),
                              );
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: screenWidth * 0.025),
                              child: Row(
                                children: [
                                  Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      SvgPicture.asset(
                                          'assets/svgs/nomor-surah.svg', width: screenWidth * 0.080,),
                                      Text(
                                        "${surah.number}",
                                        style: GoogleFonts.poppins(
                                        color: light ? black : white,
                                        fontSize: screenWidth * 0.03,
                                        fontWeight: FontWeight.w500),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    width: screenWidth * 0.040,
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
                                            fontSize: screenWidth * 0.04
                                        ),
                                      ),
                                      SizedBox(
                                        height: screenHeight * 0.004,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            surah.revelationType,
                                            style: GoogleFonts.poppins(
                                                color: text,
                                                fontWeight: FontWeight.w500,
                                                fontSize: screenWidth * 0.03
                                            ),
                                          ),
                                          SizedBox(
                                            width: screenWidth * 0.015,
                                          ),
                                          Container(
                                            width: screenWidth * 0.010,
                                            height: screenHeight * 0.005,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(2),
                                                color: text),
                                          ),
                                          SizedBox(
                                            width: screenWidth * 0.015,
                                          ),
                                          Text(
                                            "${surah.numberOfAyahs} Ayat",
                                            style: GoogleFonts.poppins(
                                                color: text,
                                                fontWeight: FontWeight.w500,
                                                fontSize: screenWidth * 0.031
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  )),
                                  Text(
                                    surah.name.split(' ').skip(1).join(' '),
                                    style: GoogleFonts.amiri(
                                        color: primary,
                                        fontSize: screenWidth * 0.042,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              )
            : Padding(
                padding: EdgeInsets.only(left: screenHeight * 0.022, right: screenHeight * 0.0022),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: SizedBox(
                        width: screenWidth * 0.500,
                          child: Text(
                        "To access the music, signing in or signing up for the application is required.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: light ? black : white, fontSize: screenWidth * 0.035),
                      )),
                    ),
                    SizedBox(height: screenHeight * 0.027,),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            pageBuilder: (_, __, ___) => const SignIn(),
                            transitionsBuilder: (_, animation, __, child) {
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
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.045),
                        child: Container(
                          height: screenHeight * 0.045,
                          decoration: BoxDecoration(
                              borderRadius:
                              const BorderRadius.all(Radius.circular(3)),
                              color: primary),
                          child: Center(
                              child: Text(
                                "Sign in or register to access",
                                style: TextStyle(color: white, fontSize: screenWidth * 0.027),
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
