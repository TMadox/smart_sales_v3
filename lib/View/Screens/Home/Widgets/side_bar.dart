import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_sales/App/Resources/screen_size.dart';

class SideBar extends StatefulWidget {
  final PageController page;
  final double constrainedWidth;
  const SideBar({
    Key? key,
    required this.page,
    required this.constrainedWidth,
  }) : super(key: key);

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  int selectedPage = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF074fb3),
      padding: EdgeInsets.symmetric(
        horizontal: widget.constrainedWidth * 0.01,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: const Color(0xFF074fb3),
              padding: EdgeInsets.zero,
              side: BorderSide(
                color:
                    selectedPage == 0 ? Colors.white : const Color(0xFF074fb3),
              ),
            ),
            onPressed: () {
              setState(() {
                selectedPage = 0;
              });
              widget.page.animateToPage(
                0,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeIn,
              );
            },
            child: AutoSizeText(
              'general'.tr,
              maxLines: 1,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: screenWidth(context) * 0.024,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: const Color(0xFF074fb3),
              padding: EdgeInsets.zero,
              side: BorderSide(
                color:
                    selectedPage == 1 ? Colors.white : const Color(0xFF074fb3),
              ),
            ),
            onPressed: () {
              setState(() {
                selectedPage = 1;
              });
              widget.page.animateToPage(
                1,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeIn,
              );
            },
            child: AutoSizeText(
              'receipts'.tr,
              maxLines: 1,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: screenWidth(context) * 0.024,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: const Color(0xFF074fb3),
              padding: EdgeInsets.zero,
              side: BorderSide(
                color:
                    selectedPage == 2 ? Colors.white : const Color(0xFF074fb3),
              ),
            ),
            onPressed: () {
              setState(() {
                selectedPage = 2;
              });
              widget.page.animateToPage(
                2,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeIn,
              );
            },
            child: AutoSizeText(
              'documents'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: screenWidth(context) * 0.024,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.zero,
              primary: const Color(0xFF074fb3),
              side: BorderSide(
                color:
                    selectedPage == 3 ? Colors.white : const Color(0xFF074fb3),
              ),
            ),
            onPressed: () {
              setState(() {
                selectedPage = 3;
              });
              widget.page.animateToPage(
                3,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeIn,
              );
            },
            child: AutoSizeText(
              'reports'.tr,
              style: TextStyle(
                fontSize: screenWidth(context) * 0.024,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.zero,
              primary: const Color(0xFF074fb3),
              side: BorderSide(
                color:
                    selectedPage == 4 ? Colors.white : const Color(0xFF074fb3),
              ),
            ),
            onPressed: () {
              setState(() {
                selectedPage = 4;
              });
              widget.page.animateToPage(
                4,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeIn,
              );
            },
            child: AutoSizeText(
              'records'.tr,
              style: TextStyle(
                fontSize: screenWidth(context) * 0.024,
              ),
            ),
          )
        ],
      ),
    );
  }
}
