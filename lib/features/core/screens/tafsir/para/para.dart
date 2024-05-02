import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:offline_quran_app/features/core/models/para_index_model.dart';
import 'package:offline_quran_app/features/core/screens/tafsir/para/para_details.dart';

import '../../../../../constant/color.dart';

class ParaPage extends StatefulWidget {
  const ParaPage({super.key});

  @override
  _ParaPageState createState() => _ParaPageState();
}

class _ParaPageState extends State<ParaPage> {
  late List<ParaIndex> juzNumbers = [];

  @override
  void initState() {
    super.initState();
    loadSurahData();
  }

  Future<void> loadSurahData() async {
    String data = await rootBundle.loadString('assets/surah_data/juz_details/juz_index/juz_index.json');
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
        ? Center(child: Lottie.asset("assets/animation/loading.json", width: screenWidth * 0.250))
        : ListView.separated(
      itemCount: juzNumbers.length,
      itemBuilder: (context, index) {
        ParaIndex juzNumber = juzNumbers[index];
        return GestureDetector(
          onTap: (){
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => ParaDetailsScreen(surahName: juzNumber.englishName, numberInSurah: juzNumber.numberInSurah, juzNumber: juzNumber.number,),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (index == 0)
                const SizedBox(height: 10),
              Text(
                "${juzNumber.number}-Para",
                style: GoogleFonts.poppins(
                  color: light ? black : white,
                  fontSize: screenWidth * 0.04,
                ),
              ),
              Text(
                "${juzNumber.englishName}, start from ${juzNumber.numberInSurah} ayah",
                style: GoogleFonts.poppins(
                  color: text,
                  fontSize: screenWidth * 0.031,
                ),
              ),
              if (index == juzNumbers.length - 1)
                const SizedBox(height: 10),
            ],
          ),
        );
      }, separatorBuilder: (context, index) =>
        Divider(color: const Color(0xFF7B80AD).withOpacity(.35)),
    );
  }
}