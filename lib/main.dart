import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offline_quran_app/features/core/cubit/internet_cubit.dart';
import 'package:offline_quran_app/features/core/provider/theme_change_provider.dart';
import 'package:offline_quran_app/features/core/screens/main_screen.dart';
import 'package:offline_quran_app/features/core/screens/profile/profile.dart';
import 'package:offline_quran_app/global/no_internet_page.dart';
import 'package:offline_quran_app/theme/theme.dart';
import 'package:provider/provider.dart';

import 'features/core/cubit/theme_cubit.dart';
import 'features/core/provider/color_provider.dart';
import 'features/core/provider/last_read_index_provider.dart';
import 'features/core/provider/saved_ayah_provider.dart';
import 'features/core/provider/text_size_provider.dart';
import 'global/common/show_custom_error.dart';
import 'global/unuseful/SurahAyahDropdown.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'features/core/screens/prayers/prayer_time.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  tz.initializeTimeZones();

  ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
    bool isDebug = false;
    assert(() {
      isDebug = false;
      return true;
    }());
    if (isDebug) {
      return ErrorWidget(errorDetails.exception);
    }
    return const ErrorScreen();
  };

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LatinTextSizeProvider()),
        ChangeNotifierProvider(create: (_) => ArabicTextSizeProvider()),
        ChangeNotifierProvider(create: (_) => SavedAyahProvider()),
        ChangeNotifierProvider(create: (_) => LastReadIndexProvider()),
        ChangeNotifierProvider(create: (_) => ColorModel()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<ThemeCubit>(create: (_) => ThemeCubit()),
          BlocProvider<InternetCubit>(create: (_) => InternetCubit()),
        ],
        child:
            BlocBuilder<ThemeCubit, ThemeMode>(builder: (context, themeMode) {
          return MaterialApp(
              theme: ThemeData.light(),
              darkTheme: ThemeData.dark(),
              themeMode: themeMode,
              debugShowCheckedModeBanner: false,
              home: const MainScreen(
                selectedIndex: 0,
              ));
        }));
  }
}
