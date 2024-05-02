import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../../constant/color.dart';
import '../../../provider/text_size_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final latinTextSizeProvider = Provider.of<LatinTextSizeProvider>(context);
    final arabicTextSizeProvider = Provider.of<ArabicTextSizeProvider>(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final themeData = Theme.of(context);
    final light = themeData.brightness == Brightness.light;
    print(themeData.brightness == Brightness.light ? 'Light Mode' : 'Dark Mode');
    return Scaffold(
      backgroundColor: light ? lightBackgroundYellow : background,
      appBar: AppBar(
        backgroundColor: light ? white : gray,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Row(children: [
          IconButton(
              onPressed: (() => Navigator.of(context).pop()),
              icon: SvgPicture.asset('assets/svgs/back-icon.svg', width: screenWidth * 0.055, color: light ? Colors.black87 : text,)),
          SizedBox(
            width: screenHeight * 0.024,
          ),
          Text(
            'Settings',
            style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.044,
                fontWeight: FontWeight.bold,
                color: light ? black : white.withOpacity(0.8)),
          ),
        ]),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.010, vertical: screenHeight * 0.015),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Text size', style: TextStyle(fontSize: screenWidth * 0.026, color: light ? black : white.withOpacity(0.7)),),
              SizedBox(height: screenHeight * 0.006,),
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  color: light ? white : gray,
                  border: Border.all(color: text, width: 0.11)
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.012, vertical: screenHeight * 0.007),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: (){
                          showDialog(context: context, builder: (BuildContext context){
                            return Dialog(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero
                              ),
                              backgroundColor: light ? white : gray, // Background color
                              elevation: 0, // No elevation
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Adjust Value",
                                      style: TextStyle(fontSize: screenWidth * 0.026, color: light ? black : white),
                                    ),
                                    SizedBox(height: screenHeight * 0.010,),
                                  StatefulBuilder(
                                    builder: (BuildContext context, void Function(void Function()) setState) {
                                      return SliderTheme(
                                        data: SliderTheme.of(context).copyWith(
                                          trackHeight: screenWidth * 0.006,
                                          activeTickMarkColor: primary,
                                          inactiveTickMarkColor: primary,
                                          thumbShape:
                                          RoundSliderThumbShape(enabledThumbRadius: screenWidth * 0.016),
                                          overlayShape: RoundSliderOverlayShape(overlayRadius: screenWidth * 0.024),
                                        ),
                                        child: Slider(
                                          min: 10,
                                          value: latinTextSizeProvider.currentLatinTextSize,
                                          max: 40,
                                          divisions: 10,
                                          label: latinTextSizeProvider.currentLatinTextSize
                                              .round()
                                              .toString(),
                                          onChanged: (double value) {
                                            setState(() {
                                              latinTextSizeProvider.updateLatinTextSize(value);
                                            });
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                    SizedBox(height: screenHeight * 0.010),
                                  ],
                                ),
                              ),
                            );
                          });
                        },
                        child: Row(
                          children: [
                            Text("Latin", style: TextStyle(color: light ? black : white, fontSize: screenWidth * 0.026),),
                            const Spacer(),
                            Text(latinTextSizeProvider.currentLatinTextSize.round().toString(), style: TextStyle(color: primary, fontSize: screenWidth * 0.028, fontStyle: FontStyle.italic),),
                          ],
                        ),
                      ),
                      Divider(color: text,),
                      InkWell(
                        onTap: (){
                          showDialog(context: context, builder: (BuildContext context){
                            return Dialog(
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero
                              ),
                              backgroundColor: light ? white : gray, // Background color
                              elevation: 0, // No elevation
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Adjust Value",
                                      style: TextStyle(fontSize: screenWidth * 0.026, color: light ? black : white),
                                    ),
                                    SizedBox(height: screenHeight * 0.010,),
                                    StatefulBuilder(
                                      builder: (BuildContext context, void Function(void Function()) setState) {
                                        return SliderTheme(
                                          data: SliderTheme.of(context).copyWith(
                                            trackHeight: screenWidth * 0.006,
                                            activeTickMarkColor: primary,
                                            inactiveTickMarkColor: primary,
                                            thumbShape: RoundSliderThumbShape(enabledThumbRadius: screenWidth * 0.016),
                                            overlayShape: RoundSliderOverlayShape(overlayRadius: screenWidth * 0.024),
                                          ),
                                          child: Slider(
                                            min: 10,
                                            value: arabicTextSizeProvider.currentArabicTextSize,
                                            max: 40,
                                            divisions: 10,
                                            label: arabicTextSizeProvider.currentArabicTextSize
                                                .round()
                                                .toString(),
                                            onChanged: (double value) {
                                              setState(() {
                                                arabicTextSizeProvider.updateArabicTextSize(value);
                                              });
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                    SizedBox(height: screenHeight * 0.010),
                                  ],
                                ),
                              ),
                            );
                          });
                        },
                        child: Row(
                          children: [
                            Text("Arabic", style: TextStyle(color: light ? black : white, fontSize: screenWidth * 0.026),),
                            const Spacer(),
                            Text(arabicTextSizeProvider.currentArabicTextSize.round().toString(), style: TextStyle(color: primary, fontSize: screenWidth * 0.028, fontStyle: FontStyle.italic),),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
