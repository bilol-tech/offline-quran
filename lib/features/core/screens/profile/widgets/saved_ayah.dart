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

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: gray,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Row(children: [
          IconButton(
              onPressed: (() => Navigator.of(context).pop()),
              icon: SvgPicture.asset('assets/svgs/back-icon.svg')),
          const SizedBox(
            width: 24,
          ),
          Text(
            'Saved Ayahs',
            style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: white.withOpacity(0.8)),
          ),
        ]),
      ),
      body: ScrollablePositionedList.separated(
        itemCount: savedAyahs.length,
        itemBuilder: (context, index) {
          final savedAyah = savedAyahs[index];
          return Padding(
            padding: index == 0 ? const EdgeInsets.only(top: 8.0) : EdgeInsets.zero,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                color: gray
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
                  title: Text(savedAyah.surahName),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${savedAyah.ayahNumber.split(':').first}. ${savedAyah.ayahTranslatedText}',
                        maxLines: 3,
                        overflow: TextOverflow.clip,
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
                  },child: const Icon(Icons.delete)),
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
