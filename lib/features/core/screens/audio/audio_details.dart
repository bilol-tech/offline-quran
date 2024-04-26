import 'dart:async';
import 'dart:convert';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:offline_quran_app/global/no_internet_page.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_connection_checker/simple_connection_checker.dart';

import '../../../../constant/color.dart';
import '../../../../global/check_connect_internet.dart';
import '../../../../global/common/show_custom_popup_menu.dart';
import '../../cubit/internet_cubit.dart';
import '../../cubit/internet_state.dart';
import '../../provider/color_provider.dart';
import '../../provider/text_size_provider.dart';

class AudioSurahDetails extends StatefulWidget {
  final int surahNumber;
  final String surahName;
  final String surahNameTranslated;
  final String revelationType;
  final int numberOfAyahs;
  final int specificAyah;

  const AudioSurahDetails(
    this.surahNumber,
    this.surahName,
    this.surahNameTranslated,
    this.revelationType,
    this.numberOfAyahs, {
    super.key,
    this.specificAyah = 0,
  });

  @override
  _AudioSurahDetailsState createState() => _AudioSurahDetailsState();
}

class _AudioSurahDetailsState extends State<AudioSurahDetails> {
  Map<String, dynamic>? surahDetails;
  Map<String, dynamic>? surahDetailsTranslated;

  int numberOfAyahs = 0;
  List<dynamic> ayahs = [];

  AudioPlayer audioPlayer = AudioPlayer();
  int currentMusic = 0;
  bool isOpened = false;
  Duration maxDuration = const Duration(seconds: 0);
  int playingIndex = -1;
  final ItemScrollController itemScrollController = ItemScrollController();
  int selectedStartNumber = 0;
  int selectedEndNumber = 0;
  late Color? selectedColor;

  late InternetCubit internetCubit;

