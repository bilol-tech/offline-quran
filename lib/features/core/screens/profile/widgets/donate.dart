import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:offline_quran_app/features/core/cubit/internet_cubit.dart';
import 'package:offline_quran_app/global/no_internet_page.dart';
import 'package:provider/provider.dart';
import 'package:simple_connection_checker/simple_connection_checker.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../../constant/color.dart';
import '../../../../../global/check_connect_internet.dart';
import '../../../cubit/internet_state.dart';
import '../../search/search_bar.dart';

class DonatePage extends StatefulWidget {
  const DonatePage({Key? key}) : super(key: key);

  @override
  State<DonatePage> createState() => _DonatePageState();
}

class _DonatePageState extends State<DonatePage> {
  final String url = 'https://www.tirikchilik.uz/bilol_tech';
  bool isLoading = true;

  late InternetCubit internetCubit;

  @override
  void initState() {
    internetCubit = context.read<InternetCubit>();
    internetCubit.checkConnectivity();
    internetCubit.trackConnectivityChange();
    super.initState();
  }

  @override
  void dispose() {
    internetCubit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    final themeData = Theme.of(context);
    final light = themeData.brightness == Brightness.light;
    print(themeData.brightness == Brightness.light ? 'Light Mode' : 'Dark Mode');

    return BlocBuilder<InternetCubit, InternetStatus>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: light ? lightBackgroundYellow : background,
          appBar: AppBar(
            backgroundColor: light ? white : gray,
            automaticallyImplyLeading: false,
            elevation: 0,
            title: Row(
              children: [
                IconButton(
                  onPressed: (() => Navigator.of(context).pop()),
                  icon: SvgPicture.asset(
                    'assets/svgs/back-icon.svg',
                    width: screenWidth * 0.055,
                    color: light ? Colors.black87 : white.withOpacity(0.8),
                  ),
                ),
                SizedBox(
                  width: screenHeight * 0.024,
                ),
                Text(
                  'Donate',
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.044,
                    fontWeight: FontWeight.bold,
                    color: light ? black : white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          body: state.status == ConnectivityStatus.connected
              ? Stack(
            children: [
              WebView(
                initialUrl: url,
                gestureNavigationEnabled: true,
                javascriptMode: JavascriptMode.unrestricted,
                backgroundColor: light ? lightBackgroundYellow : background,
                onPageStarted: (String url) {
                  setState(() {
                    isLoading = true;
                  });
                },
                onPageFinished: (String url) {
                  setState(() {
                    isLoading = false;
                  });
                },
              ),
              if (isLoading)
                Center(
                  child: Lottie.asset(
                    "assets/animation/loading.json",
                    width: screenWidth * 0.250,
                  ),
                )
            ],
          )
              : const NoInternetPage(),
        );
      },
    );
  }
}
