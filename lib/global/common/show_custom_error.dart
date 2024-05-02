import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constant/color.dart';
import '../../features/core/screens/main_screen.dart';


class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final themeData = Theme.of(context);
    final light = themeData.brightness == Brightness.light;
    print(themeData.brightness == Brightness.light ? 'Light Mode' : 'Dark Mode');
    return Scaffold(
      body: Container(
        color: light ? white : gray,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/cancel.png",
              width: screenWidth * 0.300,
              height: screenHeight * 0.150,
            ),
            SizedBox(height: screenHeight * 0.020,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.012),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: GoogleFonts.poppins(color: light ? Colors.black87 : text, fontSize: screenWidth * 0.036),
                  children: [
                    TextSpan(
                      text: "Alert: ",
                      style: TextStyle(
                          color: primary,
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.036
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
            SizedBox(height: screenHeight * 0.100,),
            InkWell(
              onTap: (){
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const MainScreen(selectedIndex: 0),
                  ),
                      (route) => false,
                );
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.080),
                child: Container(
                  width: double.infinity,
                  height: screenHeight * 0.040,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      border: Border.all(color: text)
                  ),
                  child: Center(
                    child: Text('Go Back', style: GoogleFonts.poppins(fontSize: screenWidth * 0.036, color: light ? black : white),
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

