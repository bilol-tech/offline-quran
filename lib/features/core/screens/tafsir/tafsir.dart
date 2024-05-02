import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:offline_quran_app/features/core/screens/tafsir/para/para.dart';
import 'package:offline_quran_app/features/core/screens/tafsir/sajda/sajda.dart';
import 'package:offline_quran_app/features/core/screens/tafsir/saved/saved_ayah.dart';
import 'package:offline_quran_app/features/core/screens/tafsir/surah/surah.dart';

import '../../../../constant/color.dart';
import '../../../../theme/theme.dart';
import '../search/search_bar.dart';

class Tafsir extends StatefulWidget {
  final int selectedIndex;
  const Tafsir({super.key, required this.selectedIndex});

  @override
  State<Tafsir> createState() => _TafsirState();
}

class _TafsirState extends State<Tafsir> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 4,
      vsync: this,
      initialIndex: widget.selectedIndex, // Set the initial index
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final themeData = Theme.of(context);
    final light = themeData.brightness == Brightness.light;
    print(themeData.brightness == Brightness.light ? 'Light Mode' : 'Dark Mode');
    return Scaffold(
      backgroundColor: light ? lightBackgroundYellow : background,
      appBar: AppBar(
        backgroundColor: light ? lightBackgroundWhite : gray,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Row(children: [
          Text(
            'Tafsir',
            style:
            GoogleFonts.poppins(fontSize: screenWidth * 0.06, fontWeight: FontWeight.bold, color: light ? Colors.black : white.withOpacity(0.8)),
          ),
          const Spacer(),
          // IconButton(
          //     onPressed: (() => {}),
          //     icon: Icon(Icons.menu_book, size: screenWidth * 0.055, color: light ? Colors.black87 : text,)),
          IconButton(
              onPressed: (() => {
                showSearch(
                  context: context,
                  delegate: CustomSearch(context),
                ),
              }),
              icon: SvgPicture.asset('assets/svgs/search-icon.svg', width: screenWidth * 0.055, color: light ? Colors.black87 : text,)),
        ]),
      ),
      body: DefaultTabController(
        length: 4,
        child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                pinned: true,
                elevation: 0,
                backgroundColor: light ? lightBackgroundWhite : gray,
                automaticallyImplyLeading: false,
                shape: Border(
                    bottom: BorderSide(
                        width: 3,
                        color: const Color(0xFFAAAAAA).withOpacity(.1))),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(0),
                  child: TabBar(
                      unselectedLabelColor: text,
                      labelColor: light ? Colors.black : white,
                      indicatorColor: primary,
                      indicatorWeight: 3,
                      controller: _tabController,
                      tabs: [
                        _tabItem(label: "Surahs", fontSize: screenWidth * 0.038),
                        _tabItem(label: "Para", fontSize: screenWidth * 0.038),
                        _tabItem(label: "Sajda", fontSize: screenWidth * 0.038),
                        _tabItem(label: "Saved", fontSize: screenWidth * 0.038),
                      ]),
                ),
              )
            ],
            body:  Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.035),
              child: TabBarView(
                  controller: _tabController,
                  children: const [SurahPage(), ParaPage(), SajdaPage(), SavedAyahTafsir()]),
            )),
      ),
    );
  }


  Tab _tabItem({required String label, required double fontSize}) {
    return Tab(
      child: Text(
        label,
        style: GoogleFonts.poppins(fontSize: fontSize, fontWeight: FontWeight.w600),
      ),
    );
  }
}
