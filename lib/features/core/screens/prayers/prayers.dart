import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../constant/color.dart';
import '../../../../global/no_internet_page.dart';
import '../../cubit/internet_cubit.dart';
import '../../cubit/internet_state.dart';
import '../search/search_bar.dart';

class Prayers extends StatefulWidget {
  const Prayers({super.key});

  @override
  State<Prayers> createState() => _PrayersState();
}

class _PrayersState extends State<Prayers> {
  Map<String, dynamic> prayerTimes = {};
  Map<String, dynamic> dateOfPrayer = {};
  Map<String, dynamic> metaData = {};
  String currentPrayer = '';
  Timer? _timer;
  Duration? _timeLeft;

  String todayDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
  // String todayDate = '16-05-2024';

  Future<void> fetchPrayerTimes() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? cachedData = prefs.getString('prayer_times_$todayDate');

    if (cachedData != null) {
      final decodedResponse = json.decode(cachedData);
      setState(() {
        prayerTimes = decodedResponse['data']['timings'];
        dateOfPrayer = decodedResponse['data']['date'];
        metaData = decodedResponse['data']['meta'];
        print(prayerTimes);
        print(dateOfPrayer);
        print(metaData);
      });
    } else {
      await updatePrayerTimesFromAPI(prefs);
    }

