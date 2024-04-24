import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:offline_quran_app/features/core/screens/tafsir/para/para.dart';
import 'package:offline_quran_app/features/core/screens/tafsir/sajda/sajda.dart';
import 'package:offline_quran_app/features/core/screens/tafsir/saved/saved_ayah.dart';
import 'package:offline_quran_app/features/core/screens/tafsir/surah/surah.dart';

import '../../../../constant/color.dart';
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
    return Scaffold(
      backgroundColor: background,
      appBar: _appBar(),
      body: DefaultTabController(
        length: 4,
        child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                pinned: true,
                elevation: 0,
                backgroundColor: gray,
                automaticallyImplyLeading: false,
                shape: Border(
                    bottom: BorderSide(
                        width: 3,
                        color: const Color(0xFFAAAAAA).withOpacity(.1))),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(0),
                  child: _tab(),
                ),
              )
            ],
            body:  Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TabBarView(
                  controller: _tabController,
                  children: const [SurahPage(), ParaPage(), SajdaPage(), SavedAyahTafsir()]),
            )),
      ),
    );
  }

  TabBar _tab() {
    return TabBar(
        unselectedLabelColor: text,
        labelColor: Colors.white,
        indicatorColor: primary,
        indicatorWeight: 3,
        controller: _tabController,
        tabs: [
          _tabItem(label: "Surahs"),
          _tabItem(label: "Para"),
          _tabItem(label: "Sajda"),
          _tabItem(label: "Saved"),
        ]);
  }

  Tab _tabItem({required String label}) {
    return Tab(
      child: Text(
        label,
        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }

  AppBar _appBar() => AppBar(
    backgroundColor: gray,
    automaticallyImplyLeading: false,
    elevation: 0,
    title: Row(children: [
      Text(
        'Tafsir',
        style:
        GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: white.withOpacity(0.8)),
      ),
      const Spacer(),
      IconButton(
          onPressed: (() => {}),
          icon: Icon(Icons.menu_book, size: 24, color: text,)),
      IconButton(
          onPressed: (() => {
            showSearch(
              context: context,
              delegate: CustomSearch(context),
            ),
          }),
          icon: SvgPicture.asset('assets/svgs/search-icon.svg')),
    ]),
  );
}
