import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../constant/color.dart';

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
            'Appearance',
            style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: white.withOpacity(0.8)),
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
              title: const Text('Section'),
              tiles: [
                SettingsTile.switchTile(
                  title: const Text('Light'),
                  leading: const Icon(Icons.light_mode),
                  onToggle: (bool value) {
                    setState(() {
                      _isLightMode = value;
                      _isDarkMode = false;
                      _isSystemMode = false;
                    });
                  }, initialValue: _isLightMode,
                ),
                SettingsTile.switchTile(
                  title: const Text('Dark'),
                  leading: const Icon(Icons.dark_mode),
                  onToggle: (bool value) {
                    setState(() {
                      _isDarkMode = value;
                      _isLightMode = false;
                      _isSystemMode = false;
;                    });
                  }, initialValue: !_isLightMode && !_isSystemMode,
                ),
                SettingsTile.switchTile(
                  description: Text("If you select 'system', the mode (light or dark) will match your phone's system setting."),
                  title: const Text('System'),
                  leading: const Icon(Icons.brightness_auto),
                  onToggle: (bool value) {
                    setState(() {
                      _isSystemMode = value;
                      _isLightMode = false;
                      _isDarkMode = false;
                    });
                  }, initialValue: _isSystemMode,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
