import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../constant/color.dart';
import '../../../cubit/theme_cubit.dart';

class ApearencePage extends StatefulWidget {
  const ApearencePage({super.key});

  @override
  State<ApearencePage> createState() => _ApearencePageState();
}

class _ApearencePageState extends State<ApearencePage> {

  bool _isLightMode = false;
  bool _isDarkMode = false;
  bool _isSystemMode = false;

  @override
  Widget build(BuildContext context) {
    Brightness brightness = Theme.of(context).brightness;

    SettingsThemeData darkSettingsTheme =  SettingsThemeData(
      settingsListBackground: background,
      settingsSectionBackground: gray,
      dividerColor: dividorColor,
    );

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    final themeData = Theme.of(context);
    final light = themeData.brightness == Brightness.light;
    print(themeData.brightness == Brightness.light ? 'Light Mode' : 'Dark Mode');

    final themeCubit = BlocProvider.of<ThemeCubit>(context);

    return Scaffold(
      backgroundColor: light ? const Color(0xffEFEFEF) : background,
      appBar: AppBar(
        backgroundColor: light ? white : gray,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Row(children: [
          IconButton(
              onPressed: (() => Navigator.of(context).pop()),
              icon: SvgPicture.asset('assets/svgs/back-icon.svg', width: screenWidth * 0.055, color: light ? Colors.black87 : text)),
          SizedBox(
            width: screenHeight * 0.024,
          ),
          Text(
            'Appearance',
            style: GoogleFonts.poppins(
                fontSize: screenHeight * 0.022,
                fontWeight: FontWeight.bold,
                color: light ? black : white.withOpacity(0.8)),
          ),
        ]),
      ),
      body: SafeArea(
        child: SettingsList(
          applicationType: ApplicationType.both,
          brightness: brightness,
          darkTheme: brightness == Brightness.dark ? darkSettingsTheme : null,
          sections: [
            SettingsSection(
              title: Text('Section', style: TextStyle(fontSize: screenHeight * 0.018),),
              tiles: [
                SettingsTile.switchTile(
                  title: Text('Light', style: TextStyle(fontSize: screenHeight * 0.019),),
                  leading: const Icon(Icons.light_mode),
                  onToggle: (_) => BlocProvider.of<ThemeCubit>(context).setTheme(ThemeMode.light),
                  initialValue: context.select((ThemeCubit cubit) => cubit.state == ThemeMode.light),
                ),
                SettingsTile.switchTile(
                  title: Text('Dark', style: TextStyle(fontSize: screenHeight * 0.019),),
                  leading: const Icon(Icons.dark_mode),
                  onToggle: (_) => BlocProvider.of<ThemeCubit>(context).setTheme(ThemeMode.dark),
                  initialValue: context.select((ThemeCubit cubit) => cubit.state == ThemeMode.dark),
                ),
                SettingsTile.switchTile(
                  description: Text("If you select 'system', the mode (light or dark) will match your phone's system setting.", style: TextStyle(fontSize: screenHeight * 0.017),),
                  title: Text('System', style: TextStyle(fontSize: screenHeight * 0.019),),
                  leading: const Icon(Icons.brightness_auto),
                  onToggle: (value) {
                    if (value) {
                      BlocProvider.of<ThemeCubit>(context).setSystemTheme();
                    } else {
                      BlocProvider.of<ThemeCubit>(context).setTheme(ThemeMode.light);
                    }
                  },
                  initialValue: context.select((ThemeCubit cubit) => cubit.state == ThemeMode.system),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
