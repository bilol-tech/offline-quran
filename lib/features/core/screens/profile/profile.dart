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

  final ConnectivityService _connectivityService = ConnectivityService();
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
                'My Page',
                style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: white.withOpacity(0.8)),
              ),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  user != null
                      ? GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: gray,
                        builder: (BuildContext context) {
                          return Container(
                            height: MediaQuery.of(context).size.height * 0.22,
                            color: gray,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12.0, top: 12),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.person,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        "${user?.email}",
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14),
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
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog.adaptive(
                                          content: const Text(
                                            'Are you sure to delete account?',
                                          ),
                                          // backgroundColor: gray,
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text(
                                                'Cancel',
                                                style: TextStyle(color: text),
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
                                                      color: primary)),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                                CustomProfileListTile(
                                  title: 'LogOut',
                                  titleColor: Colors.red,
                                  leadingIcon: Icons.logout,
                                  iconColor: Colors.red,
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog.adaptive(
                                          content: const Text(
                                            'Are you sure to signOut from account?',
                                          ),
                                          // backgroundColor: gray,
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text(
                                                'Cancel',
                                                style: TextStyle(color: text),
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
                                                      color: primary)),
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
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius:
                            const BorderRadius.all(Radius.circular(3)),
                            border: Border.all(color: text.withOpacity(0.4)),
                            color: gray),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              user?.photoURL != null
                                  ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 10.0),
                                  child: ClipOval(
                                    child: state.status == ConnectivityStatus.connected
                                        ? Image.network(
                                      "${user?.photoURL}",
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                    )
                                        : Image.asset(
                                      "assets/images/user.png",
                                      width: 60,
                                      height: 60,
                                    ),
                                  ),
                                ),
                              )
                                  : const SizedBox(),
                              user?.phoneNumber != null
                                  ? Text(
                                "${user?.phoneNumber}",
                                style: TextStyle(color: white),
                              )
                                  : const SizedBox(),
                              user?.displayName != null
                                  ? Text(
                                "${user?.displayName}",
                                style: TextStyle(color: white),
                              )
                                  : const SizedBox(),
                              Text(
                                "${user?.email}",
                                style: TextStyle(color: white),
                              ),
                              Text(
                                formatCreationTime(user?.metadata),
                                style: TextStyle(color: white, fontSize: 10),
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
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Container(
                        height: 45,
                        decoration: BoxDecoration(
                            borderRadius:
                            const BorderRadius.all(Radius.circular(3)),
                            color: primary),
                        child: Center(
                            child: Text(
                              "Sign in or register to access.",
                              style: TextStyle(color: white),
                            )),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
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
