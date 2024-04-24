import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:offline_quran_app/features/core/models/sajda_ayah_home_screen_model.dart';
import 'package:offline_quran_app/features/core/screens/tafsir/surah/surah_details.dart';

import '../../../../../constant/color.dart';

class SajdaPage extends StatefulWidget {
  const SajdaPage({super.key});

  @override
  _SajdaPageState createState() => _SajdaPageState();
}

class _SajdaPageState extends State<SajdaPage> {

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
    return sajdaAyahs.isEmpty
        ? Center(child: Lottie.asset("assets/animation/loading.json", width: 120))
        : ListView.builder(
      itemCount: sajdaAyahs.length,
      itemBuilder: (context, index) {
        SajdaAyahs sajdaAyah = sajdaAyahs[index];
        return Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: GestureDetector(
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
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 40,
                  child: Text("${sajdaAyahs.indexWhere((element) => element == sajdaAyah) + 1}", style: GoogleFonts.poppins(color: white, fontSize: 18)),
                ),
                Text('${sajdaAyah.surah.englishName}, ${sajdaAyah.numberInSurah.toString()}-Ayat', textAlign: TextAlign.center, style: GoogleFonts.poppins(color: white, fontWeight: FontWeight.w500, fontSize: 16)),
                const Spacer(),
                Icon(Icons.arrow_forward_ios_rounded, color: white, size: 15)
              ],
            ),
          ),
        );
      },
    );
  }
}
