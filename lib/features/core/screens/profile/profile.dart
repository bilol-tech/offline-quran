import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:offline_quran_app/features/core/screens/profile/widgets/about_app.dart';
import 'package:offline_quran_app/features/core/screens/profile/widgets/appearence_page.dart';
import 'package:offline_quran_app/features/core/screens/profile/widgets/custom_profile_listile.dart';
import 'package:offline_quran_app/features/core/screens/profile/widgets/donate.dart';
import 'package:offline_quran_app/features/core/screens/profile/widgets/saved_ayah.dart';
import 'package:offline_quran_app/features/core/screens/profile/widgets/settings_page.dart';
import 'package:simple_connection_checker/simple_connection_checker.dart';
import '../../../../constant/color.dart';
import '../../../../global/check_connect_internet.dart';
import '../../../../global/common/toasts.dart';
import '../../../auth/screens/sign_in/sign_in.dart';
import '../../cubit/internet_cubit.dart';
import '../../cubit/internet_state.dart';
import '../main_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

bool isDarkModeEnabled = false;

class _ProfileScreenState extends State<ProfileScreen> {
  var auth = FirebaseAuth.instance;

  bool _isConnected = false;

  late InternetCubit internetCubit;

  User? user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    internetCubit = context.read<InternetCubit>();
    internetCubit.checkConnectivity();
    internetCubit.trackConnectivityChange();
    print(user?.email.toString());
    print(user?.uid.toString());
  }



  @override
  void dispose() {
    internetCubit.dispose();
    super.dispose();
  }

  String formatCreationTime(UserMetadata? metadata) {
    if (metadata != null) {
      DateTime? creationTime = metadata.creationTime;

      return 'Joined: ${DateFormat('dd.MM.yyyy').format(creationTime!)}';
    } else {
      return 'Unknown';
    }
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
            backgroundColor: light ? lightBackgroundWhite : gray,
            automaticallyImplyLeading: false,
            elevation: 0,
            centerTitle: false,
            title: Padding(
              padding: EdgeInsets.only(left: screenHeight * 0.010),
              child: Text(
                'My Page',
                style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.055,
                    fontWeight: FontWeight.bold,
                    color: light ? black : white.withOpacity(0.8)),
              ),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: screenWidth * 0.030,
                  ),
                  user != null
                      ? GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: light ? white : gray,
                        builder: (BuildContext context) {
                          return Container(
                            height: screenHeight * 0.25,
                            color: light ? white : gray,
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: screenHeight * 0.012, top: screenHeight * 0.012),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.person,
                                        size: screenWidth * 0.040,
                                        color: light ? black : white,
                                      ),
                                      SizedBox(
                                        width: screenWidth * 0.016,
                                      ),
                                      Text(
                                        "${user?.email}",
                                        style: TextStyle(
                                            color: light ? black : white,
                                            fontSize: screenWidth * 0.028),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: screenHeight * 0.004,
                                ),
                                Divider(
                                  color: Colors.grey.withOpacity(0.6),
                                  thickness: 0.3,
                                ),
                                // CustomProfileListTile(
                                //   title: 'Edit Login',
                                //   leadingIcon: Icons.edit,
                                //   onTap: () {
                                //     // Navigator.of(context).pushReplacement(
                                //     //   PageRouteBuilder(
                                //     //     pageBuilder: (_, __, ___) => const UpdateLogin(),
                                //     //     transitionsBuilder: (_, animation, __, child) {
                                //     //       return SlideTransition(
                                //     //         position: Tween<Offset>(
                                //     //           begin: const Offset(1.0, 0.0),
                                //     //           end: Offset.zero,
                                //     //         ).animate(animation),
                                //     //         child: child,
                                //     //       );
                                //     //     },
                                //     //   ),
                                //     // );
                                //   },
                                // ),
                                CustomProfileListTile(
                                  title: 'Delete Profile',
                                  leadingIcon: Icons.delete,
                                  iconColor: light ? black : white,
                                  titleColor: light ? black : white,
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog.adaptive(
                                          content: Text(
                                            'Are you sure to delete account?', style: TextStyle(fontSize: screenWidth * 0.033),
                                          ),
                                          // backgroundColor: gray,
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text(
                                                'Cancel',
                                                style: TextStyle(color: text, fontSize:  screenWidth * 0.035),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                if (state.status == ConnectivityStatus.connected) {
                                                  auth.currentUser
                                                      ?.delete()
                                                      .then((_) {
                                                    showToast(
                                                        message:
                                                        "Successfull deleted");
                                                    Navigator.of(context).pushAndRemoveUntil(
                                                      MaterialPageRoute(
                                                        builder: (context) => const MainScreen(selectedIndex: 0),
                                                      ), (route) => false,
                                                    );
                                                  }).catchError((error) {
                                                    print(
                                                        "Failed to delete account: $error");
                                                    showToast(
                                                        message:
                                                        "Failed to delete account");
                                                  });
                                                } else if(_isConnected == false) {
                                                  showToast(message:"No Internet Connection");
                                                  Navigator.of(context).pop();
                                                } else {
                                                  showToast(
                                                      message:
                                                      "Failed to delete account");
                                                }
                                              },
                                              child: Text('Confirm',
                                                  style: TextStyle(
                                                      color: primary, fontSize: screenWidth * 0.035)),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                                CustomProfileListTile(
                                  title: 'LogOut',
                                  titleColor: light ? Colors.red : Colors.red,
                                  leadingIcon: Icons.logout,
                                  iconColor: light ? Colors.red : Colors.red,
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog.adaptive(
                                          content: Text(
                                            'Are you sure to signOut from account?', style: TextStyle(fontSize: screenWidth * 0.033),
                                          ),
                                          // backgroundColor: gray,
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text(
                                                'Cancel',
                                                style: TextStyle(color: text, fontSize: screenWidth * 0.035),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                if (state.status == ConnectivityStatus.connected) {
                                                  auth.signOut();
                                                  showToast(
                                                      message:
                                                      "Successfully signedOut");
                                                  Navigator.of(context).pushAndRemoveUntil(
                                                    MaterialPageRoute(
                                                      builder: (context) => const MainScreen(selectedIndex: 0),
                                                    ), (route) => false,
                                                  )
                                                      .catchError((error) {
                                                    print(
                                                        "Failed to signOut account: $error");
                                                    showToast(
                                                        message:
                                                        "Failed to signOut account");
                                                  });
                                                } else if(_isConnected == false) {
                                                  showToast(message:"No Internet Connection");
                                                  Navigator.of(context).pop();
                                                } else {
                                                  showToast(
                                                      message:
                                                      "Failed to delete account");
                                                }
                                              },
                                              child: Text('Confirm',
                                                  style: TextStyle(
                                                      color: primary, fontSize: screenWidth * 0.035)),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.045),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius:
                            const BorderRadius.all(Radius.circular(3)),
                            border: Border.all(color: text.withOpacity(0.12)),
                            color: light ? white : gray),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: screenWidth * 0.020, horizontal: screenWidth * 0.020),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              user?.photoURL != null
                                  ? Center(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      bottom: screenWidth * 0.020),
                                  child: ClipOval(
                                    child: state.status == ConnectivityStatus.connected
                                        ? Image.network(
                                      "${user?.photoURL}",
                                      width: screenWidth * 0.120,
                                      height: screenWidth * 0.120,
                                      fit: BoxFit.cover,
                                    )
                                        : Image.asset(
                                      "assets/images/user.png",
                                      width: screenWidth * 0.120,
                                      height: screenWidth * 0.120,
                                    ),
                                  ),
                                ),
                              )
                                  : const SizedBox(),
                              user?.phoneNumber != null
                                  ? Text(
                                "${user?.phoneNumber}",
                                style: TextStyle(color: light ? black : white, fontSize: screenWidth * 0.030),
                              )
                                  : const SizedBox(),
                              user?.displayName != null
                                  ? Text(
                                "${user?.displayName}",
                                style: TextStyle(color: light ? black : white, fontSize: screenWidth * 0.034),
                              )
                                  : const SizedBox(),
                              Text(
                                "${user?.email}",
                                style: TextStyle(color: light ? black : white, fontSize: screenWidth * 0.030),
                              ),
                              Text(
                                formatCreationTime(user?.metadata),
                                style: TextStyle(color: light ? black : white, fontSize: screenWidth * 0.022),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                      : GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder: (_, __, ___) => const SignIn(),
                          transitionsBuilder: (_, animation, __, child) {
                            return SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(1.0, 0.0),
                                // Start from right side
                                end: Offset.zero, // Move to the center
                              ).animate(animation),
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.030),
                      child: Container(
                        height: screenHeight * 0.050,
                        decoration: BoxDecoration(
                            borderRadius:
                            const BorderRadius.all(Radius.circular(3)),
                            color: primary),
                        child: Center(
                            child: Text(
                              "Sign in or register to access",
                              style: TextStyle(color: white, fontSize: screenHeight * 0.015),
                            )),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.008,
                  ),
                  CustomProfileListTile(
                    title: 'Settings',
                    leadingIcon: Icons.settings,
                    onTap: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder: (_, __, ___) => const SettingsPage(),
                          transitionsBuilder: (_, animation, __, child) {
                            return SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(1.0, 0.0),
                                // Start from right side
                                end: Offset.zero, // Move to the center
                              ).animate(animation),
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                  ),
                  CustomProfileListTile(
                    title: 'Saved',
                    leadingIcon: Icons.save,
                    onTap: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder: (_, __, ___) => SavedAyahPage(),
                          transitionsBuilder: (_, animation, __, child) {
                            return SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(1.0, 0.0),
                                // Start from right side
                                end: Offset.zero, // Move to the center
                              ).animate(animation),
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                  ),
                  CustomProfileListTile(
                    title: 'Appearance',
                    leadingIcon: Icons.settings_display_rounded,
                    onTap: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder: (_, __, ___) => const ApearencePage(),
                          transitionsBuilder: (_, animation, __, child) {
                            return SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(1.0, 0.0),
                                // Start from right side
                                end: Offset.zero, // Move to the center
                              ).animate(animation),
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                  ),
                  CustomProfileListTile(
                    title: 'About App',
                    leadingIcon: Icons.info,
                    onTap: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder: (_, __, ___) => const AboutApp(),
                          transitionsBuilder: (_, animation, __, child) {
                            return SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(1.0, 0.0),
                                // Start from right side
                                end: Offset.zero, // Move to the center
                              ).animate(animation),
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                  ),
                  CustomProfileListTile(
                    title: 'Donate',
                    leadingIcon: Icons.monetization_on,
                    onTap: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder: (_, __, ___) => const DonatePage(),
                          transitionsBuilder: (_, animation, __, child) {
                            return SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(1.0, 0.0),
                                // Start from right side
                                end: Offset.zero, // Move to the center
                              ).animate(animation),
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                  ),
                  CustomProfileListTile(
                    title: 'Video Intro',
                    leadingIcon: Icons.video_collection,
                    onTap: () {},
                  ),
                  CustomProfileListTile(
                    title: 'Our other Apps',
                    leadingIcon: Icons.apps_outage_sharp,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
