import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:offline_quran_app/features/core/screens/home/widgets/para_home_screen.dart';
import 'package:offline_quran_app/features/core/screens/home/widgets/sajda_home_screen.dart';
import 'package:offline_quran_app/features/core/screens/home/widgets/surah_home_screen.dart';

import '../../../../constant/color.dart';
import '../search/search_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
                _lastRead(),
                const SizedBox(height: 17,),
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

Stack _lastRead() {
  return Stack(
    children: [
      Container(
        height: 131,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [
                  0,
                  .6,
                  1
                ],
                colors: [
                  Color(0xFFDF98FA),
                  Color(0xFFB070FD),
                  Color(0xFF9055FF)
                ])),
      ),
      Positioned(
          bottom: 0,
          right: 0,
          child: SvgPicture.asset('assets/svgs/quran.svg')),
      Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SvgPicture.asset('assets/svgs/book.svg'),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  'Last Read',
                  style: GoogleFonts.poppins(
                      color: Colors.white, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Al-Fatihah',
              style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 18),
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              'Ayat No: 1',
              style: GoogleFonts.poppins(
                color: Colors.white,
              ),
            ),
          ],
        ),
      )
    ],
  );
}
