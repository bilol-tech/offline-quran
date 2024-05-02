import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../constant/color.dart';
import '../tafsir/surah/surah_details.dart';
import 'models/search_result.dart';

class CustomSearch extends SearchDelegate {
  final BuildContext context;

  CustomSearch(this.context);

  @override
  ThemeData appBarTheme(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final ThemeData theme = Theme.of(context);

    final themeData = Theme.of(context);
    final light = themeData.brightness == Brightness.light;
    print(themeData.brightness == Brightness.light ? 'Light Mode' : 'Dark Mode');

    return theme.copyWith(
      textTheme: TextTheme(
        bodyText1: TextStyle(color: light ? black : white, fontSize: screenWidth * 0.040),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: light ? white : gray,
        iconTheme: theme.primaryIconTheme.copyWith(color: light ? black : white),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: GoogleFonts.poppins(color: light ? black : white, fontSize: screenWidth * 0.034),
        labelStyle: GoogleFonts.poppins(color: light ? black : white, fontSize: screenWidth * 0.034),
        border: InputBorder.none,
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear, size: screenWidth * 0.050,),
      )
    ];
  }

  GlobalKey _popupMenuKey = GlobalKey();

  @override
  Widget? buildLeading(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return IconButton(
      onPressed: () {
        _popupMenuKey.currentState?.mounted;
        close(context, null);
      },
      icon: Icon(Icons.arrow_back, size: screenWidth * 0.050),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults(query);
  }

  Widget _buildSearchResults(String searchTerm) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final themeData = Theme.of(context);
    final light = themeData.brightness == Brightness.light;
    print(themeData.brightness == Brightness.light ? 'Light Mode' : 'Dark Mode');
    return Container(
      color: light ? lightBackgroundYellow : background,
      child: FutureBuilder<List<SearchResult>>(
        future: searchWord(searchTerm),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Lottie.asset(
                "assets/animation/loading.json",
                width: screenWidth * 0.250,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'No result found',
                style: GoogleFonts.poppins(fontSize: screenWidth * 0.036, color: light ? black : white),
              ),
            );
          } else if (snapshot.hasData) {
            final searchResults = snapshot.data!;
            return ListView.separated(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                final result = searchResults[index];
                return Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: screenHeight * 0.015, vertical: screenHeight * 0.010),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder: (_, __, ___) => SurahDetails(
                            result.surah.number,
                            result.surah.englishName,
                            result.surah.englishNameTranslation,
                            result.surah.revelationType,
                            result.surah.number,
                            specificAyah: result.numberInSurah - 1,
                          ),
                          transitionsBuilder: (_, animation, __, child) {
                            return SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(1.0, 0.0),
                                end: Offset.zero,
                              ).animate(animation),
                              child: child,
                            );
                          },
                        ),
                      );
                      print(result.numberInSurah);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${result.surah.englishName}, ${result.numberInSurah}',
                          style: GoogleFonts.poppins(color: light ? black : white, fontSize: screenWidth * 0.034),
                        ),
                        RichText(
                          text: highlightSearchText(result.text, searchTerm),
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) =>
                  Divider(color: const Color(0xFF7B80AD).withOpacity(.35)),
            );
          } else {
            return Center(
              child: Text('No results found',
                  style: GoogleFonts.poppins(fontSize: screenWidth * 0.036, color: light ? black : white)),
            );
          }
        },
      ),
    );
  }

  Future<List<SearchResult>> searchWord(String word) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString('search_results_$word');
    if (cachedData != null) {
      final List<dynamic> cachedList = jsonDecode(cachedData);
      return cachedList.map((json) => SearchResult.fromJson(json)).toList();
    }

    final response = await http.get(
      Uri.parse('https://api.alquran.cloud/v1/search/$word/all/en'),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final matches = jsonResponse['data']['matches'] as List<dynamic>;
      final List<SearchResult> results =
      matches.map((match) => SearchResult.fromJson(match)).toList();
      prefs.setString('search_results_$word', jsonEncode(matches));
      return results;
    } else {
      throw Exception('Failed to load search results');
    }
  }

  InlineSpan highlightSearchText(String text, String searchTerm) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final themeData = Theme.of(context);
    final light = themeData.brightness == Brightness.light;
    print(themeData.brightness == Brightness.light ? 'Light Mode' : 'Dark Mode');
    if (searchTerm.isEmpty) {
      return TextSpan(
        text: text,
        style: TextStyle(fontSize: screenWidth * 0.028, color: light ? black : const Color(0xffFFFFFF)),
      );
    }

    final RegExp regex = RegExp(searchTerm, caseSensitive: false);
    final List<InlineSpan> spans = [];
    int previousEndIndex = 0;

    regex.allMatches(text).forEach((match) {
      final themeData = Theme.of(context);
      final light = themeData.brightness == Brightness.light;
      double screenWidth = MediaQuery.of(context).size.width;
      double screenHeight = MediaQuery.of(context).size.height;
      final int startIndex = match.start;
      final int endIndex = match.end;

      if (startIndex > previousEndIndex) {
        spans.add(TextSpan(
          text: text.substring(previousEndIndex, startIndex),
          style: TextStyle(fontSize: screenWidth * 0.030, color: light ? black : const Color(0xffFFFFFF)),
        ));
      }

      spans.add(TextSpan(
        text: text.substring(startIndex, endIndex),
        style: GoogleFonts.poppins(fontSize: screenWidth * 0.030, color: primary),
      ));

      previousEndIndex = endIndex;
    });

    if (previousEndIndex < text.length) {
      final themeData = Theme.of(context);
      final light = themeData.brightness == Brightness.light;
      double screenWidth = MediaQuery.of(context).size.width;
      double screenHeight = MediaQuery.of(context).size.height;

      spans.add(TextSpan(
        text: text.substring(previousEndIndex),
        style: TextStyle(fontSize: screenWidth * 0.030, color: light ? black : const Color(0xffFFFFFF)),
      ));
    }

    return WidgetSpan(
      child: RichText(text: TextSpan(children: spans)),
    );
  }
}
