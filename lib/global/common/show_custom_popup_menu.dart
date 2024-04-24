// import 'dart:convert';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_popup/flutter_popup.dart';
// import 'package:http/http.dart' as http;
// import 'package:provider/provider.dart';
//
// import '../../constant/color.dart';
// import '../../features/core/provider/color_provider.dart';
// import '../../features/core/provider/text_size_provider.dart';
// import '../../features/core/screens/search/search_bar.dart';
// import '../../features/core/screens/tafsir/surah/surah_details.dart';
//
// class CustomPopupMenu extends StatefulWidget {
//   final String pageName;
//   const CustomPopupMenu({super.key, required this.pageName});
//
//   @override
//   State<CustomPopupMenu> createState() => _CustomPopupMenuState();
// }
//
// class _CustomPopupMenuState extends State<CustomPopupMenu> {
//   List<dynamic> surahs = [];
//   String? selectedSurah;
//   List<dynamic> ayahs = [];
//   String? selectedAyah;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchSurahs();
//   }
//
//   Future<void> fetchSurahs() async {
//     final response =
//         await http.get(Uri.parse('https://api.alquran.cloud/v1/surah'));
//     if (response.statusCode == 200) {
//       final parsed = json.decode(response.body);
//       setState(() {
//         surahs = parsed['data'];
//       });
//     }
//   }
//
//   Future<void> fetchSurahAyahs(int surahNumber) async {
//     final response = await http
//         .get(Uri.parse('https://api.alquran.cloud/v1/surah/$surahNumber'));
//     if (response.statusCode == 200) {
//       final parsed = json.decode(response.body);
//       setState(() {
//         ayahs = parsed['data']['ayahs'];
//       });
//     }
//   }
//
//   GlobalKey _popupMenuKey = GlobalKey();
//   Color? selectedColor;
//
//
//   @override
//   Widget build(BuildContext context) {
//     Color? selectedColor = Provider.of<ColorModel>(context).selectedColor;
//     final latinTextSizeProvider = Provider.of<LatinTextSizeProvider>(context);
//     final arabicTextSizeProvider = Provider.of<ArabicTextSizeProvider>(context);
//     return Padding(
//       padding: const EdgeInsets.only(right: 15),
//       child: CustomPopup(
//         barrierColor: Colors.transparent,
//         contentRadius: 5,
//         showArrow: false,
//         backgroundColor: selectedColor,
//         arrowColor: Colors.red,
//         content: SizedBox(
//           width: 170,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               InkWell(
//                 onTap: () {
//                   if (mounted) {
//                     Navigator.pop(context); // Close the current screen
//                     showSearch(
//                       context: context,
//                       delegate: CustomSearch(context),
//                     );
//                   }
//                 },
//                 child: Row(
//                   children: [
//                     Icon(
//                       Icons.search,
//                       size: 18,
//                       color: selectedColor == mode_3 ? white : Colors.black54,
//                     ),
//                     const SizedBox(
//                       width: 10,
//                     ),
//                     Text(
//                       "Search",
//                       style: TextStyle(color: selectedColor == mode_3 ? white : Colors.black, fontSize: 13),
//                     )
//                   ],
//                 ),
//               ),
//               const SizedBox(
//                 height: 18,
//               ),
//               InkWell(
//                 onTap: () {
//                   if (mounted) {
//                     Navigator.pop(context); // Close the current screen
//                     showModalBottomSheet(
//                       context: context,
//                       backgroundColor: gray,
//                       builder: (BuildContext context) {
//                         return Container(
//                           height: MediaQuery.of(context).size.height * 0.26,
//                           color: gray,
//                           child: Column(
//                             children: [
//                                Padding(
//                                 padding: const EdgeInsets.only(left: 12.0, top: 12),
//                                 child: Row(
//                                   children: [
//                                     Icon(
//                                       Icons.swipe_vertical_rounded,
//                                       size: 20,
//                                       color: white
//                                     ),
//                                     const SizedBox(
//                                       width: 8,
//                                     ),
//                                     Text(
//                                       "Go Surah & Ayah",
//                                       style: TextStyle(color: white),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               const SizedBox(
//                                 height: 4,
//                               ),
//                               Divider(
//                                 color: Colors.grey.withOpacity(0.6),
//                                 thickness: 0.3,
//                               ),
//                               Padding(
//                                 padding:
//                                 const EdgeInsets.only(left: 12.0, top: 12),
//                                 child: Row(
//                                   mainAxisAlignment:
//                                   MainAxisAlignment.spaceAround,
//                                   children: [
//                                     Column(
//                                       crossAxisAlignment:
//                                       CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           "Surah",
//                                           style: TextStyle(color: white),
//                                         ),
//                                         const SizedBox(
//                                           height: 5,
//                                         ),
//                                         Container(
//                                           width:
//                                           MediaQuery.of(context).size.width *
//                                               0.38,
//                                           height: 36,
//                                           decoration: BoxDecoration(
//                                             borderRadius:  const BorderRadius.all(
//                                                 Radius.circular(6)),
//                                             color: modalSheetColor,
//                                           ),
//                                           child: StatefulBuilder(
//                                             builder: (BuildContext context,
//                                                 void Function(void Function())
//                                                 setState) {
//                                               return DropdownButton<String>(
//                                                 hint: Padding(
//                                                   padding:
//                                                   const EdgeInsets.only(left: 8.0),
//                                                   child: Text('Select Surah',
//                                                       style: TextStyle(
//                                                           color: white,
//                                                           fontSize: 12)),
//                                                 ),
//                                                 value: selectedSurah,
//                                                 onChanged: (value) {
//                                                   setState(() {
//                                                     selectedSurah = value;
//                                                     fetchSurahAyahs(surahs
//                                                         .firstWhere((surah) =>
//                                                     surah[
//                                                     'englishName'] ==
//                                                         value)['number']);
//                                                   });
//                                                 },
//                                                 underline: Container(),
//                                                 alignment: Alignment.centerLeft,
//                                                 borderRadius:
//                                                 BorderRadius.circular(8),
//                                                 dropdownColor: background,
//                                                 icon: Icon(
//                                                     Icons.arrow_drop_down,
//                                                     color: white),
//                                                 items: surahs.map<
//                                                     DropdownMenuItem<String>>(
//                                                         (surah) {
//                                                       return DropdownMenuItem<String>(
//                                                         value: surah['englishName'],
//                                                         child: Padding(
//                                                           padding:
//                                                           const EdgeInsets.only(
//                                                               left: 10.0),
//                                                           child: Text(
//                                                               surah['englishName'],
//                                                               style: TextStyle(
//                                                                   color: white,
//                                                                   fontSize: 14)),
//                                                         ),
//                                                       );
//                                                     }).toList(),
//                                               );
//                                             },
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     Column(
//                                       crossAxisAlignment:
//                                       CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           "Ayah",
//                                           style: TextStyle(color: white),
//                                         ),
//                                         const SizedBox(
//                                           height: 5,
//                                         ),
//                                         Container(
//                                           width:
//                                           MediaQuery.of(context).size.width *
//                                               0.38,
//                                           height: 36,
//                                           decoration: BoxDecoration(
//                                             borderRadius: const BorderRadius.all(
//                                                 Radius.circular(6)),
//                                             color: modalSheetColor,
//                                           ),
//                                           child: StatefulBuilder(
//                                             builder: (BuildContext context,
//                                                 void Function(void Function())
//                                                 setState) {
//                                               return DropdownButton<String>(
//                                                 hint: Padding(
//                                                   padding:
//                                                   const EdgeInsets.only(left: 8.0),
//                                                   child: Text('Select Ayah',
//                                                       style: TextStyle(
//                                                           color: white,
//                                                           fontSize: 12)),
//                                                 ),
//                                                 value: selectedAyah,
//                                                 onChanged: (value) {
//                                                   setState(() {
//                                                     selectedAyah = value;
//                                                   });
//                                                 },
//                                                 underline: Container(),
//                                                 alignment: Alignment.centerLeft,
//                                                 borderRadius:
//                                                 BorderRadius.circular(8),
//                                                 dropdownColor: background,
//                                                 icon: Padding(
//                                                   padding:
//                                                   const EdgeInsets.only(left: 42.0),
//                                                   child: Icon(
//                                                       Icons.arrow_drop_down,
//                                                       color: white),
//                                                 ),
//                                                 items: ayahs.map<
//                                                     DropdownMenuItem<String>>(
//                                                         (ayah) {
//                                                       return DropdownMenuItem<String>(
//                                                         value:
//                                                         '${ayah['numberInSurah']}',
//                                                         child: Padding(
//                                                           padding:
//                                                           const EdgeInsets.only(
//                                                               left: 10.0),
//                                                           child: Text(
//                                                             '${ayah['numberInSurah']}'
//                                                                 .toString(),
//                                                             style: TextStyle(
//                                                                 color: white,
//                                                                 fontSize: 14),
//                                                           ),
//                                                         ),
//                                                       );
//                                                     }).toList(),
//                                               );
//                                             },
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               const SizedBox(
//                                 height: 15,
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.only(right: 21.0),
//                                 child: Row(
//                                   crossAxisAlignment: CrossAxisAlignment.end,
//                                   mainAxisAlignment: MainAxisAlignment.end,
//                                   children: [
//                                     InkWell(
//                                       onTap: () {
//                                         setState(() {
//                                           selectedSurah = null;
//                                           selectedAyah = null;
//                                         });
//                                         Navigator.pop(context);
//                                       },
//                                       child: Container(
//                                         width: 90,
//                                         height: 28,
//                                         decoration: const BoxDecoration(
//                                           borderRadius: BorderRadius.all(
//                                               Radius.circular(6)),
//                                         ),
//                                         child: Center(
//                                             child: Text(
//                                               "cancel".toUpperCase(),
//                                               style: TextStyle(
//                                                   color: white, fontSize: 12),
//                                             )),
//                                       ),
//                                     ),
//                                     InkWell(
//                                       onTap: () {
//                                         if (selectedSurah != null &&
//                                             selectedAyah != null) {
//                                           final selectedSurahData =
//                                           surahs.firstWhere((surah) =>
//                                           surah['englishName'] ==
//                                               selectedSurah);
//                                           final surahNumber =
//                                           selectedSurahData['number'];
//                                           final surahName =
//                                           selectedSurahData['englishName'];
//                                           final englishName =
//                                           selectedSurahData['englishName'];
//                                           final revelationType =
//                                           selectedSurahData['revelationType'];
//                                           final numberOfAyahs =
//                                           selectedSurahData['numberOfAyahs'];
//
//                                           final selectedAyahData =
//                                           ayahs.firstWhere((ayah) =>
//                                           ayah['numberInSurah']
//                                               .toString() ==
//                                               selectedAyah);
//                                           final selectedAyahIndex =
//                                           ayahs.indexOf(selectedAyahData);
//
//                                           print(
//                                               'Selected Ayah Index: $selectedAyahIndex');
//
//                                           if(widget.pageName == "SurahDetails"){
//                                             Navigator.push(
//                                               context,
//                                               MaterialPageRoute(
//                                                 builder: (_) => SurahDetails(
//                                                   surahNumber,
//                                                   surahName,
//                                                   englishName,
//                                                   revelationType,
//                                                   numberOfAyahs,
//                                                   specificAyah: selectedAyahIndex,
//                                                   // specificAyah: ,
//                                                 ),
//                                               ),
//                                             ).then((_) {
//                                               // Close the popup menu after navigating back
//                                               if (mounted) {
//                                                 Navigator.pop(context);
//                                               }
//                                             });
//                                           } else if(widget.pageName == "AudioDetails"){
//                                             Navigator.push(
//                                               context,
//                                               MaterialPageRoute(
//                                                 builder: (_) => AudioSurahDetails(
//                                                   surahNumber,
//                                                   surahName,
//                                                   englishName,
//                                                   revelationType,
//                                                   numberOfAyahs,
//                                                   specificAyah: selectedAyahIndex,
//                                                   // specificAyah: ,
//                                                 ),
//                                               ),
//                                             ).then((_) {
//                                               // Close the popup menu after navigating back
//                                               if (mounted) {
//                                                 Navigator.pop(context);
//                                               }
//                                             });
//                                           }
//                                         }
//                                       },
//                                       child: Container(
//                                         width: 90,
//                                         height: 28,
//                                         decoration: const BoxDecoration(
//                                             borderRadius: BorderRadius.all(
//                                                 Radius.circular(6)),
//                                             color: Colors.green),
//                                         child: Center(
//                                             child: Text(
//                                               "save".toUpperCase(),
//                                               style: TextStyle(
//                                                   color: white, fontSize: 12),
//                                             )),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               )
//                             ],
//                           ),
//                         );
//                       },
//                     );
//                   }
//                 },
//                 child: Row(
//                   children: [
//                     Icon(
//                       Icons.swipe_vertical_rounded,
//                       size: 18,
//                       color: selectedColor == mode_3 ? white : Colors.black54
//                     ),
//                     const SizedBox(
//                       width: 10,
//                     ),
//                     Text(
//                       "Go ayah",
//                       style: TextStyle(color: selectedColor == mode_3 ? white : Colors.black, fontSize: 13),
//                     )
//                   ],
//                 ),
//               ),
//               const SizedBox(
//                 height: 18,
//               ),
//               InkWell(
//                 onTap: (){
//                   Navigator.of(context).push(
//                     PageRouteBuilder(
//                       pageBuilder: (_, __, ___) => const SettingsPage(),
//                       transitionsBuilder: (_, animation, __, child) {
//                         return SlideTransition(
//                           position: Tween<Offset>(
//                             begin: const Offset(1.0, 0.0), // Start from right side
//                             end: Offset.zero, // Move to the center
//                           ).animate(animation),
//                           child: child,
//                         );
//                       },
//                     ),
//                   ).then((_) {
//                     // Close the popup menu after navigating back
//                     if (mounted) {
//                       Navigator.pop(context);
//                     }
//                   });
//                 },
//                 child: Row(
//                   children: [
//                     Icon(
//                       Icons.settings,
//                       size: 18,
//                       color: selectedColor == mode_3 ? white : Colors.black54
//                     ),
//                     const SizedBox(
//                       width: 10,
//                     ),
//                     Text(
//                       "Settings",
//                       style: TextStyle(color: selectedColor == mode_3 ? white : Colors.black, fontSize: 13),
//                     )
//                   ],
//                 ),
//               ),
//               const SizedBox(
//                 height: 18,
//               ),
//               InkWell(
//                 onTap: (){
//                   Navigator.of(context).push(
//                     PageRouteBuilder(
//                       pageBuilder: (_, __, ___) => const ApearencePage(),
//                       transitionsBuilder: (_, animation, __, child) {
//                         return SlideTransition(
//                           position: Tween<Offset>(
//                             begin: const Offset(1.0, 0.0), // Start from right side
//                             end: Offset.zero, // Move to the center
//                           ).animate(animation),
//                           child: child,
//                         );
//                       },
//                     ),
//                   ).then((_) {
//                     // Close the popup menu after navigating back
//                     if (mounted) {
//                       Navigator.pop(context);
//                     }
//                   });
//                 },
//                 child: Row(
//                   children: [
//                     Icon(
//                       Icons.settings_display_rounded,
//                       size: 18,
//                       color: selectedColor == mode_3 ? white : Colors.black54
//                     ),
//                     const SizedBox(
//                       width: 10,
//                     ),
//                     Text(
//                       "Appearance",
//                       style: TextStyle(color: selectedColor == mode_3 ? white : Colors.black, fontSize: 13),
//                     )
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 10),
//               Text(
//                 "Text",
//                 style: TextStyle(color: selectedColor == mode_3 ? white : Colors.black, fontSize: 13),
//               ),
//               StatefulBuilder(
//                 builder: (BuildContext context,
//                     void Function(void Function()) setState) {
//                   return SliderTheme(
//                     data: SliderTheme.of(context).copyWith(
//                       trackHeight: 3.0,
//                       activeTickMarkColor: Colors.transparent,
//                       inactiveTickMarkColor: Colors.transparent,
//                       thumbShape:
//                           const RoundSliderThumbShape(enabledThumbRadius: 8.0),
//                       overlayShape:
//                           const RoundSliderOverlayShape(overlayRadius: 12.0),
//                     ),
//                     child: Slider(
//                       min: 16,
//                       value: latinTextSizeProvider.currentLatinTextSize,
//                       max: 40,
//                       divisions: 10,
//                       label: latinTextSizeProvider.currentLatinTextSize
//                           .round()
//                           .toString(),
//                       onChanged: (double value) {
//                         setState(() {
//                           latinTextSizeProvider.updateLatinTextSize(value);
//                         });
//                       },
//                     ),
//                   );
//                 },
//               ),
//               const SizedBox(height: 5),
//               Text(
//                 "Arabic",
//                 style: TextStyle(color: selectedColor == mode_3 ? white : Colors.black, fontSize: 13),
//               ),
//               StatefulBuilder(
//                 builder: (BuildContext context,
//                     void Function(void Function()) setState) {
//                   return SliderTheme(
//                     data: SliderTheme.of(context).copyWith(
//                       trackHeight: 3.0,
//                       activeTickMarkColor: Colors.transparent,
//                       inactiveTickMarkColor: Colors.transparent,
//                       thumbShape:
//                           const RoundSliderThumbShape(enabledThumbRadius: 8.0),
//                       overlayShape:
//                           const RoundSliderOverlayShape(overlayRadius: 12.0),
//                     ),
//                     child: Slider(
//                       min: 16,
//                       value: arabicTextSizeProvider.currentArabicTextSize,
//                       max: 40,
//                       divisions: 10,
//                       label: arabicTextSizeProvider.currentArabicTextSize
//                           .round()
//                           .toString(),
//                       onChanged: (double value) {
//                         setState(() {
//                           arabicTextSizeProvider.updateArabicTextSize(value);
//                         });
//                       },
//                     ),
//                   );
//                 },
//               ),
//               const SizedBox(height: 8),
//               Consumer<ColorModel>(
//                 builder: (context, colorModel, _){
//                   return Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       InkWell(
//                         onTap: (){
//                           colorModel.setSelectedColor(mode_1);
//                           Navigator.pop(context);
//                         },
//                         child: Container(
//                           height: 25,
//                           width: 50,
//                           decoration: BoxDecoration(
//                               borderRadius:
//                               const BorderRadius.all(Radius.circular(3)),
//                               color: mode_1,
//                               border: Border.all(color: colorModel.selectedColor == mode_1 ? primary : Colors.transparent),
//                           ),
//                         ),
//                       ),
//                       InkWell(
//                         onTap: () {
//                           colorModel.setSelectedColor(mode_2);
//                           Navigator.pop(context);
//                         },
//                         child: Container(
//                           height: 25,
//                           width: 50,
//                           decoration: BoxDecoration(
//                               borderRadius:
//                               const BorderRadius.all(Radius.circular(3)),
//                               color: mode_2,
//                               border: Border.all(color: colorModel.selectedColor == mode_2 ? primary : Colors.transparent),
//                           ),
//                         ),
//                       ),
//                       InkWell(
//                         onTap: () {
//                           colorModel.setSelectedColor(mode_3);
//                           Navigator.pop(context);
//                         },
//                         child: Container(
//                           height: 25,
//                           width: 50,
//                           decoration: BoxDecoration(
//                               borderRadius:
//                               const BorderRadius.all(Radius.circular(3)),
//                               color: mode_3,
//                               border: Border.all(color: colorModel.selectedColor == mode_3 ? primary : Colors.transparent),
//                           ),
//                         ),
//                       ),
//                     ],
//                   );
//                 }
//               )
//             ],
//           ),
//         ),
//         child: Icon(Icons.more_vert, color: selectedColor == mode_3 ? white.withOpacity(0.8) : Colors.black54,),
//       ),
//     );
//   }
// }
