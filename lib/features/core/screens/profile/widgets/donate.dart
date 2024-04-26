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
    return BlocBuilder<InternetCubit, InternetStatus>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: background,
          appBar: AppBar(
            backgroundColor: gray,
            automaticallyImplyLeading: false,
            elevation: 10,
            title: Row(
              children: [
                IconButton(
                  onPressed: (() => Navigator.of(context).pop()),
                  icon: SvgPicture.asset(
                    'assets/svgs/back-icon.svg',
                    color: white.withOpacity(0.8),
                  ),
                ),
                const SizedBox(
                  width: 24,
                ),
                Text(
                  'Donate',
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: white.withOpacity(0.8),
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
                backgroundColor: background,
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
                    width: 120,
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
