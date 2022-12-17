import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smart_sales/View/Screens/Home/Widgets/button_selection.dart';
import 'package:smart_sales/View/Screens/Home/home_viewmodel.dart';

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
    favorites = storage.read("favorites") ?? [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final HomeController _homeViewmodel = HomeController();
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            "assets/home_background3.png",
          ),
          fit: BoxFit.fill,
        ),
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: LayoutBuilder(
          builder: (context, constrains) {
            return Center(
              child: SizedBox(
                width: constrains.maxWidth * 0.89,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  runSpacing: constrains.maxHeight * 0.02,
                  spacing: constrains.maxWidth * 0.02,
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
            );
          },
        ),
      ),
    );
  }
}
