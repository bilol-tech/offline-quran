import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class NoInternetPage extends StatelessWidget {
  const NoInternetPage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Image.asset(
            "assets/images/no_internet.png",
            width: screenWidth * 0.120,
          ),
        ),
        SizedBox(height: screenHeight * 0.008,),
        Center(child: Text("No Internet Connection", style: GoogleFonts.poppins(fontSize: screenWidth * 0.040, fontWeight: FontWeight.bold),))
      ],
    );
  }
}
