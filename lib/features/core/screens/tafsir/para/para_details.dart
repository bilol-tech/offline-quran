import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../../constant/color.dart';
import '../../../../../global/common/show_custom_popup_menu.dart';
import '../../../models/para_details_ayah.dart';
import '../../../models/para_details_surah.dart';
import '../../../models/para_detila_translated_ayah.dart';
import '../../../provider/color_provider.dart';
import '../../../provider/saved_ayah_provider.dart';
import '../../../provider/text_size_provider.dart';

class ParaDetailsScreen extends StatefulWidget {
  final String surahName;
  final int numberInSurah;
  final int juzNumber;

  const ParaDetailsScreen({
    Key? key,
    required this.surahName,
    required this.numberInSurah,
    required this.juzNumber,
  }) : super(key: key);

  @override
  _ParaDetailsScreenState createState() => _ParaDetailsScreenState();
}

class _ParaDetailsScreenState extends State<ParaDetailsScreen> {
  late List<ParaDetailsAyah> paraDetailsAyahs = [];
  late List<ParaDetailsSurah> paraDetailsSurahs = [];
  late List<ParaDetailsTranslatedAyah> paraDetailsTranslatedAyahs = [];
  late List<ParaDetailsTranslatedAyah> paraDetailsTranslatedSurahs = [];

  @override
  void initState() {
    super.initState();
    loadParaSurahAyah();
    loadParaSurahAyahTranslated();
  }

  Future<void> loadParaSurahAyah() async {
    String data = await rootBundle.loadString('assets/surah_data/juz_details/juz_ayah_arabic/juz_${widget.juzNumber}.json');
    List<dynamic> jsonData = json.decode(data);
    List<dynamic> ayahsData = jsonData.first['ayahs'];
    setState(() {
      paraDetailsAyahs = ayahsData.map((data) => ParaDetailsAyah.fromJson(data)).toList();
    });
  }

  Future<void> loadParaSurahAyahTranslated() async {
    String data = await rootBundle.loadString('assets/surah_data/juz_details/juz_ayah_translated/juz_${widget.juzNumber}.json');
    List<dynamic> jsonData = json.decode(data);
    List<dynamic> ayahsTranslatedData = jsonData.first['ayahs'];
    setState(() {
      paraDetailsTranslatedAyahs = ayahsTranslatedData.map((data) => ParaDetailsTranslatedAyah.fromJson(data)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    Color? selectedColor = Provider.of<ColorModel>(context).selectedColor;
    final latinTextSizeProvider = Provider.of<LatinTextSizeProvider>(context);
    final arabicTextSizeProvider = Provider.of<ArabicTextSizeProvider>(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: selectedColor,
      appBar: AppBar(
        backgroundColor: selectedColor,
        automaticallyImplyLeading: false,
        elevation: 10,
        title: Row(children: [
          IconButton(
              onPressed: (() => Navigator.of(context).pop()),
              icon: SvgPicture.asset(
                'assets/svgs/back-icon.svg',
                color: selectedColor == mode_3
                    ? white.withOpacity(0.8)
                    : Colors.black54,
                width: screenWidth* 0.055,
              )),
          SizedBox(
            width: screenWidth * 0.045,
          ),
          Text(
            "${widget.surahName}, ${widget.numberInSurah} ayah",
            style: GoogleFonts.poppins(
              fontSize: screenWidth * 0.05,
              fontWeight: FontWeight.bold,
              color: selectedColor == mode_3
                  ? white.withOpacity(0.8)
                  : Colors.black54,
            ),
          ),
        ]),
        actions: const [
          CustomPopupMenu(
            pageName: 'SurahDetails',
          ),
        ],
      ),
      body: paraDetailsAyahs.isEmpty || paraDetailsTranslatedAyahs.isEmpty
          ? Center(
          child: Lottie.asset("assets/animation/loading.json", width: screenWidth * 0.250))
          : Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
        child: ListView.separated(
          itemCount: paraDetailsAyahs.length,
          separatorBuilder: (context, index) =>
              Divider(color: const Color(0xFF7B80AD).withOpacity(.35)),
          itemBuilder: (context, index) {
            ParaDetailsAyah paraAyah = paraDetailsAyahs[index];
            ParaDetailsTranslatedAyah paraTranslatedAyah = paraDetailsTranslatedAyahs[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (index ==
                    0) // Add padding to the top of the first index
                  SizedBox(height: screenWidth * 0.030),
                SizedBox(
                  height: screenWidth * 0.025,
                ),
                Text(
                  paraAyah.surah.name.split(' ').skip(1).join(' '),
                  style: GoogleFonts.amiri(
                      color: primary,
                      fontSize: screenWidth * 0.030,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: screenWidth * 0.025,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    paraAyah.text,
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    style: GoogleFonts.amiri(
                      color:
                      selectedColor == mode_3 ? white : Colors.black,
                      fontSize:
                      arabicTextSizeProvider.currentArabicTextSize,
                      height: 2.8,
                      letterSpacing: 0.3,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  "${paraTranslatedAyah.numberInSurah.toString()}. ${paraTranslatedAyah.text}",
                  style: GoogleFonts.poppins(
                      color: selectedColor == mode_3
                          ? white
                          : Colors.black54,
                      fontSize:
                      latinTextSizeProvider.currentLatinTextSize),
                ),
                // const SizedBox(
                //   height: 5,
                // ),
                // Row(
                //   children: [
                //     const Spacer(),
                //     InkWell(
                //       onTap: (){
                //         ParaDetailsAyah paraAyah = paraDetailsAyahs[index];
                //         ParaDetailsTranslatedAyah ayahTranslated = paraDetailsTranslatedAyahs[index];
                //
                //         final ayahNumberInSurah = paraAyah.numberInSurah;
                //         final ayahText = paraAyah.text;
                //         final ayahTranslatedText = ayahTranslated.text;
                //         final surahName = widget.surahName;
                //         final surahNumber = widget.numberInSurah;
                //         Provider.of<SavedAyahProvider>(context,
                //             listen: false)
                //             .saveAyah(
                //             surahNumber,
                //             index,
                //             ayahNumberInSurah
                //                 .toString(),
                //             ayahText,
                //             ayahTranslatedText,
                //             surahName);
                //       },
                //       child: SvgPicture.asset(
                //         "assets/svgs/bookmark-icon.svg",
                //         width: latinTextSizeProvider.currentLatinTextSize / 0.8,
                //         height: latinTextSizeProvider.currentLatinTextSize / 0.8,
                //       ),
                //     ),
                //   ],
                // ),
                SizedBox(
                  height: screenWidth * 0.025,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
