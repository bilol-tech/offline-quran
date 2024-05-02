import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:offline_quran_app/features/core/screens/home/widgets/para_home_screen.dart';
import 'package:offline_quran_app/features/core/screens/home/widgets/sajda_home_screen.dart';
import 'package:offline_quran_app/features/core/screens/home/widgets/surah_home_screen.dart';

import '../../../../constant/color.dart';
import '../../models/surah_ayah_model.dart';
import '../../models/surah_home_page_model.dart';
import '../search/search_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  late List<SurahAyah> ayahs = [];
  SurahAyah? randomAyah;

  @override
  void initState() {
    super.initState();
    ayahArabicData().then((_) {
      setState(() {
        randomAyah = getRandomAyah();
      });
    });
  }

  Future<void> ayahArabicData() async {
    final random = Random();
    final int randomNumber = random.nextInt(114) + 1;
    String data = await rootBundle.loadString('assets/surah_data/surah_details/ayah_arabic/surah_$randomNumber.json');
    List<dynamic> jsonData = json.decode(data);
    setState(() {
      ayahs = jsonData.map((data) => SurahAyah.fromJson(data)).toList();
    });
  }

  SurahAyah getRandomAyah() {
    final random = Random();
    return ayahs[random.nextInt(ayahs.length)];
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
          padding: EdgeInsets.only(left: screenWidth * 0.015),
          child: Text(
            'Main',
            style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.06,
                fontWeight: FontWeight.bold,
                color: light ? black : white.withOpacity(0.8)),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: screenWidth * 0.020),
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
        child: Padding(
          padding: EdgeInsets.only(left: screenWidth * 0.030, right:  screenWidth * 0.030),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: screenWidth * 0.040,),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: light ? lightBackgroundWhite : gray,
                      border: Border.all(color: text, width: 0.11),
                      ),
                  child: Column(
                    children: [
                      SizedBox(height: screenWidth * 0.010,),
                      Text("Random Ayah", style: GoogleFonts.poppins(fontSize: screenWidth * 0.04, color: light ? black : white, fontWeight: FontWeight.w700),),
                      SizedBox(height: screenWidth * 0.025,),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.022),
                        child: randomAyah != null
                            ? Text(
                          randomAyah!.text,
                          style: GoogleFonts.amiri(
                            color: light ? black : white,
                            fontSize: screenWidth * 0.05,
                            height: 2.3,
                            letterSpacing: 0.2,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        )
                            : const SizedBox(),
                      ),
                    ],
                  )
                ),
                // Positioned(
                //     bottom: 0,
                //     right: 0,
                //     child: SvgPicture.asset('assets/svgs/quran.svg')),
                SizedBox(height: screenWidth * 0.035,),
                const SurahHomeScreen(),
                SizedBox(height: screenWidth * 0.035,),
                const ParaHomeScreen(),
                SizedBox(height: screenWidth * 0.035,),
                const SajdaHomeScreen(),
                SizedBox(height: screenWidth * 0.035,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
