import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:offline_quran_app/features/core/screens/audio/audio_surah.dart';
import 'package:offline_quran_app/features/core/screens/prayers/prayers.dart';
import 'package:offline_quran_app/features/core/screens/profile/profile.dart';
import 'package:offline_quran_app/features/core/screens/tafsir/tafsir.dart';

import '../../../constant/color.dart';
import 'home/home_screen.dart';

class MainScreen extends StatefulWidget {
  final int selectedIndex;
  const MainScreen({super.key, required this.selectedIndex});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      bottomNavigationBar: _bottomNavigationBar(),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return const HomeScreen();
      case 1:
        return Tafsir(selectedIndex: widget.selectedIndex);
      case 2:
        // return const Prayers();
        return const Prayers();
      case 3:
        // return const AudioSurah();
        return const AudioSurah();
      default:
        // return const ProfileScreen();
        return const ProfileScreen();
    }
  }


  BottomNavigationBar _bottomNavigationBar() => BottomNavigationBar(
    type: BottomNavigationBarType.fixed,
    backgroundColor: gray,
    showSelectedLabels: false,
    showUnselectedLabels: false,
    currentIndex: _currentIndex,
    onTap: (index) {
      setState(() {
        _currentIndex = index;
      });
    },
    items: [
      _bottomBarItem(icon: "assets/svgs/lamp-icon.svg", label: "Home"),
      _bottomBarItem(icon: "assets/svgs/quran-icon.svg", label: "Tafsir"),
      _bottomBarItem(icon: "assets/svgs/pray-icon.svg", label: "Prayers"),
      _bottomBarItem(icon: "assets/svgs/audio.svg", label: "Audio"),
      _bottomBarItem(icon: "assets/svgs/doa-icon.svg", label: "Profile"),
    ],
  );

  BottomNavigationBarItem _bottomBarItem(
      {required String icon, required String label}) =>
      BottomNavigationBarItem(
          icon: SvgPicture.asset(
            icon,
            color: text,
          ),
          activeIcon: SvgPicture.asset(
            icon,
            color: primary,
          ),
          label: label);
}
