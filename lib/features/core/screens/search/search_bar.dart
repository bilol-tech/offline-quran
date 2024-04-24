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
    final ThemeData theme = Theme.of(context);

    return theme.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: gray,
        iconTheme: theme.primaryIconTheme.copyWith(color: white),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: GoogleFonts.poppins(color: white, fontSize: 17),
        labelStyle: GoogleFonts.poppins(color: white, fontSize: 17),
        border: InputBorder.none,
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      )
    ];
  }

  GlobalKey _popupMenuKey = GlobalKey();

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        _popupMenuKey.currentState?.mounted;
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
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
    return Container(
      color: background,
      child: FutureBuilder<List<SearchResult>>(
        future: searchWord(searchTerm),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Lottie.asset(
                "assets/animation/loading.json",
                width: 120,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'No result found',
                style: GoogleFonts.poppins(fontSize: 18, color: white),
              ),
            );
          } else if (snapshot.hasData) {
            final searchResults = snapshot.data!;
            return ListView.separated(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                final result = searchResults[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 10.0),
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
                          style: GoogleFonts.poppins(color: white, fontSize: 17),
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
                  style: GoogleFonts.poppins(fontSize: 18, color: white)),
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
    if (searchTerm.isEmpty) {
      return TextSpan(
        text: text,
        style: const TextStyle(fontSize: 14, color: Color(0xffFFFFFF)),
      );
    }

    final RegExp regex = RegExp(searchTerm, caseSensitive: false);
    final List<InlineSpan> spans = [];
    int previousEndIndex = 0;

    regex.allMatches(text).forEach((match) {
      final int startIndex = match.start;
      final int endIndex = match.end;

      if (startIndex > previousEndIndex) {
        spans.add(TextSpan(
          text: text.substring(previousEndIndex, startIndex),
          style: const TextStyle(fontSize: 15, color: Color(0xffFFFFFF)),
        ));
      }

      spans.add(TextSpan(
        text: text.substring(startIndex, endIndex),
        style: GoogleFonts.poppins(fontSize: 15, color: primary),
      ));

      previousEndIndex = endIndex;
    });

    if (previousEndIndex < text.length) {
      spans.add(TextSpan(
        text: text.substring(previousEndIndex),
        style: const TextStyle(fontSize: 15, color: Color(0xffFFFFFF)),
      ));
    }

    return WidgetSpan(
      child: RichText(text: TextSpan(children: spans)),
    );
  }
}
