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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final themeData = Theme.of(context);
    final light = themeData.brightness == Brightness.light;
    print(themeData.brightness == Brightness.light ? 'Light Mode' : 'Dark Mode');
    return surahs.isEmpty
        ? Center(
        child: Lottie.asset("assets/animation/loading.json", width: screenWidth * 0.250))
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
            padding: EdgeInsets.symmetric(vertical: screenWidth * 0.025),
            child: Row(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SvgPicture.asset('assets/svgs/nomor-surah.svg', width: screenWidth * 0.080,),
                    Text(
                      "${surah.number}",
                      style: GoogleFonts.poppins(
                          color: light ? Colors.black87 : white,
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
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                  borderRadius: BorderRadius.circular(2),
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
    );
  }
}
