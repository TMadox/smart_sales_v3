import 'package:flutter/material.dart';
import 'package:smart_sales/App/Util/locator.dart';
import 'package:smart_sales/Data/Database/Shared/shared_storage.dart';
import 'package:smart_sales/View/Screens/Home/home_viewmodel.dart';

class DesktopPage extends StatefulWidget {
  const DesktopPage({Key? key}) : super(key: key);

  @override
  State<DesktopPage> createState() => _DesktopPageState();
}

class _DesktopPageState extends State<DesktopPage> {
  final storage = locator.get<SharedStorage>().prefs;
  List<String> favorites = [];
  @override
  void initState() {
    favorites = storage.getStringList("favorites") ?? [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final HomeViewmodel _homeViewmodel = HomeViewmodel();
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
                        (e) => _homeViewmodel.selectWidget(
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
