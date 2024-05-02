import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_popup/flutter_popup.dart';
import 'package:http/http.dart' as http;
import 'package:offline_quran_app/global/common/go_surah_ayah.dart';
import 'package:provider/provider.dart';

import '../../constant/color.dart';
import '../../features/core/models/surah_ayah_model.dart';
import '../../features/core/models/surah_home_page_model.dart';
import '../../features/core/provider/color_provider.dart';
import '../../features/core/provider/text_size_provider.dart';
import '../../features/core/screens/audio/audio_details.dart';
import '../../features/core/screens/profile/widgets/appearence_page.dart';
import '../../features/core/screens/profile/widgets/settings_page.dart';
import '../../features/core/screens/search/search_bar.dart';
import '../../features/core/screens/tafsir/surah/surah_details.dart';

class CustomPopupMenu extends StatefulWidget {
  final String pageName;

  const CustomPopupMenu({super.key, required this.pageName});

  @override
  State<CustomPopupMenu> createState() => _CustomPopupMenuState();
}

class _CustomPopupMenuState extends State<CustomPopupMenu> {
  List<SurahHomePageModel> surahs = [];
  List<SurahAyah> ayahs = [];
  SurahHomePageModel? selectedSurah;
  SurahAyah? selectedAyah;

  @override
  void initState() {
    super.initState();
    loadSurahData();
  }

  Future<void> loadSurahData() async {
    String data = await rootBundle
        .loadString('assets/surah_data/surah_details/surah_data.json');
    List<dynamic> jsonData = json.decode(data);
    setState(() {
      surahs =
          jsonData.map((data) => SurahHomePageModel.fromJson(data)).toList();
    });
  }

  Future<void> ayahArabicData(int surahNumber) async {
    String data = await rootBundle.loadString(
        'assets/surah_data/surah_details/ayah_arabic/surah_$surahNumber.json');
    List<dynamic> jsonData = json.decode(data);
    setState(() {
      ayahs = jsonData.map((data) => SurahAyah.fromJson(data)).toList();
    });
  }

  GlobalKey _popupMenuKey = GlobalKey();
  Color? selectedColor;

