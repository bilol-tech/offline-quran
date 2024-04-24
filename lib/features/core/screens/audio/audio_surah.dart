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
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: gray,
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Text(
            'Audio',
            style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: white.withOpacity(0.8)),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: SvgPicture.asset('assets/svgs/search-icon.svg'),
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
                padding: const EdgeInsets.only(left: 22, right: 22),
                child: surahs.isEmpty
                    ? Center(
                        child: Lottie.asset("assets/animation/loading.json", width: 120)
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
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Row(
                                children: [
                                  Stack(
                                    children: [
                                      SvgPicture.asset(
                                          'assets/svgs/nomor-surah.svg'),
                                      SizedBox(
                                        height: 36,
                                        width: 36,
                                        child: Center(
                                            child: Text(
                                          "${surah.number}",
                                          style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500),
                                        )),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  Expanded(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        surah.englishName,
                                        style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16),
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            surah.revelationType,
                                            style: GoogleFonts.poppins(
                                                color: text,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Container(
                                            width: 4,
                                            height: 4,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(2),
                                                color: text),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            "${surah.numberOfAyahs} Ayat",
                                            style: GoogleFonts.poppins(
                                                color: text,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12),
                                          ),
                                        ],
                                      )
                                    ],
                                  )),
                                  Text(
                                    surah.name.split(' ').skip(1).join(' '),
                                    style: GoogleFonts.amiri(
                                        color: primary,
                                        fontSize: 20,
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
                padding: const EdgeInsets.only(left: 22, right: 22),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: SizedBox(
                        width: 200,
                          child: Text(
                        "To access the music, signing in or signing up for the application is required.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: white),
                      )),
                    ),
                    const SizedBox(height: 25,),
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
                        padding: const EdgeInsets.symmetric(horizontal: 45.0),
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                              borderRadius:
                              const BorderRadius.all(Radius.circular(3)),
                              color: primary),
                          child: Center(
                              child: Text(
                                "Sign in or register to access",
                                style: TextStyle(color: white, fontSize: 12),
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
