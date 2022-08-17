import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:smart_sales/App/Resources/screen_size.dart';
import 'package:smart_sales/App/Util/routing.dart';
import 'package:smart_sales/Data/Database/Shared/shared_storage.dart';
import 'package:smart_sales/App/Util/locator.dart';
import 'package:smart_sales/Provider/info_state.dart';
import 'package:smart_sales/Provider/user_state.dart';
import 'package:smart_sales/View/Screens/Home/Subviews/desktop_page.dart';
import 'package:smart_sales/View/Screens/Home/Subviews/documents_page.dart';
import 'package:smart_sales/View/Screens/Home/Subviews/info_page.dart';
import 'package:smart_sales/View/Screens/Home/Subviews/operations_page.dart';
import 'package:smart_sales/View/Screens/Home/Subviews/records_page.dart';
import 'package:smart_sales/View/Screens/Home/Widgets/custom_fab.dart';
import 'package:smart_sales/View/Screens/Home/home_viewmodel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with RouteAware {
  final HomeViewmodel _homeViewmodel = HomeViewmodel();
  int selectedPage = 0;
  PageController page = PageController();
  final storage = locator.get<SharedStorage>().prefs;
  Timer? timer;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    timer = Timer.periodic(
      const Duration(seconds: 30),
      (Timer t) async => (mounted) {
        _homeViewmodel.onUpload(context);
      },
    );
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Future<void> didPush() async {
    setState(() {});
    await _homeViewmodel.onUpload(context);
    super.didPush();
  }

  @override
  Future<void> didPopNext() async {
    setState(() {});
    await _homeViewmodel.onUpload(context);
    super.didPopNext();
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      left: false,
      right: false,
      bottom: false,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: LayoutBuilder(builder: (context, constrains) {
          return ProgressHUD(
            child: Builder(builder: (context) {
              return Scaffold(
                resizeToAvoidBottomInset: false,
                body: Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: CustomFAB(
                        child: Stack(
                          children: [
                            PageView(
                              controller: page,
                              children: [
                                const DesktopPage(),
                                const OperationsPage(),
                                const DocumentsPage(),
                                InfoPage(
                                  storage: storage,
                                ),
                                const RecordsPage(),
                              ],
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                color: const Color(0xFF074fb3),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      context.read<UserState>().user.userName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            onTap: () async {
                                              await storage.setString(
                                                "language",
                                                "ar",
                                              );
                                              await Get.updateLocale(
                                                const Locale("ar"),
                                              );
                                              setState(() {});
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 5,
                                              ),
                                              decoration: BoxDecoration(
                                                color: (storage.getString(
                                                                "language") ??
                                                            "ar") ==
                                                        "ar"
                                                    ? Colors.green
                                                    : Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                "arabic".tr,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize:
                                                      screenWidth(context) *
                                                          0.02,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: screenWidth(context) * 0.01,
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              await storage.setString(
                                                "language",
                                                "en",
                                              );
                                              await Get.updateLocale(
                                                const Locale("en"),
                                              );
                                              setState(() {});
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5),
                                              decoration: BoxDecoration(
                                                color: (storage.getString(
                                                                "language") ??
                                                            "ar") ==
                                                        "en"
                                                    ? Colors.green
                                                    : Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                "english".tr,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize:
                                                      screenWidth(context) *
                                                          0.02,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      DateTime.now().toString(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topCenter,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: constrains.maxWidth * 0.12,
                                  ),
                                  AutoSizeText(
                                    context
                                        .read<InfoState>()
                                        .info
                                        .companyName
                                        .toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: screenWidth(context) * 0.035,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: const Color(0xFF074fb3),
                        padding: EdgeInsets.symmetric(
                          horizontal: constrains.maxWidth * 0.01,
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
                                  color: selectedPage == 0
                                      ? Colors.white
                                      : const Color(0xFF074fb3),
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  selectedPage = 0;
                                });
                                page.animateToPage(
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
                                  color: selectedPage == 1
                                      ? Colors.white
                                      : const Color(0xFF074fb3),
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  selectedPage = 1;
                                });
                                page.animateToPage(
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
                                  color: selectedPage == 2
                                      ? Colors.white
                                      : const Color(0xFF074fb3),
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  selectedPage = 2;
                                });
                                page.animateToPage(
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
                                  color: selectedPage == 3
                                      ? Colors.white
                                      : const Color(0xFF074fb3),
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  selectedPage = 3;
                                });
                                page.animateToPage(
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
                                  color: selectedPage == 4
                                      ? Colors.white
                                      : const Color(0xFF074fb3),
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  selectedPage = 4;
                                });
                                page.animateToPage(
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
                      ),
                    ),
                  ],
                ),
              );
            }),
          );
        }),
      ),
    );
  }
}