    // Check if the current date has changed and update if necessary
    String currentDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
    if (currentDate != todayDate) {
      todayDate = currentDate;
      await updatePrayerTimesFromAPI(prefs);
    }
  }

  Future<void> updatePrayerTimesFromAPI(SharedPreferences prefs) async {
    final response = await http.get(Uri.parse(
        'https://api.aladhan.com/v1/timingsByAddress/$todayDate?address=Tashkent'));
    if (response.statusCode == 200) {
      final decodedResponse = json.decode(response.body);
      setState(() {
        prayerTimes = decodedResponse['data']['timings'];
        dateOfPrayer = decodedResponse['data']['date'];
        metaData = decodedResponse['data']['meta'];
        print(prayerTimes);
        print(dateOfPrayer);
        print(metaData);
      });

      prefs.setString('prayer_times_$todayDate', response.body);
    } else {
      throw Exception('Failed to load prayer times');
    }
  }

  String getCurrentPrayer() {
    DateTime now = DateTime.now();
    // DateTime newTime = now.add(const Duration(hours: 16, minutes: 0));
    DateFormat formatter = DateFormat('HH:mm');
    String currentTime = formatter.format(now);

    if (currentTime.compareTo(prayerTimes['Fajr']) < 0 ||
        currentTime.compareTo(prayerTimes['Dhuhr']) < 0) {
      currentPrayer = 'Fajr';
    } else if (currentTime.compareTo(prayerTimes['Dhuhr']) < 0 ||
        currentTime.compareTo(prayerTimes['Asr']) < 0) {
      currentPrayer = 'Dhuhr';
    } else if (currentTime.compareTo(prayerTimes['Asr']) < 0 ||
        currentTime.compareTo(prayerTimes['Maghrib']) < 0) {
      currentPrayer = 'Asr';
    } else if (currentTime.compareTo(prayerTimes['Maghrib']) < 0 ||
        currentTime.compareTo(prayerTimes['Isha']) < 0) {
      currentPrayer = 'Maghrib';
    } else {
      currentPrayer = 'Isha'; // Last prayer of the day
    }

    return currentPrayer;
  }

  String getNextPrayer() {
    switch (currentPrayer) {
      case 'Fajr':
        return 'Dhuhr';
      case 'Dhuhr':
        return 'Asr';
      case 'Asr':
        return 'Maghrib';
      case 'Maghrib':
        return 'Isha';
      case 'Isha':
        return 'Fajr';
      default:
        return '';
    }
  }

   addJamaatTime() {
    switch (getNextPrayer()) {
      case 'Fajr':
        return 30;
      case 'Dhuhr':
        return 30;
      case 'Asr':
        return 10;
      case 'Maghrib':
        return 5;
      case 'Isha':
        return 10;
      default:
        return '';
    }
  }

  // String _latitude = '';
  // String _longitude = '';
  // String _altitude = '';
  // String _speed = '';
  // String _address = '';

  // Future<void> _updatePosition() async{
  //   Position pos = await _determinePosition();
  //   List pm = await placemarkFromCoordinates(pos.latitude, pos.longitude);
  //   setState(() {
  //     _latitude = pos.latitude.toString();
  //     _longitude = pos.longitude.toString();
  //     _altitude = pos.altitude.toString();
  //     _speed = pos.speed.toString();
  //
  //     _address = pm[0];
  //   });
  // }

  // Future<Position> _determinePosition() async{
  //   bool serviceEnabled;
  //   LocationPermission permission;
  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled){
  //     return Future.error("Location permission are disabled");
  //   }
  //   permission = await Geolocator.checkPermission();
  //   if(permission == LocationPermission.denied){
  //     permission = await Geolocator.requestPermission();
  //     if(permission == LocationPermission.denied){
  //       return Future.error("Location permission are denied");
  //     }
  //   }
  //   if(permission == LocationPermission.deniedForever){
  //     return Future.error("Location permissions are permanently denied, we cannot request permission.");
  //   }
  //   return await Geolocator.getCurrentPosition();
  // }

  late InternetCubit internetCubit;

  @override
  void initState() {
    super.initState();
    fetchPrayerTimes();
    _updateTimer();
    internetCubit = context.read<InternetCubit>();
    internetCubit.checkConnectivity();
    internetCubit.trackConnectivityChange();
    // _determinePosition();
  }

  void _updateTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      DateTime timerNow = DateTime.now();
      String currentPrayer = getCurrentPrayer();
      DateFormat formatter = DateFormat('HH:mm');
      DateTime endTime;

      switch (currentPrayer) {
        case 'Fajr':
          endTime = formatter.parse(prayerTimes['Dhuhr']);
          break;
        case 'Dhuhr':
          endTime = formatter.parse(prayerTimes['Asr']);
          break;
        case 'Asr':
          endTime = formatter.parse(prayerTimes['Maghrib']);
          break;
        case 'Maghrib':
          endTime = formatter.parse(prayerTimes['Isha']);
          break;
        case 'Isha':
        // If Isha is current prayer, consider until the next Fajr
          endTime = formatter.parse(prayerTimes['Fajr']);
          endTime = endTime.add(const Duration(days: 1)); // Next day's Fajr
          break;
        default:
          endTime = DateTime.now();
          break;
      }

      setState(() {
        _timeLeft = endTime.difference(timerNow);
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    internetCubit.dispose();
    super.dispose();
  }

  String addTenMinutesToTime(String time) {
    DateTime parsedTenMinutes = DateFormat('HH:mm').parse(time);
    DateTime newTenTime = parsedTenMinutes.add(Duration(minutes: addJamaatTime()));
    return DateFormat('HH:mm').format(newTenTime);
  }


  @override
  Widget build(BuildContext context) {
    print(todayDate);
    return BlocBuilder<InternetCubit, InternetStatus>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: background,
          appBar: AppBar(
            backgroundColor: gray,
            automaticallyImplyLeading: false,
            elevation: 0,
            centerTitle: false,
            title: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(
                'Prayers',
                style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: white.withOpacity(0.8)),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: IconButton(
                  icon: SvgPicture.asset('assets/svgs/search-icon.svg'),
                  onPressed: () {
                    showSearch(
                      context: context,
                      delegate: CustomSearch(context),
                    );
                  },
                ),
              ),
            ],
          ),
          body: state.status == ConnectivityStatus.connected
              ? prayerTimes.isNotEmpty && _timeLeft != null
              ? SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 15,
                ),
                Center(
                    child: Text(
                      "${dateOfPrayer['gregorian']['weekday']['en']}, ${dateOfPrayer['readable']}",
                      style: GoogleFonts.poppins(
                          fontSize: 18,
                          color: white,
                          fontWeight: FontWeight.w700),
                    )),
                Center(
                    child: Text(
                      "${dateOfPrayer['hijri']['day']} ${dateOfPrayer['hijri']['month']['en']}, ${dateOfPrayer['hijri']['year']}",
                      style: GoogleFonts.poppins(fontSize: 14, color: text),
                    )),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.45,
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(17)),
                        gradient: LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          colors: [Color(0xffFCE5D4), Color(0xffF6D0B5)],
                        ),
                        image: DecorationImage(
                          image: AssetImage('assets/images/background4.jpeg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Now time is',
                            style:
                            TextStyle(color: Colors.black, fontSize: 14),
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          Text(
                            getCurrentPrayer(),
                            style: TextStyle(
                              color: primary,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          Text(
                            prayerTimes[getCurrentPrayer()],
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w800,
                                fontSize: 19),
                          ),
                          Text(
                            'Time left - ${(_timeLeft!.inHours % 24).toString().padLeft(2, '0')}:${(_timeLeft!.inMinutes % 60).toString().padLeft(2, '0')}',
                            // :${(_timeLeft!.inSeconds % 60).toString().padLeft(2, '0')}
                            style:
                            const TextStyle(color: Colors.black, fontSize: 14),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.45,
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(17)),
                        gradient: LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          colors: [Color(0xffFCE5D4), Color(0xffF6D0B5)],
                        ),
                        image: DecorationImage(
                          image: AssetImage('assets/images/background4.jpeg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Next prayer is',
                            style:
                            TextStyle(color: Colors.black, fontSize: 14),
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          Text(
                            getNextPrayer(),
                            style: TextStyle(
                              color: primary,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          Text(
                            '${(_timeLeft!.inHours % 24).toString().padLeft(2, '0')}:${(_timeLeft!.inMinutes % 60).toString().padLeft(2, '0')}',
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w800,
                                fontSize: 19),
                          ),
                          Text(
                            'Azan - ${prayerTimes[getNextPrayer()]}',
                            style:
                            const TextStyle(color: Colors.black, fontSize: 14),
                          ),
                          Text("Jama'at - ${addTenMinutesToTime(prayerTimes[getNextPrayer()])}",
                            style:
                            const TextStyle(color: Colors.black, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        color: Color(0xffD7D0C2)
                      // image: DecorationImage(
                      //   image: AssetImage('assets/images/background1.jpeg'),
                      //   fit: BoxFit.cover,
                      // ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_rounded,
                              color: Colors.black87,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              metaData['timezone'],
                              style: GoogleFonts.poppins(
                                  color: Colors.black87,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Image.asset(
                              "assets/images/fajr.png",
                              width: 26,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Fajr',
                              style: TextStyle(
                                  color: currentPrayer == 'Fajr' ? primary: Colors.black,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600),
                            ),
                            const Spacer(),
                            Text(
                              prayerTimes['Fajr'],
                              style: TextStyle(
                                  color: currentPrayer == 'Fajr' ? primary: Colors.black,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.notifications_off_rounded,
                              size: 22,
                              color: primary,
                            )
                          ],
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 3.0),
                          child: Divider(
                            color: primary,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Image.asset(
                              "assets/images/duhur.png",
                              width: 26,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Dhuhr',
                              style: TextStyle(
                                  color: currentPrayer == 'Dhuhr' ? primary: Colors.black,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600),
                            ),
                            const Spacer(),
                            Text(
                              prayerTimes['Dhuhr'],
                              style: TextStyle(
                                  color: currentPrayer == 'Dhuhr' ? primary: Colors.black,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.notifications_rounded,
                              size: 22,
                              color: primary,
                            )
                          ],
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 3.0),
                          child: Divider(
                            color: primary,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Image.asset(
                              "assets/images/asr.png",
                              width: 26,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Asr',
                              style: TextStyle(
                                  color: currentPrayer == 'Asr' ? primary: Colors.black,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600),
                            ),
                            const Spacer(),
                            Text(
                              prayerTimes['Asr'],
                              style: TextStyle(
                                  color: currentPrayer == 'Asr' ? primary: Colors.black,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.notifications_rounded,
                              size: 22,
                              color: primary,
                            )
                          ],
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 3.0),
                          child: Divider(
                            color: primary,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Image.asset(
                              "assets/images/maghrib.png",
                              width: 26,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Maghrib',
                              style: TextStyle(
                                  color: currentPrayer == 'Maghrib' ? primary: Colors.black,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600),
                            ),
                            const Spacer(),
                            Text(
                              prayerTimes['Maghrib'],
                              style: TextStyle(
                                  color: currentPrayer == 'Maghrib' ? primary: Colors.black,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.notifications_rounded,
                              size: 22,
                              color: primary,
                            )
                          ],
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 3.0),
                          child: Divider(
                            color: primary,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Image.asset(
                              "assets/images/isha.png",
                              width: 26,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Isha',
                              style: TextStyle(
                                  color: currentPrayer == 'Isha' ? primary: Colors.black,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600),
                            ),
                            const Spacer(),
                            Text(
                              prayerTimes['Isha'],
                              style: TextStyle(
                                  color: currentPrayer == 'Isha' ? primary: Colors.black,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.notifications_rounded,
                              size: 22,
                              color: primary,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      image: DecorationImage(
                        image: AssetImage('assets/images/background1.jpeg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            const Text(
                              'Sunrise',
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              prayerTimes['Sunrise'],
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                          child: VerticalDivider(
                            color: primary,
                            thickness: 3,
                          ),
                        ),
                        Column(
                          children: [
                            const Text(
                              'Sunset',
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              prayerTimes['Sunset'],
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                          child: VerticalDivider(
                            color: primary,
                            thickness: 3,
                          ),
                        ),
                        Column(
                          children: [
                            const Text(
                              'Midnight',
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              prayerTimes['Midnight'],
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
              : Center(
              child: Lottie.asset("assets/animation/loading.json", width: 120))
              :
          const NoInternetPage(),
        );
      },
    );
  }
}
