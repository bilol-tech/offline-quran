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
            'Main',
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
        child: Padding(
          padding: const EdgeInsets.only(left: 22.0, right: 22.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 17,),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: gray
                      ),
                  child: Column(
                    children: [
                      const SizedBox(height: 5,),
                      Text("Random Ayah", style: GoogleFonts.poppins(fontSize: 16, color: white, fontWeight: FontWeight.w700),),
                      const SizedBox(height: 15,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: randomAyah != null
                            ? Text(
                          randomAyah!.text,
                          style: GoogleFonts.amiri(
                            color: white,
                            fontSize: 16,
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
                const SizedBox(height: 15,),
                const SurahHomeScreen(),
                const SizedBox(height: 15,),
                const ParaHomeScreen(),
                const SizedBox(height: 15,),
                const SajdaHomeScreen(),
                const SizedBox(height: 17,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
