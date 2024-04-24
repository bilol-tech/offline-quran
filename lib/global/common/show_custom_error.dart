import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constant/color.dart';
import '../../features/core/screens/main_screen.dart';


class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: gray,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/cancel.png",
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: GoogleFonts.poppins(color: text, fontSize: 16),
                  children: [
                    TextSpan(
                      text: "Alert: ",
                      style: TextStyle(
                          color: primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 18
                      ),
                    ),
                    const TextSpan(
                      text:
                      "Something's gone wrong with the system. Please refresh the app or return to the previous page. Thanks for your cooperation.",
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 100,),
            InkWell(
              onTap: (){
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => const MainScreen(selectedIndex: 0),
                    transitionsBuilder: (_, animation, __, child) {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(1.0, 0.0), // Start from right side
                          end: Offset.zero, // Move to the center
                        ).animate(animation),
                        child: child,
                      );
                    },
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 80.0),
                child: Container(
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      border: Border.all(color: text)
                  ),
                  child: Center(
                    child: Text('Go Back', style: GoogleFonts.poppins(fontSize: 16, color: white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

