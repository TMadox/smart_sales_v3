import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smart_sales/View/Screens/Home/Widgets/button_selection.dart';

class DesktopPage extends StatefulWidget {
  const DesktopPage({Key? key}) : super(key: key);

  @override
  State<DesktopPage> createState() => _DesktopPageState();
}

class _DesktopPageState extends State<DesktopPage> {
  final storage = GetStorage();
  List<String> favorites = [];
  @override
  void initState() {
    try {
      favorites = List.from(json.decode(storage.read("favorites") ?? "[]"));
    } catch (e) {
      favorites = [];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            runSpacing: 10,
            children: favorites
                .map(
                  (e) => selectWidget(
                    type: e,
                    context: context,
                    storage: storage,
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
