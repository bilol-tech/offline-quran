import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../../../constant/color.dart';
import '../../../models/saved_ayah.dart';
import '../../../provider/saved_ayah_provider.dart';
import '../surah/surah_details.dart';


class SavedAyahTafsir extends StatefulWidget {
  const SavedAyahTafsir({super.key});

  @override
  State<SavedAyahTafsir> createState() => _SavedAyahTafsirState();
}

class _SavedAyahTafsirState extends State<SavedAyahTafsir> {

  SavedAyah? savedAyah;

  @override
  Widget build(BuildContext context) {
    final SavedAyahProvider savedAyahProvider = Provider.of<SavedAyahProvider>(context);
    final List savedAyahs = savedAyahProvider.savedAyahs;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    final themeData = Theme.of(context);
    final light = themeData.brightness == Brightness.light;
    print(themeData.brightness == Brightness.light ? 'Light Mode' : 'Dark Mode');

    return ScrollablePositionedList.separated(
        // physics: const NeverScrollableScrollPhysics(),
        itemCount: savedAyahs.length,
        itemBuilder: (context, index) {
          final savedAyah = savedAyahs[index];
          return Container(
              margin: EdgeInsets.only(top: screenWidth * 0.020),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: light ? lightBackgroundWhite : gray,
                border: Border.all(color: text, width: 0.12)
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
                  print(ayahNumberConverted);
                },
                child: ListTile(
                  title: Text(savedAyah.surahName, style: TextStyle(color: light ? black : white, fontSize: screenWidth * 0.04),),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${savedAyah.ayahNumber.split(':').first}. ${savedAyah.ayahTranslatedText}',
                        maxLines: 3,
                        overflow: TextOverflow.clip,
                        style: TextStyle(color: text, fontSize: screenWidth * 0.03),
                      ),
                    ],
                  ),
                  trailing: GestureDetector(onTap: (){
                    setState(() {
                      Provider.of<SavedAyahProvider>(context, listen: false)
                          .removeAyahByIndex(index);
                    });
                  },child: Icon(Icons.delete, color: white, size: screenWidth * 0.043,)),
                ),
              ),
          );
        }, separatorBuilder: (BuildContext context, int index) {
        return const SizedBox();
      },
    );
  }
}