  @override
  void initState() {
    super.initState();
    fetchSurahDetails();
    fetchSurahDetailsTranslated();
    fetchAyahAudio();
    fetchData();
    internetCubit = context.read<InternetCubit>();
    internetCubit.checkConnectivity();
    internetCubit.trackConnectivityChange();
    audioPlayer.onPlayerComplete.listen((event) {
      if (audioPlayer.releaseMode != ReleaseMode.loop) {
        playNextMusic();
      } else {
        audioPlayer.play(UrlSource(ayahs[currentMusic]['audio']));
        getMaxDuration();
        setState(() {
          playingIndex = currentMusic;
        });
      }
    });
    audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      setState(() {
        if (state == PlayerState.playing) {
          playingIndex = currentMusic;
        } else {
          playingIndex = -1;
        }
      });
    });

    audioPlayer.stop();
  }

  void playAudio(String audioUrl, int index) async {
    await audioPlayer.stop();
    setState(() {
      isOpened = true;
      currentMusic = index;
    });
    await audioPlayer.play(UrlSource(audioUrl));
    getMaxDuration();

    audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      setState(() {
        if (state == PlayerState.playing) {
          playingIndex = currentMusic;
          itemScrollController.scrollTo(
            index: currentMusic,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            alignment: 0,
          );
        }
      });
    });
  }

  void playNextMusic() {
    audioPlayer.stop();
    if (audioPlayer.releaseMode == ReleaseMode.loop) {
      audioPlayer.play(UrlSource(ayahs[currentMusic]['audio']));
      getMaxDuration();
    } else if (currentMusic == ayahs.length - 1) {
      audioPlayer.stop();
    } else {
      audioPlayer.stop();
      currentMusic = (currentMusic + 1) % ayahs.length;
      audioPlayer.play(UrlSource(ayahs[currentMusic]['audio']));
      getMaxDuration();
      setState(() {});
    }
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    internetCubit.dispose();
    super.dispose();
  }

  void getMaxDuration() {
    audioPlayer.getDuration().then((value) {
      maxDuration = value ?? const Duration(seconds: 0);
      setState(() {});
    });
  }

  Future<void> fetchData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String surahDetailsKey = 'surah_${widget.surahNumber}_details';
    final String surahDetailsTranslatedKey =
        'surah_${widget.surahNumber}_details_translated';
    final String ayahAudioKey = 'surah_${widget.surahNumber}_ayah_audio';

    String? surahDetailsJson = prefs.getString(surahDetailsKey);
    String? surahDetailsTranslatedJson =
        prefs.getString(surahDetailsTranslatedKey);
    String? ayahAudioJson = prefs.getString(ayahAudioKey);

    if (surahDetailsJson != null &&
        surahDetailsTranslatedJson != null &&
        ayahAudioJson != null) {
      setState(() {
        surahDetails = json.decode(surahDetailsJson);
        surahDetailsTranslated = json.decode(surahDetailsTranslatedJson);
        ayahs = json.decode(ayahAudioJson);
      });
    } else {
      await fetchSurahDetails();
      await fetchSurahDetailsTranslated();
      await fetchAyahAudio();
    }
  }

  Future<void> fetchSurahDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String surahDetailsKey = 'surah_${widget.surahNumber}_details';

    final response = await http.get(
        Uri.parse('https://api.alquran.cloud/v1/surah/${widget.surahNumber}'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['status'] == 'OK') {
        setState(() {
          surahDetails = data['data'];
        });
        await prefs.setString(surahDetailsKey, json.encode(surahDetails));
      }
    } else {
      // Handle error
      print('Failed to load surah details');
    }
  }

  Future<void> fetchAyahAudio() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String ayahAudioKey = 'surah_${widget.surahNumber}_ayah_audio';

    final response = await http.get(Uri.parse(
        'https://api.alquran.cloud/v1/surah/${widget.surahNumber}/ar.alafasy'));

    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body);
      setState(() {
        ayahs = decodedData['data']['ayahs'];
        numberOfAyahs = decodedData['data']['numberOfAyahs'];
      });
      await prefs.setString(ayahAudioKey, json.encode(ayahs));
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> fetchSurahDetailsTranslated() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String surahDetailsTranslatedKey =
        'surah_${widget.surahNumber}_details_translated';

    final response = await http.get(Uri.parse(
        'https://api.alquran.cloud/v1/surah/${widget.surahNumber}/en.asad'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['status'] == 'OK') {
        setState(() {
          surahDetailsTranslated = data['data'];
        });
        await prefs.setString(
            surahDetailsTranslatedKey, json.encode(surahDetailsTranslated));
      }
    } else {
      // Handle error
      print('Failed to load surah details');
    }
  }

  Widget _buildBottomSheet() {
    return Visibility(
      visible: isOpened,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.150,
        decoration: BoxDecoration(
          color: selectedColor,
          border: Border(
            top: BorderSide(
              color: selectedColor == mode_3
                  ? text
                  : Colors.grey
                      .withOpacity(0.4), // Choose your border color here
              width: 1.0, // Choose the width of the border
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          padding: const EdgeInsets.all(20),
          color: selectedColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StreamBuilder(
                stream: audioPlayer.onPositionChanged,
                builder: (context, snapshot) {
                  return ProgressBar(
                    progress: snapshot.data ?? const Duration(seconds: 0),
                    total: maxDuration,
                    onSeek: (duration) {
                      audioPlayer.seek(duration);
                      setState(() {});
                    },
                    timeLabelTextStyle: TextStyle(
                        color: selectedColor == mode_3
                            ? Colors.white
                            : Colors.black),
                    timeLabelPadding: 8,
                    barHeight: 3,
                    thumbRadius: 4,
                    thumbGlowRadius: 10,
                    bufferedBarColor: Colors.red,
                  );
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (audioPlayer.releaseMode == ReleaseMode.loop) {
                          audioPlayer.setReleaseMode(ReleaseMode.release);
                        } else {
                          audioPlayer.setReleaseMode(ReleaseMode.loop);
                        }
                      });
                    },
                    icon: Icon(
                      Icons.loop,
                      size: 20,
                      color: audioPlayer.releaseMode == ReleaseMode.loop
                          ? primary
                          : selectedColor == mode_3
                              ? Colors.white
                              : Colors.black,
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: gray,
                          builder: (BuildContext context) {
                            return Container(
                              height: MediaQuery.of(context).size.height * 0.26,
                              color: gray,
                              child: Column(
                                children: [
                                  const Padding(
                                    padding:
                                        EdgeInsets.only(left: 12.0, top: 12),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.settings,
                                          size: 20,
                                          color: Colors.white,
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          "Audio settings",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Divider(
                                    color: Colors.grey.withOpacity(0.6),
                                    thickness: 0.3,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12.0, top: 12),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Start",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.38,
                                              height: 36,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(6)),
                                                color: modalSheetColor,
                                              ),
                                              child: StatefulBuilder(
                                                builder: (BuildContext context,
                                                    void Function(
                                                            void Function())
                                                        setState) {
                                                  return DropdownButton<int>(
                                                    value: selectedStartNumber,
                                                    onChanged: (int? newValue) {
                                                      setState(() {
                                                        selectedStartNumber =
                                                            newValue ?? 0;
                                                        if (selectedEndNumber <
                                                            selectedStartNumber) {
                                                          selectedEndNumber =
                                                              selectedStartNumber;
                                                        }
                                                      });
                                                      setState(() {});
                                                    },
                                                    underline: Container(),
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    dropdownColor: background,
                                                    icon: const Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 80.0),
                                                      child: Icon(
                                                          Icons.arrow_drop_down,
                                                          color: Colors.white),
                                                    ),
                                                    items: List.generate(
                                                      numberOfAyahs,
                                                      (index) =>
                                                          DropdownMenuItem<int>(
                                                        value: index,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 10.0),
                                                          child: Text(
                                                              '${index + 1}',
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      14)),
                                                        ),
                                                      ),
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "End",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.38,
                                              height: 36,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(6)),
                                                color: modalSheetColor,
                                              ),
                                              child: StatefulBuilder(
                                                builder: (BuildContext context,
                                                    void Function(
                                                            void Function())
                                                        setState) {
                                                  return DropdownButton<int>(
                                                    value: selectedEndNumber,
                                                    onChanged: (int? newValue) {
                                                      setState(() {
                                                        selectedEndNumber =
                                                            newValue ?? 0;
                                                        if (selectedEndNumber <
                                                            selectedStartNumber) {
                                                          selectedEndNumber =
                                                              selectedStartNumber;
                                                        }
                                                      });
                                                    },
                                                    underline: Container(),
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    dropdownColor: background,
                                                    icon: const Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 80.0),
                                                      child: Icon(
                                                          Icons.arrow_drop_down,
                                                          color: Colors.white),
                                                    ),
                                                    items: List.generate(
                                                      numberOfAyahs -
                                                          selectedStartNumber,
                                                      (index) =>
                                                          DropdownMenuItem<int>(
                                                        value:
                                                            selectedStartNumber +
                                                                index,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 10.0),
                                                          child: Text(
                                                              '${selectedStartNumber + (index + 1)}',
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      14)),
                                                        ),
                                                      ),
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 21.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              selectedStartNumber = 0;
                                              selectedEndNumber = 0;
                                            });
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                            width: 90,
                                            height: 28,
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(6)),
                                            ),
                                            child: Center(
                                                child: Text(
                                              "cancel".toUpperCase(),
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12),
                                            )),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            itemScrollController.scrollTo(
                                              index: selectedStartNumber,
                                              duration: const Duration(
                                                  milliseconds: 300),
                                              curve: Curves.easeInOut,
                                              alignment:
                                                  0, // Scroll to the start of the viewport
                                            );
                                            setState(() {
                                              if (selectedStartNumber != 0) {
                                                playAudio(
                                                    ayahs[selectedStartNumber]
                                                        ['audio'],
                                                    selectedStartNumber);
                                              }
                                              selectedStartNumber = 0;
                                              selectedEndNumber = 0;
                                            });
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                            width: 90,
                                            height: 28,
                                            decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(6)),
                                                color: Colors.green),
                                            child: Center(
                                                child: Text(
                                              "save".toUpperCase(),
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12),
                                            )),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        );
                      },
                      icon: Icon(
                        Icons.settings,
                        size: 20,
                        color: selectedColor == mode_3
                            ? Colors.white
                            : Colors.black,
                      )),
                  IconButton(
                    onPressed: () {
                      audioPlayer.stop();
                      audioPlayer.play(UrlSource(
                        ayahs[--currentMusic % ayahs.length]['audio'],
                      ));
                      getMaxDuration();
                    },
                    icon: Icon(
                      Icons.skip_previous,
                      size: 20,
                      color:
                          selectedColor == mode_3 ? Colors.white : Colors.black,
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      if (audioPlayer.state == PlayerState.playing) {
                        await audioPlayer.pause();
                      } else {
                        await audioPlayer.play(UrlSource(
                          ayahs[currentMusic % ayahs.length]['audio'],
                        ));
                      }
                      getMaxDuration();
                    },
                    icon: StreamBuilder<PlayerState>(
                      stream: audioPlayer.onPlayerStateChanged,
                      builder: (context, snapshot) {
                        final playerState = snapshot.data;
                        if (playerState == PlayerState.playing) {
                          return Icon(
                            Icons.pause,
                            size: 20,
                            color: primary,
                          );
                        } else {
                          return Icon(
                            Icons.play_arrow,
                            size: 20,
                            color: selectedColor == mode_3
                                ? Colors.white
                                : Colors.black,
                          );
                        }
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      audioPlayer.stop();
                      audioPlayer.play(UrlSource(
                        ayahs[++currentMusic % ayahs.length]['audio'],
                      ));
                      getMaxDuration();
                      setState(() {});
                    },
                    icon: Icon(
                      Icons.skip_next,
                      size: 20,
                      color:
                          selectedColor == mode_3 ? Colors.white : Colors.black,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      audioPlayer.stop();
                      setState(() {
                        isOpened = false;
                      });
                    },
                    icon: Icon(
                      Icons.close_rounded,
                      size: 20,
                      color:
                          selectedColor == mode_3 ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    selectedColor = Provider.of<ColorModel>(context).selectedColor;
    final latinTextSizeProvider = Provider.of<LatinTextSizeProvider>(context);
    final arabicTextSizeProvider = Provider.of<ArabicTextSizeProvider>(context);
    return BlocBuilder<InternetCubit, InternetStatus>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: selectedColor,
          appBar: AppBar(
            backgroundColor: selectedColor,
            automaticallyImplyLeading: false,
            elevation: 10,
            title: Row(children: [
              IconButton(
                  onPressed: (() => Navigator.of(context).pop()),
                  icon: SvgPicture.asset(
                    'assets/svgs/back-icon.svg',
                    color: selectedColor == mode_3
                        ? white.withOpacity(0.8)
                        : Colors.black54,
                  )),
              const SizedBox(
                width: 24,
              ),
              Text(
                widget.surahName,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: selectedColor == mode_3
                      ? white.withOpacity(0.8)
                      : Colors.black54,
                ),
              ),
            ]),
            actions: const [
              CustomPopupMenu(
                pageName: 'AudioDetails',
              )
            ],
          ),
          body: state.status == ConnectivityStatus.disconnected
              ? const NoInternetPage()
              : surahDetails == null || ayahs == null
                  ? Center(
                      child: Lottie.asset("assets/animation/loading.json",
                          width: 120))
                  : Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 24, right: 24, bottom: 15),
                          child: ScrollablePositionedList.separated(
                            itemScrollController: itemScrollController,
                            itemBuilder: (context, index) {
                              if (surahDetails == null ||
                                  surahDetails!['ayahs'] == null ||
                                  index >= surahDetails!['ayahs'].length) {
                                return const SizedBox.shrink();
                              }
                              final ayah = surahDetails?['ayahs'][index];
                              final ayahTranslated =
                                  surahDetailsTranslated?['ayahs'][index];
                              final ayahAudio = ayahs[index];
                              return Padding(
                                padding:
                                    const EdgeInsets.only(top: 10, bottom: 14),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        "${ayah['text']}",
                                        style: GoogleFonts.amiri(
                                          height: 3,
                                          letterSpacing: 0.2,
                                          fontWeight: FontWeight.bold,
                                          color: selectedColor == mode_3
                                              ? white
                                              : Colors.black,
                                          fontSize: arabicTextSizeProvider
                                              .currentArabicTextSize,
                                        ),
                                        // textDirection: TextDirection.rtl,
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                    // Text(
                                    //   "${ayahTranslated?['numberInSurah'].toString()}. ${ayahTranslated?['text']}",
                                    //   style: GoogleFonts.poppins(
                                    //       color: text, fontSize: 16),
                                    // ),
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              isOpened = true;
                                            });
                                            playAudio(
                                                ayahAudio['audio'], index);
                                          },
                                          child: Container(
                                            width: 90,
                                            decoration: BoxDecoration(
                                              color: index == playingIndex
                                                  ? primary
                                                  : selectedColor,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(20)),
                                              border: Border.all(
                                                color: index == playingIndex
                                                    ? primary
                                                    : selectedColor == mode_3
                                                        ? white
                                                        : Colors.black54,
                                              ),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  const SizedBox(
                                                    width: 8,
                                                  ),
                                                  Icon(
                                                    index == playingIndex
                                                        ? Icons.pause
                                                        : Icons.play_arrow,
                                                    color: index == playingIndex
                                                        ? white
                                                        : selectedColor ==
                                                                mode_3
                                                            ? white
                                                            : Colors.black54,
                                                    size: 18,
                                                  ),
                                                  const SizedBox(
                                                    width: 6,
                                                  ),
                                                  Text(
                                                    "Listen",
                                                    style: TextStyle(
                                                      color: index ==
                                                              playingIndex
                                                          ? white
                                                          : selectedColor ==
                                                                  mode_3
                                                              ? white
                                                              : Colors.black54,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          // Icon(
                                          //   Icons.audiotrack,
                                          //   color: index == playingIndex
                                          //       ? Colors.green
                                          //       : Colors.red,
                                          // ),
                                        ),
                                        const Spacer(),
                                        Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                color: selectedColor == mode_3
                                                    ? white
                                                    : Colors.black54,
                                              ),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(3))),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 4, vertical: 1),
                                            child: Text(
                                              "${ayah['numberInSurah']}:${surahDetails!['numberOfAyahs']}",
                                              style: TextStyle(
                                                color: selectedColor == mode_3
                                                    ? white
                                                    : Colors.black,
                                                fontSize: latinTextSizeProvider
                                                        .currentLatinTextSize /
                                                    1.5,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                            itemCount: ayahs.length,
                            separatorBuilder: (context, index) => Divider(
                                color:
                                    const Color(0xFF7B80AD).withOpacity(.35)),
                          ),
                        ),
                      ],
                    ),
          floatingActionButton: state.status == ConnectivityStatus.disconnected
              ? const SizedBox()
              : Transform.scale(
                  scale: 0.8,
                  child: FloatingActionButton(
                    onPressed: () {
                      itemScrollController.scrollTo(
                        index: 0,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        alignment: 0, // Scroll to the start of the viewport
                      );
                    },
                    backgroundColor: primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    child: Center(
                        child: Icon(
                      Icons.swipe_up,
                      color: white,
                    )),
                  ),
                ),
          bottomNavigationBar: _buildBottomSheet(),
        );
      },
    );
  }
}
