import 'package:flutter/material.dart';

class CommonButton extends StatelessWidget {
  final String title;
  final Widget icon;
  final Color? color;
  final Color? titleColor;

  final void Function()? onPressed;
  const CommonButton(
      {Key? key,
      required this.title,
      this.titleColor,
      required this.icon,
      required this.color,
      this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            10,
          ),
        ),
      ),
      icon: icon,
      label: Text(
        title,
        style: TextStyle(
          color: titleColor,
        ),
      ),
    );
  }
}
