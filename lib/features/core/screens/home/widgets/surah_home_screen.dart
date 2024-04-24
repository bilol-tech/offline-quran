import 'package:flutter/cupertino.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../../../../../constant/color.dart';
import '../../../models/surah_home_page_model.dart';
import '../../main_screen.dart';

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
    return surahs.isEmpty
        ? Padding(
        padding: const EdgeInsets.only(top: 157.0),
        child: Lottie.asset("assets/animation/loading.json", width: 120)
    )
        : Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: gray,
          borderRadius: const BorderRadius.all(Radius.circular(8))
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                children: [
                  Text("Surahs", style: GoogleFonts.poppins(fontSize: 17, color: white, fontWeight: FontWeight.w500),),
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
                  },child: Text("See all", style: TextStyle(color: primary, fontSize: 12),)),
                ],
              ),
            ),
            Divider(color: const Color(0xFF7B80AD).withOpacity(.35)),
            SizedBox(
              height: 160,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14.0),
                child: ListView.separated(
                  itemCount: 3,
                  physics: const NeverScrollableScrollPhysics(),
                  separatorBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Divider(
                        color: const Color(0xFF7B80AD).withOpacity(.35)),
                  ),
                  itemBuilder: (context, index) {
                    SurahHomePageModel surah = surahs[index];
                    return GestureDetector(
                      onTap: () {
                        // Navigator.of(context).push(
                        //   PageRouteBuilder(
                        //     pageBuilder: (_, __, ___) => SurahDetails(
                        //       surah['number'],
                        //       surah['englishName'],
                        //       surah['englishNameTranslation'],
                        //       surah['revelationType'],
                        //       surah['numberOfAyahs'], specificAyah: 0,),
                        //     transitionsBuilder: (_, animation, __, child) {
                        //       return SlideTransition(
                        //         position: Tween<Offset>(
                        //           begin: const Offset(1.0, 0.0), // Start from right side
                        //           end: Offset.zero, // Move to the center
                        //         ).animate(animation),
                        //         child: child,
                        //       );
                        //     },
                        //   ),
                        // );
                      },
                      child: Row(
                        children: [
                          Text(
                            surah.number.toString(),
                            style: GoogleFonts.poppins(
                                color: text,
                                fontSize: 13,
                                fontWeight: FontWeight.w500),
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
                                        fontSize: 14),
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
                                            fontSize: 10),
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
                                            fontSize: 10),
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
                                fontSize: 14,
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
