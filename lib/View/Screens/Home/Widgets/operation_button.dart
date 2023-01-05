import 'package:flutter/material.dart';
import 'package:smart_sales/App/Resources/screen_size.dart';

class OperationButton extends StatelessWidget {
  final bool visible;
  final Function() onPressed;
  final String imagePath;
  final String title;
  const OperationButton({
    Key? key,
    required this.visible,
    required this.onPressed,
    required this.imagePath,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: GestureDetector(
        onTap: onPressed,
        child: Column(
          children: [
            CircleAvatar(
              radius: screenWidth(context) * 0.05,
              child: Image.asset(
                imagePath,
                fit: BoxFit.fill,
              ),
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: screenWidth(context) * 0.015,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}
