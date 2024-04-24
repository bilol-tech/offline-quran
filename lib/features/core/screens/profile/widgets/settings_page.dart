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
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: gray,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Row(children: [
          IconButton(
              onPressed: (() => Navigator.of(context).pop()),
              icon: SvgPicture.asset('assets/svgs/back-icon.svg')),
          const SizedBox(
            width: 24,
          ),
          Text(
            'Settings',
            style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: white.withOpacity(0.8)),
          ),
        ]),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Text size', style: TextStyle(fontSize: 10, color: white.withOpacity(0.7)),),
              const SizedBox(height: 3,),
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  color: gray,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: (){
                          showDialog(context: context, builder: (BuildContext context){
                            return Dialog(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero
                              ),
                              backgroundColor: gray, // Background color
                              elevation: 0, // No elevation
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Adjust Value",
                                      style: TextStyle(fontSize: 13, color: white),
                                    ),
                                  const SizedBox(height: 10,),
                                  StatefulBuilder(
                                    builder: (BuildContext context, void Function(void Function()) setState) {
                                      return SliderTheme(
                                        data: SliderTheme.of(context).copyWith(
                                          trackHeight: 3.0,
                                          activeTickMarkColor: primary,
                                          inactiveTickMarkColor: primary,
                                          thumbShape:
                                          const RoundSliderThumbShape(enabledThumbRadius: 8.0),
                                          overlayShape:
                                          const RoundSliderOverlayShape(overlayRadius: 12.0),
                                        ),
                                        child: Slider(
                                          min: 16,
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
                                    const SizedBox(height: 10),
                                  ],
                                ),
                              ),
                            );
                          });
                        },
                        child: Row(
                          children: [
                            Text("Latin", style: TextStyle(color: white, fontSize: 13),),
                            const Spacer(),
                            Text(latinTextSizeProvider.currentLatinTextSize.round().toString(), style: TextStyle(color: primary, fontSize: 14, fontStyle: FontStyle.italic),),
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
                              backgroundColor: gray, // Background color
                              elevation: 0, // No elevation
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Adjust Value",
                                      style: TextStyle(fontSize: 13, color: white),
                                    ),
                                    const SizedBox(height: 10,),
                                    StatefulBuilder(
                                      builder: (BuildContext context, void Function(void Function()) setState) {
                                        return SliderTheme(
                                          data: SliderTheme.of(context).copyWith(
                                            trackHeight: 3.0,
                                            activeTickMarkColor: primary,
                                            inactiveTickMarkColor: primary,
                                            thumbShape:
                                            const RoundSliderThumbShape(enabledThumbRadius: 8.0),
                                            overlayShape:
                                            const RoundSliderOverlayShape(overlayRadius: 12.0),
                                          ),
                                          child: Slider(
                                            min: 16,
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
                                    const SizedBox(height: 10),
                                  ],
                                ),
                              ),
                            );
                          });
                        },
                        child: Row(
                          children: [
                            Text("Arabic", style: TextStyle(color: white, fontSize: 13),),
                            const Spacer(),
                            Text(arabicTextSizeProvider.currentArabicTextSize.round().toString(), style: TextStyle(color: primary, fontSize: 14, fontStyle: FontStyle.italic),),
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
