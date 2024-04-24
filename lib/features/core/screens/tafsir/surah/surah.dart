import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:offline_quran_app/features/core/models/surah_home_page_model.dart';
import 'package:lottie/lottie.dart';
import 'package:offline_quran_app/features/core/screens/tafsir/surah/surah_details.dart';
import '../../../../../constant/color.dart';

class SurahPage extends StatefulWidget {
  const SurahPage({Key? key}) : super(key: key);

  @override
  _SurahPageState createState() => _SurahPageState();
}

class _SurahPageState extends State<SurahPage> {
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
    return surahs.isEmpty
        ? Center(
        child: Lottie.asset("assets/animation/loading.json", width: 120))
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
                pageBuilder: (_, __, ___) => SurahDetails(
                  surah.number,
                  surah.englishName,
                  surah.englishNameTranslation,
                  surah.revelationType,
                  surah.numberOfAyahs,
                  specificAyah: 0,
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
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              children: [
                Stack(
                  children: [
                    SvgPicture.asset('assets/svgs/nomor-surah.svg'),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                  borderRadius: BorderRadius.circular(2),
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
    );
  }
}
