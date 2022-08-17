import 'package:flutter/material.dart';

class OptionsButton extends StatelessWidget {
  final void Function()? onPressed;
  final Color color;
  final IconData iconData;
  final double? height;
  const OptionsButton(
      {Key? key,
      this.onPressed,
      required this.color,
      required this.iconData,
      this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(5), color: color),
      child: InkWell(
        onTap: onPressed,
        child: Icon(
          iconData,
          color: Colors.white,
        ),
      ),
    );
  }
}