  @override
  Widget build(BuildContext context) {
    Color? selectedColor = Provider.of<ColorModel>(context).selectedColor;
    final latinTextSizeProvider = Provider.of<LatinTextSizeProvider>(context);
    final arabicTextSizeProvider = Provider.of<ArabicTextSizeProvider>(context);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    final themeData = Theme.of(context);
    final light = themeData.brightness == Brightness.light;
    print(
        themeData.brightness == Brightness.light ? 'Light Mode' : 'Dark Mode');

    return Padding(
      padding: EdgeInsets.only(right: screenHeight * 0.015),
      child: CustomPopup(
        barrierColor: Colors.transparent,
        contentRadius: screenHeight * 0.005,
        showArrow: false,
        backgroundColor: selectedColor,
        arrowColor: Colors.red,
        content: SizedBox(
          width: screenWidth * 0.320,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  if (mounted) {
                    Navigator.pop(context); // Close the current screen
                    showSearch(
                      context: context,
                      delegate: CustomSearch(context),
                    );
                  }
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      size: screenWidth * 0.036,
                      color: selectedColor == mode_3 ? white : Colors.black54,
                    ),
                    SizedBox(
                      width: screenHeight * 0.010,
                    ),
                    Text(
                      "Search",
                      style: TextStyle(
                          color: selectedColor == mode_3 ? white : Colors.black,
                          fontSize: screenWidth * 0.026),
                    )
                  ],
                ),
              ),
              widget.pageName == "AudioDetails"
                  ? const SizedBox()
                  : SizedBox(
                      height: screenHeight * 0.018,
                    ),
              widget.pageName == "AudioDetails"
                  ? const SizedBox()
                  : InkWell(
                      onTap: () {
                        if (mounted) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => GoAyahSurah(
                                pageName: widget.pageName,
                              ),
                            ),
                          ).then((_) {
                            // Close the popup menu after navigating back
                            if (mounted) {
                              Navigator.pop(context);
                            }
                          });
                        }
                      },
                      child: Row(
                        children: [
                          Icon(Icons.swipe_vertical_rounded,
                              size: screenWidth * 0.036,
                              color: selectedColor == mode_3
                                  ? white
                                  : Colors.black54),
                          SizedBox(
                            width: screenHeight * 0.010,
                          ),
                          Text(
                            "Go ayah",
                            style: TextStyle(
                                color: selectedColor == mode_3
                                    ? white
                                    : Colors.black,
                                fontSize: screenWidth * 0.026),
                          )
                        ],
                      ),
                    ),
              SizedBox(
                height: screenHeight * 0.018,
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context)
                      .push(
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => const SettingsPage(),
                      transitionsBuilder: (_, animation, __, child) {
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(1.0, 0.0),
                            // Start from right side
                            end: Offset.zero, // Move to the center
                          ).animate(animation),
                          child: child,
                        );
                      },
                    ),
                  )
                      .then((_) {
                    // Close the popup menu after navigating back
                    if (mounted) {
                      Navigator.pop(context);
                    }
                  });
                },
                child: Row(
                  children: [
                    Icon(Icons.settings,
                        size: screenHeight * 0.018,
                        color:
                            selectedColor == mode_3 ? white : Colors.black54),
                    SizedBox(
                      width: screenHeight * 0.010,
                    ),
                    Text(
                      "Settings",
                      style: TextStyle(
                          color: selectedColor == mode_3 ? white : Colors.black,
                          fontSize: screenWidth * 0.026),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: screenHeight * 0.018,
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context)
                      .push(
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => const ApearencePage(),
                      transitionsBuilder: (_, animation, __, child) {
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(1.0, 0.0),
                            // Start from right side
                            end: Offset.zero, // Move to the center
                          ).animate(animation),
                          child: child,
                        );
                      },
                    ),
                  )
                      .then((_) {
                    // Close the popup menu after navigating back
                    if (mounted) {
                      Navigator.pop(context);
                    }
                  });
                },
                child: Row(
                  children: [
                    Icon(Icons.settings_display_rounded,
                        size: screenWidth * 0.036,
                        color:
                            selectedColor == mode_3 ? white : Colors.black54),
                    SizedBox(
                      width: screenHeight * 0.010,
                    ),
                    Text(
                      "Appearance",
                      style: TextStyle(
                          color: selectedColor == mode_3 ? white : Colors.black,
                          fontSize: screenWidth * 0.026),
                    )
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.010),
              Text(
                "Text",
                style: TextStyle(
                    color: selectedColor == mode_3 ? white : Colors.black,
                    fontSize: screenWidth * 0.026),
              ),
              StatefulBuilder(
                builder: (BuildContext context,
                    void Function(void Function()) setState) {
                  return SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: screenWidth * 0.006,
                      activeTickMarkColor: Colors.transparent,
                      inactiveTickMarkColor: Colors.transparent,
                      thumbShape: RoundSliderThumbShape(
                          enabledThumbRadius: screenWidth * 0.016),
                      overlayShape: RoundSliderOverlayShape(
                          overlayRadius: screenWidth * 0.024),
                    ),
                    child: Slider(
                      min: 10,
                      value: latinTextSizeProvider.currentLatinTextSize,
                      max: 40,
                      divisions: 10,
                      label: latinTextSizeProvider.currentLatinTextSize
                          .round()
                          .toString(),
                      onChanged: (double value) {
                        setState(() {
                          latinTextSizeProvider.updateLatinTextSize(value);
                        });
                      },
                    ),
                  );
                },
              ),
              SizedBox(height: screenHeight * 0.005),
              Text(
                "Arabic",
                style: TextStyle(
                    color: selectedColor == mode_3 ? white : Colors.black,
                    fontSize: screenWidth * 0.026),
              ),
              StatefulBuilder(
                builder: (BuildContext context,
                    void Function(void Function()) setState) {
                  return SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: screenWidth * 0.006,
                      activeTickMarkColor: Colors.transparent,
                      inactiveTickMarkColor: Colors.transparent,
                      thumbShape: RoundSliderThumbShape(
                          enabledThumbRadius: screenWidth * 0.016),
                      overlayShape: RoundSliderOverlayShape(
                          overlayRadius: screenWidth * 0.024),
                    ),
                    child: Slider(
                      min: 10,
                      value: arabicTextSizeProvider.currentArabicTextSize,
                      max: 40,
                      divisions: 10,
                      label: arabicTextSizeProvider.currentArabicTextSize
                          .round()
                          .toString(),
                      onChanged: (double value) {
                        setState(() {
                          arabicTextSizeProvider.updateArabicTextSize(value);
                        });
                      },
                    ),
                  );
                },
              ),
              SizedBox(height: screenHeight * 0.008),
              Consumer<ColorModel>(builder: (context, colorModel, _) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        colorModel.setSelectedColor(mode_1);
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: screenHeight * 0.025,
                        width: screenWidth * 0.100,
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(3)),
                          color: mode_1,
                          border: Border.all(
                              color: colorModel.selectedColor == mode_1
                                  ? primary
                                  : Colors.transparent),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        colorModel.setSelectedColor(mode_2);
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: screenHeight * 0.025,
                        width: screenWidth * 0.100,
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(3)),
                          color: mode_2,
                          border: Border.all(
                              color: colorModel.selectedColor == mode_2
                                  ? primary
                                  : Colors.transparent),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        colorModel.setSelectedColor(mode_3);
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: screenHeight * 0.025,
                        width: screenWidth * 0.100,
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(3)),
                          color: mode_3,
                          border: Border.all(
                              color: colorModel.selectedColor == mode_3
                                  ? primary
                                  : Colors.transparent),
                        ),
                      ),
                    ),
                  ],
                );
              })
            ],
          ),
        ),
        child: Icon(
          Icons.more_vert,
          size: screenWidth * 0.044,
          color:
              selectedColor == mode_3 ? white.withOpacity(0.8) : Colors.black54,
        ),
      ),
    );
  }
}
