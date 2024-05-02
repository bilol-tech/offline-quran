import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:offline_quran_app/features/core/screens/audio/audio_surah.dart';
import 'package:offline_quran_app/features/core/screens/prayers/prayer_time.dart';
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
    final themeData = Theme.of(context);
    final light = themeData.brightness == Brightness.light;
    print(themeData.brightness == Brightness.light ? 'Light Mode' : 'Dark Mode');

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      // backgroundColor: light ? lightBackgroundWhite : background,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: light ? lightBackgroundWhite : gray,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: SvgPicture.asset("assets/svgs/lamp-icon.svg", color: text, width: screenWidth * 0.08,), activeIcon: SvgPicture.asset("assets/svgs/lamp-icon.svg", color: primary, width: screenWidth * 0.08,), label: "Home"),
          BottomNavigationBarItem(icon: SvgPicture.asset("assets/svgs/quran-icon.svg", color: text, width: screenWidth * 0.08,), activeIcon: SvgPicture.asset("assets/svgs/quran-icon.svg", color: primary, width: screenWidth * 0.08,), label: "Tafsir"),
          BottomNavigationBarItem(icon: SvgPicture.asset("assets/svgs/pray-icon.svg", color: text, width: screenWidth * 0.08,), activeIcon: SvgPicture.asset("assets/svgs/pray-icon.svg", color: primary, width: screenWidth * 0.08,), label: "Prayer Time"),
          BottomNavigationBarItem(icon: SvgPicture.asset("assets/svgs/audio.svg", color: text, width: screenWidth * 0.08,), activeIcon: SvgPicture.asset("assets/svgs/audio.svg", color: primary, width: screenWidth * 0.08,), label: "Audio"),
          BottomNavigationBarItem(icon: SvgPicture.asset("assets/svgs/doa-icon.svg", color: text, width: screenWidth * 0.08,), activeIcon: SvgPicture.asset("assets/svgs/doa-icon.svg", color: primary, width: screenWidth * 0.08,), label: "Profile"),
        ],
      ),
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
        return const Prayers();
      case 3:
        return const AudioSurah();
      default:
        return const ProfileScreen();
    }
  }


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
