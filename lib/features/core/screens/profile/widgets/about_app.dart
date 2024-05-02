import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart' show rootBundle;



import '../../../../../constant/color.dart';

class AboutApp extends StatefulWidget {
  const AboutApp({super.key});

  @override
  State<AboutApp> createState() => _AboutAppState();
}

class _AboutAppState extends State<AboutApp> {
  late String _appVersion = '';

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    try {
      final pubspecString = await rootBundle.loadString('pubspec.yaml');
      final lines = pubspecString.split('\n');
      for (final line in lines) {
        if (line.trimLeft().startsWith('version:')) {
          _appVersion = line.split(':')[1].trim();
          break;
        }
      }
    } catch (e) {
      print('Error loading app version: $e');
    }
    if (!mounted) return; // Prevent calling setState if the widget is disposed
    setState(() {});
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
        backgroundColor: light ? white : gray,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Row(children: [
          IconButton(
              onPressed: (() => Navigator.of(context).pop()),
              icon: SvgPicture.asset(
                'assets/svgs/back-icon.svg',
                width: screenWidth * 0.055,
                color: light ? Colors.black87 : white.withOpacity(0.8),
              )),
          SizedBox(
            width: screenHeight * 0.024,
          ),
          Text(
            'About App',
            style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.044,
                fontWeight: FontWeight.bold,
                color: light ? black : white.withOpacity(0.8)),
          ),
        ]),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15,),
              Text("Welcome to the bilol_tech Daily Quran app, your comprehensive guide to reading and understanding the Holy Quran.", style: TextStyle(fontSize: screenWidth * 0.036),),
              SizedBox(height: screenHeight * 0.015,),
              Text("With our app, you can easily access Surahs, Parahs, Sajda Ayahs, and even save your favorite verses for later reference.", style: TextStyle(fontSize: screenWidth * 0.036),),
              SizedBox(height: screenHeight * 0.015,),
              Text("Our user-friendly interface makes it simple to navigate through the Quran, whether you're searching for specific verses or exploring the teachings of Islam.", style: TextStyle(fontSize: screenWidth * 0.036),),
              SizedBox(height: screenHeight * 0.015,),
              Text("Stay connected with prayer times and enrich your spiritual journey with our carefully curated content.", style: TextStyle(fontSize: screenWidth * 0.036),),
              SizedBox(height: screenHeight * 0.015,),
              Text("Share and Support bilol_tech Daily Quran app.", style: TextStyle(fontSize: screenWidth * 0.036),),
              const Spacer(),
              Center(child: Text("Version: $_appVersion", style: TextStyle(fontSize: screenWidth * 0.036),)),
              SizedBox(height: screenHeight * 0.020,)
            ],
          ),
        ),
      ),
    );
  }
}
