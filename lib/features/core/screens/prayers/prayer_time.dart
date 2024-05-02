import 'dart:async';

import 'package:adhan/adhan.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';

import '../../../../constant/color.dart';

class Prayers extends StatefulWidget {
  const Prayers({super.key});

  @override
  State<Prayers> createState() => _PrayersState();
}

class _PrayersState extends State<Prayers> {

  late String formattedTime;

  @override
  void initState() {
    super.initState();
    updateTime();
    Timer.periodic(const Duration(seconds: 1), (Timer t) => updateTime());
  }

  void updateTime() {
    setState(() {
      formattedTime = DateFormat('hh:mm:ss').format(DateTime.now());
    });
  }

  @override
  Widget build(BuildContext context) {
    final myCoordinates = Coordinates(41.2995, 69.2401); // Tashkent Coordinates
    final params = CalculationMethod.muslim_world_league.getParameters();
    params.madhab = Madhab.hanafi;
    final prayerTimes = PrayerTimes.today(myCoordinates, params);
    final currentPrayerTime = prayerTimes.currentPrayer().toString().split('.').last;
    final nextPrayerTime = prayerTimes.nextPrayer().toString().split('.').last;
    print("Next Prayer Time: $nextPrayerTime");
    print("Current Prayer Time: $currentPrayerTime");
    final sunnahTimes = SunnahTimes(prayerTimes);
    final middleOfNight = sunnahTimes.middleOfTheNight;
    final lastThirdOfTheNight = sunnahTimes.lastThirdOfTheNight;


    var _today = HijriCalendar.now();
    String formattedHijriDate = _today.toFormat("dd DDDD MMMM yyyy");

    final timeNow = DateTime.now();
    String formattedTime = DateFormat('hh:mm:ss').format(timeNow);
    String formattedDate = DateFormat('EEE, dd MMM yyyy').format(timeNow);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    final themeData = Theme.of(context);
    final light = themeData.brightness == Brightness.light;
    print(themeData.brightness == Brightness.light ? 'Light Mode' : 'Dark Mode');

    // dynamic getTime() {
    //   switch (currentPrayerTime) {
    //     case 'none':
    //       return DateFormat.jm().format(prayerTimes.fajr);
    //     case 'fajr':
    //       return DateFormat.jm().format(prayerTimes.fajr);
    //     case 'sunrise':
    //       return DateFormat.jm().format(prayerTimes.sunrise);
    //     case 'duhur':
    //       return DateFormat.jm().format(prayerTimes.dhuhr);
    //     case 'asr':
    //       return DateFormat.jm().format(prayerTimes.asr);
    //     case 'maghrib':
    //       return DateFormat.jm().format(prayerTimes.maghrib);
    //     case 'isha':
    //       return DateFormat.jm().format(prayerTimes.isha);
    //     default:
    //       return '';
    //   }
    // }
    //
    // final prayerTime = getTime();


    return Scaffold(
      backgroundColor: light ? lightBackgroundYellow : background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.020),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Column(
                          children: [
                            SizedBox(height: screenHeight * 0.010,),
                            Row(
                              children: [
                                Icon(Icons.location_on_rounded, color: light ? Colors.black87 : text, size: screenWidth * 0.03,),
                                Text(" Uzbekistan, Tashkent", style: GoogleFonts.poppins(fontSize: screenWidth * 0.033, color: light ? Colors.black87 : text, fontWeight: FontWeight.w600),)
                              ],
                            ),
                            SizedBox(height: screenHeight * 0.015,),
                            Text(
                              formattedTime,
                              style: GoogleFonts.poppins(fontSize: screenWidth * 0.10, fontWeight: FontWeight.w600, color: light ? black : white),
                            ),
                            // Text("Asr less than 3h 6m", style: GoogleFonts.poppins(color: text, fontWeight: FontWeight.w400),),
                          ],
                        ),
                        const Spacer(),
                        SvgPicture.asset("assets/images/masjid.svg", width: screenWidth * 0.330, color: primary,),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.040,),
                    Row(
                      children: [
                        Text("Date", style: TextStyle(color: light ? Colors.black87 : text, fontSize: screenWidth * 0.025),),
                        SizedBox(width: screenWidth * 0.010,),
                        SizedBox(width: screenWidth * 0.1,child: Divider(color: light ? Colors.black54 : dividorColor,))
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.005,),
                    Text(
                      '${formattedHijriDate}',
                      style: TextStyle(fontSize: screenWidth * 0.04, color: light ? black : white, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: screenHeight * 0.002,),
                    Text(
                      '${formattedDate}',
                      style: TextStyle(fontSize: screenWidth * 0.032, color: light ? Colors.black54 : text),
                    ),
                    SizedBox(height: screenHeight * 0.020,),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.015,),
              Container(
                decoration: BoxDecoration(
                  color: currentPrayerTime == 'fajr' ? (light ? white : gray) : Colors.transparent,
                  border: Border.all(color: currentPrayerTime == 'fajr' && light ? text : Colors.transparent, width: 0.11)
                ),
                child: ListTile(
                  title: Text("Fajr", style: GoogleFonts.poppins(fontSize: screenWidth * 0.040, color: light ? black : white, fontWeight: FontWeight.w600),),
                  leading: Image.asset("assets/images/dark_fajr.png", width: screenWidth * 0.065,),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(DateFormat.jm().format(prayerTimes.fajr), style: GoogleFonts.poppins(fontSize: screenWidth * 0.040, color: light ? black : white, fontWeight: FontWeight.w600),),
                      SizedBox(width: screenWidth * 0.025,),
                      Icon(Icons.notifications, size: screenWidth * 0.050, color: light ? black : white,)
                    ],
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.005,),
              Container(
                decoration: BoxDecoration(
                    color: currentPrayerTime == 'sunrise' ? (light ? white : gray) : Colors.transparent,
                    border: Border.all(color: currentPrayerTime == 'sunrise' && light ? text : Colors.transparent, width: 0.1)
                ),
                child: ListTile(
                  title: Text("Sunrise", style: GoogleFonts.poppins(fontSize: screenWidth * 0.040, color: light ? black : white, fontWeight: FontWeight.w600),),
                  leading: Image.asset("assets/images/dark_sunrise.png", width: screenWidth * 0.065,),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(DateFormat.jm().format(prayerTimes.sunrise), style: GoogleFonts.poppins(fontSize: screenWidth * 0.040, color: light ? black : white, fontWeight: FontWeight.w600),),
                      SizedBox(width: screenWidth * 0.025,),
                      Icon(Icons.notifications, size: screenWidth * 0.050, color: light ? black : white,)
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 5,),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: currentPrayerTime == 'dhuhr' && light ? text : Colors.transparent, width: 0.1),
                    color: currentPrayerTime == 'dhuhr' ? (light ? white : gray) : Colors.transparent,
                ),
                child: ListTile(
                  title: Text("Duhur", style: GoogleFonts.poppins(fontSize: screenWidth * 0.040, color: light ? black : white, fontWeight: FontWeight.w600),),
                  leading: Image.asset("assets/images/dark_duhr.png", width: screenWidth * 0.065,),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(DateFormat.jm().format(prayerTimes.dhuhr), style: GoogleFonts.poppins(fontSize: screenWidth * 0.040, color: light ? black : white, fontWeight: FontWeight.w600),),
                      SizedBox(width: screenWidth * 0.025,),
                      Icon(Icons.notifications, size: screenWidth * 0.050, color: light ? black : white,)
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 5,),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: currentPrayerTime == 'asr' && light ? text : Colors.transparent, width: 0.1),
                  color: currentPrayerTime == 'asr' ? (light ? white : gray) : Colors.transparent,
                ),
                child: ListTile(
                  title: Text("Asr", style: GoogleFonts.poppins(fontSize: screenWidth * 0.040, color: light ? black : white, fontWeight: FontWeight.w600),),
                  leading: Image.asset("assets/images/dark_asr.png", width: screenWidth * 0.065,),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(DateFormat.jm().format(prayerTimes.asr), style: GoogleFonts.poppins(fontSize: screenWidth * 0.040, color: light ? black : white, fontWeight: FontWeight.w600),),
                      SizedBox(width: screenWidth * 0.025,),
                      Icon(Icons.notifications, size: screenWidth * 0.050, color: light ? black : white,)
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 5,),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: currentPrayerTime == 'maghrib' && light ? text : Colors.transparent, width: 0.1),
                  color: currentPrayerTime == 'maghrib' ? (light ? white : gray) : Colors.transparent,
                ),
                child: ListTile(
                  title: Text("Maghrib", style: GoogleFonts.poppins(fontSize: screenWidth * 0.040, color: light ? black : white, fontWeight: FontWeight.w600),),
                  leading: Image.asset("assets/images/dark_maghrib.png", width: screenWidth * 0.065,),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(DateFormat.jm().format(prayerTimes.maghrib), style: GoogleFonts.poppins(fontSize: screenWidth * 0.040, color: light ? black : white, fontWeight: FontWeight.w600),),
                      SizedBox(width: screenWidth * 0.025,),
                      Icon(Icons.notifications, size: screenWidth * 0.050, color: light ? black : white,)
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 5,),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: currentPrayerTime == 'isha' && light ? text : Colors.transparent, width: 0.1),
                  color: currentPrayerTime == 'isha' ? (light ? white : gray) : Colors.transparent,
                ),
                child: ListTile(
                  title: Text("Isha", style: GoogleFonts.poppins(fontSize: screenWidth * 0.040, color: light ? black : white, fontWeight: FontWeight.w600),),
                  leading: Image.asset("assets/images/dark_isha.png", width: screenWidth * 0.065,),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(DateFormat.jm().format(prayerTimes.isha), style: GoogleFonts.poppins(fontSize: screenWidth * 0.040, color: light ? black : white, fontWeight: FontWeight.w600),),
                      SizedBox(width: screenWidth * 0.025,),
                      Icon(Icons.notifications, size: screenWidth * 0.050, color: light ? black :white,)
                    ],
                  ),
                ),
              )
              // Text(
              //   '${formattedDate}',
              //   style: const TextStyle(fontSize: 18),
              // ),
              // const SizedBox(height: 50,),
              // Text(
              //   'Fajr: ${DateFormat.jm().format(prayerTimes.fajr)}',
              //   style: const TextStyle(fontSize: 18),
              // ),
              // Text(
              //   'Sunrise: ${DateFormat.jm().format(prayerTimes.sunrise)}',
              //   style: const TextStyle(fontSize: 18),
              // ),
              // Text(
              //   'Dhuhr: ${DateFormat.jm().format(prayerTimes.dhuhr)}',
              //   style: const TextStyle(fontSize: 18),
              // ),
              // Text(
              //   'Asr: ${DateFormat.jm().format(prayerTimes.asr)}',
              //   style: const TextStyle(fontSize: 18),
              // ),
              // Text(
              //   'Maghrib: ${DateFormat.jm().format(prayerTimes.maghrib)}',
              //   style: const TextStyle(fontSize: 18),
              // ),
              // Text(
              //   'Isha: ${DateFormat.jm().format(prayerTimes.isha)}',
              //   style: const TextStyle(fontSize: 18),
              // ),
              //  const SizedBox(height: 100,),
              // Text(
              //   'Next Prayer: ${nextPrayerTime == 'none' ? 'Fajr' : nextPrayerTime}',
              //   style: const TextStyle(fontSize: 18),
              // ),
              // Text(
              //   'Middle of Night: ${DateFormat.jm().format(middleOfNight)}',
              //   style: const TextStyle(fontSize: 18),
              // ),
              // Text(
              //   'Last third part Night: ${DateFormat.jm().format(lastThirdOfTheNight)}',
              //   style: const TextStyle(fontSize: 18),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}