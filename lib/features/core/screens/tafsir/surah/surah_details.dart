import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../../../../constant/color.dart';
import '../../../../../global/common/show_custom_popup_menu.dart';
import '../../../models/surah_ayah_model.dart';
import '../../../models/surah_ayah_translated_model.dart';
import '../../../provider/color_provider.dart';
import '../../../provider/last_read_index_provider.dart';
import '../../../provider/saved_ayah_provider.dart';
import '../../../provider/text_size_provider.dart';

class SurahDetails extends StatefulWidget {
  final int surahNumber;
  final String surahName;
  final String surahNameTranslated;
  final String revelationType;
  final int numberOfAyahs;
  final int specificAyah;

  const SurahDetails(
      this.surahNumber,
      this.surahName,
      this.surahNameTranslated,
      this.revelationType,
      this.numberOfAyahs, {
        super.key,
        this.specificAyah = 0,
      });

  @override
  _SurahDetailsState createState() => _SurahDetailsState();
}

class _SurahDetailsState extends State<SurahDetails> {
  Map<String, dynamic>? surahDetails;
  Map<String, dynamic>? surahDetailsTranslated;
  int? surahNumber;
  int? tappedAyahIndex;

  String? selectedSurah;
  String? selectedAyah;

  int selectedStartNumber = 0;
  int selectedEndNumber = 0;

  bool isDarkModeEnabled = false;
  late final ItemScrollController itemScrollController;
  bool shouldScrollToSpecificAyah = true;

  late List<SurahAyah> ayahs = [];
  late List<AyahTranslated> ayahsTranslated = [];

  @override
  void initState() {
    super.initState();
    ayahArabicData();
    ayahTranslatedData();
  }

  Future<void> ayahArabicData() async {
    String data = await rootBundle.loadString('assets/surah_data/surah_details/ayah_arabic/surah_${widget.surahNumber}.json');
    List<dynamic> jsonData = json.decode(data);
    setState(() {
      ayahs = jsonData.map((data) => SurahAyah.fromJson(data)).toList();
    });
  }

  Future<void> ayahTranslatedData() async {
    String data = await rootBundle.loadString('assets/surah_data/surah_details/ayah_translated_text/translated_${widget.surahNumber}.json');
    List<dynamic> jsonData = json.decode(data);
    setState(() {
      ayahsTranslated = jsonData.map((data) => AyahTranslated.fromJson(data)).toList();
    });
  }


  @override
  Widget build(BuildContext context) {
    final ItemScrollController itemScrollController = ItemScrollController();

    final latinTextSizeProvider = Provider.of<LatinTextSizeProvider>(context);
    final arabicTextSizeProvider = Provider.of<ArabicTextSizeProvider>(context);
    Color? selectedColor = Provider.of<ColorModel>(context).selectedColor;
    final lastReadProvider = Provider.of<LastReadIndexProvider>(context);
    final SavedAyahProvider savedAyahProvider =
    Provider.of<SavedAyahProvider>(context);

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      itemScrollController.jumpTo(index: widget.specificAyah);
    });
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
              )),
          const SizedBox(
            width: 24,
          ),
          Text(
            widget.surahName,
            style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: selectedColor == mode_3
                    ? white.withOpacity(0.8)
                    : Colors.black),
          ),
        ]),
        actions: const [
          CustomPopupMenu(
            pageName: 'SurahDetails',
          )
        ],
      ),
      body: ayahs.isEmpty || ayahsTranslated.isEmpty
          ? Center(
          child: Lottie.asset("assets/animation/loading.json", width: 120))
          : Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ScrollablePositionedList.separated(
              itemScrollController: itemScrollController,
              itemBuilder: (context, index) {
                SurahAyah ayah = ayahs[index];
                AyahTranslated ayahTranslated = ayahsTranslated[index];
                return Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        ayah.text,
                        style: GoogleFonts.amiri(
                          color: selectedColor == mode_3
                              ? white
                              : Colors.black,
                          fontSize: arabicTextSizeProvider
                              .currentArabicTextSize,
                          height: 3,
                          letterSpacing: 0.2,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.right,
                      ),
                      Text(
                        ayahTranslated.text,
                        style: GoogleFonts.poppins(
                            color: selectedColor == mode_3
                                ? white
                                : Colors.black54,
                            fontSize: latinTextSizeProvider
                                .currentLatinTextSize),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        children: [
                          const Spacer(),
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: selectedColor == mode_3
                                      ? text
                                      : Colors.black54,
                                ),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(3))),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 1),
                              child: Text(
                                "${ayah.numberInSurah}:${widget.numberOfAyahs}",
                                style: TextStyle(
                                  fontSize: latinTextSizeProvider
                                      .currentLatinTextSize /
                                      1.5,
                                  color: selectedColor == mode_3
                                      ? white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          InkWell(
                            onTap: () {
                              SurahAyah ayah = ayahs[index];
                              AyahTranslated ayahTranslated = ayahsTranslated[index];

                              final ayahNumberInSurah = ayah.numberInSurah;
                              final ayahText = ayah.text;
                              final ayahTranslatedText = ayahTranslated.text;
                              final surahName = widget.surahName;
                              final surahNumber = widget.surahNumber;
                              Provider.of<SavedAyahProvider>(context,
                                  listen: false)
                                  .saveAyah(
                                  surahNumber,
                                  index,
                                  ayahNumberInSurah
                                      .toString(),
                                  ayahText,
                                  ayahTranslatedText,
                                  surahName);
                              // Navigator.pushReplacement(
                              //   context,
                              //   PageRouteBuilder(
                              //     opaque: true,
                              //     pageBuilder: (BuildContext context, _, __) => SurahDetails(
                              //       widget.surahNumber,
                              //       widget.surahName,
                              //       widget.surahName,
                              //       widget.surahName,
                              //       widget.surahNumber,
                              //       specificAyah: ayahNumberInSurah - 1,
                              //     ),
                              //   ),
                              // );
                            },
                            child: SvgPicture.asset(
                              "assets/svgs/bookmark-icon.svg",
                              width: latinTextSizeProvider
                                  .currentLatinTextSize /
                                  0.8,
                              height: latinTextSizeProvider
                                  .currentLatinTextSize /
                                  0.8,
                              color: selectedColor == mode_3
                                  ? text
                                  : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
              itemCount: ayahs.length,
              separatorBuilder: (context, index) => Divider(
                  color: const Color(0xFF7B80AD).withOpacity(.35)),
            ),
          ),
        ],
      ),
      floatingActionButton: Transform.scale(
        scale: 0.8,
        child: FloatingActionButton(
          onPressed: () {
            itemScrollController.scrollTo(
              index: savedAyahProvider.lastSavedAyahIndex,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              alignment: 0,
            );
          },
          backgroundColor: primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
          child: Center(
              child: Icon(
                Icons.swipe_up,
                color: white,
              )),
        ),
      ),
    );
  }
}
