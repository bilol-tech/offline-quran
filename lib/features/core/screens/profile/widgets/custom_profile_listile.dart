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

  const CustomProfileListTile({
    Key? key,
    required this.title,
    required this.leadingIcon,
    this.switchValue,
    this.onSwitchChanged,
    this.iconColor = Colors.white,
    this.titleColor = Colors.white,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 20, right: 5),
      minLeadingWidth: 0,
      horizontalTitleGap: 10,
      title: Text(
        title,
        style: TextStyle(color: titleColor),
      ),
      leading: Icon(
        leadingIcon,
        size: 20,
        color: iconColor,
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
