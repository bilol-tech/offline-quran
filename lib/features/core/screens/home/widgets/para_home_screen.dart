import 'package:flutter/cupertino.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../constant/color.dart';
import '../../main_screen.dart';
import '../../../models/para_index_model.dart';

class ParaHomeScreen extends StatefulWidget {
  const ParaHomeScreen({super.key});

  @override
  State<ParaHomeScreen> createState() => _ParaHomeScreenState();
}

class _ParaHomeScreenState extends State<ParaHomeScreen> {

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
    return juzNumbers.isEmpty
        ? const SizedBox.shrink()
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
                  Text("Para", style: GoogleFonts.poppins(fontSize: 17, color: white, fontWeight: FontWeight.w500),),
                  const Spacer(),
                  GestureDetector(onTap: (){
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => const MainScreen(selectedIndex: 1,),
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
                    ParaIndex juzNumber = juzNumbers[index];
                    return GestureDetector(
                      onTap: () {
                        // Navigator.of(context).push(
                        //   PageRouteBuilder(
                        //     pageBuilder: (_, __, ___) => ParaDetailsScreen(surahName: ayah["surah"]["englishName"], numberInSurah: ayah["numberInSurah"], juzNumber: juzNumber,),
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
                            juzNumber.number.toString(),
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
                                    "${juzNumber.number.toString()}-Para",
                                    style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    "${juzNumber.englishName}, start from ${juzNumber.numberInSurah} ayah",
                                    style: GoogleFonts.poppins(
                                        color: text,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 11),
                                  )
                                ],
                              )),
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
