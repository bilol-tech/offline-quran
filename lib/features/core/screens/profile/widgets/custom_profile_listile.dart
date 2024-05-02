import 'package:flutter/material.dart';

import '../../../../../constant/color.dart';

class CustomProfileListTile extends StatelessWidget {
  final String title;
  final IconData leadingIcon;
  final bool? switchValue;
  final ValueChanged<bool>? onSwitchChanged;
  final VoidCallback onTap;
  final Color iconColor;
  final Color titleColor;
  final Color titleWhiteColor;
  final Color iconWhiteColor;

  const CustomProfileListTile({
    Key? key,
    required this.title,
    required this.leadingIcon,
    this.switchValue,
    this.onSwitchChanged,
    this.iconColor = Colors.white,
    this.titleColor = Colors.white,
    this.titleWhiteColor = Colors.black,
    this.iconWhiteColor = Colors.black,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final themeData = Theme.of(context);
    final light = themeData.brightness == Brightness.light;
    print(themeData.brightness == Brightness.light ? 'Light Mode' : 'Dark Mode');
    return ListTile(
      contentPadding: EdgeInsets.only(left: screenHeight * 0.020, right: screenHeight * 0.005),
      minLeadingWidth: 0,
      horizontalTitleGap: screenHeight * 0.010,
      title: Text(
        title,
        style: TextStyle(color: light ? titleWhiteColor : titleColor, fontSize: screenWidth * 0.035),
      ),
      leading: Icon(
        leadingIcon,
        size: screenWidth * 0.040,
        color: light ? iconWhiteColor : iconColor,
      ),
      trailing: switchValue != null && onSwitchChanged != null
          ? Transform.scale(
            scale: 0.7,
            child: Switch.adaptive(
        value: switchValue!,
        onChanged: onSwitchChanged,
        activeColor: Colors.blue, // Change this color as needed
      ),
          )
          : null,
      onTap: onTap,
    );
  }
}
