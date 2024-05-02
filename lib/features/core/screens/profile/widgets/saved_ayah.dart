import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../../../constant/color.dart';
import '../../../models/saved_ayah.dart';
import '../../../provider/saved_ayah_provider.dart';
import '../../tafsir/surah/surah_details.dart';

class SavedAyahPage extends StatefulWidget {
  @override
  State<SavedAyahPage> createState() => _SavedAyahPageState();
}

class _SavedAyahPageState extends State<SavedAyahPage> {

  SavedAyah? savedAyah;

  @override
  Widget build(BuildContext context) {
    final SavedAyahProvider savedAyahProvider = Provider.of<SavedAyahProvider>(context);
    final List<SavedAyah> savedAyahs = savedAyahProvider.savedAyahs;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    final themeData = Theme.of(context);
    final light = themeData.brightness == Brightness.light;
    print(themeData.brightness == Brightness.light ? 'Light Mode' : 'Dark Mode');

    return Scaffold(
      backgroundColor: light ? lightBackgroundYellow : background,
      appBar: AppBar(
        backgroundColor: light ? white : gray,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Row(children: [
          IconButton(
              onPressed: (() => Navigator.of(context).pop()),
              icon: SvgPicture.asset('assets/svgs/back-icon.svg', width: screenWidth * 0.055, color: light ? Colors.black87 : text,)),
          SizedBox(
            width: screenHeight * 0.024,
          ),
          Text(
            'Saved Ayahs',
            style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.040,
                fontWeight: FontWeight.bold,
                color: light ? black : white.withOpacity(0.8)),
          ),
        ]),
      ),
      body: ScrollablePositionedList.separated(
        itemCount: savedAyahs.length,
        itemBuilder: (context, index) {
          final savedAyah = savedAyahs[index];
          return Padding(
            padding: index == 0 ? EdgeInsets.only(top: screenHeight * 0.008) : EdgeInsets.zero,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: screenHeight * 0.010, vertical: screenHeight * 0.005),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                color: light ? white : gray,
                border: Border.all(color: text, width: 0.11)
              ),
              child: InkWell(
                onTap: (){
                  int ayahNumberConverted = int.parse(savedAyah.ayahNumber.split(':').first);
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => SurahDetails(
                        savedAyah.surahNumber,
                        savedAyah.surahName,
                        savedAyah.surahName,
                        savedAyah.surahName,
                        savedAyah.surahNumber,
                        specificAyah: ayahNumberConverted - 1
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
                child: ListTile(
                  title: Text(savedAyah.surahName, style: TextStyle(fontSize: screenWidth * 0.040),),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${savedAyah.ayahNumber.split(':').first}. ${savedAyah.ayahTranslatedText}',
                        maxLines: 3,
                        overflow: TextOverflow.clip,
                        style: TextStyle(fontSize: screenWidth * 0.035),
                      ),
                      // Text('Surah Number: ${savedAyah.surahNumber}'),
                      // Text('Ayah Translated Text: ${savedAyah.ayahTranslatedText}'),
                    ],
                  ),
                  trailing: GestureDetector(onTap: (){
                    setState(() {
                      Provider.of<SavedAyahProvider>(context, listen: false)
                          .removeAyahByIndex(index);
                    });
                  },child: Icon(Icons.delete, size: screenWidth * 0.050,)),
                ),
              ),
            ),
          );
        }, separatorBuilder: (BuildContext context, int index) {
          return const SizedBox();
      },
      ),
    );
  }
}
