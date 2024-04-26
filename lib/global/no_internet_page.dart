import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class NoInternetPage extends StatelessWidget {
  const NoInternetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Image.asset(
            "assets/images/no_internet.png",
            width: 60,
          ),
        ),
        const SizedBox(height: 8,),
        Center(child: Text("No Internet Connection", style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),))
      ],
    );
  }
}
