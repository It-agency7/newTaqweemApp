import 'package:flutter/material.dart';

import '../utils/color_manager.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;

  const CustomButton(
      {Key? key,
      required this.title,
      required this.onPressed,
      this.backgroundColor = ColorManager.primary,
      this.textColor = ColorManager.white})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            elevation: 0, backgroundColor: backgroundColor),
        child: Text(
          title,
          style: TextStyle(color: textColor),
        ),
      ),
    );
  }
}
