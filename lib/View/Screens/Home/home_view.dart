import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:provider/provider.dart';
import 'package:smart_sales/App/Resources/screen_size.dart';
import 'package:smart_sales/App/Util/routing.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smart_sales/Provider/info_state.dart';
import 'package:smart_sales/Provider/user_state.dart';
import 'package:smart_sales/View/Common/Controllers/upload_controller.dart';
import 'package:smart_sales/View/Screens/Home/Subviews/desktop_page.dart';
import 'package:smart_sales/View/Screens/Home/Subviews/documents_page.dart';
import 'package:smart_sales/View/Screens/Home/Subviews/info_page.dart';
import 'package:smart_sales/View/Screens/Home/Subviews/operations_page.dart';
import 'package:smart_sales/View/Screens/Home/Subviews/records_page.dart';
import 'package:smart_sales/View/Screens/Home/Widgets/custom_fab.dart';
import 'package:smart_sales/View/Screens/Home/Widgets/side_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with RouteAware {
  PageController page = PageController();
  final storage = GetStorage();
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  Future<void> didPush() async {
    await Get.find<UploadController>().commit(showLoading: false);
    super.didPush();
  }

  @override
  Future<void> didPopNext() async {
    await Get.find<UploadController>().commit(showLoading: false);

    super.didPopNext();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      left: false,
      right: false,
      bottom: false,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Row(
            children: [
              Expanded(
                flex: 6,
                child: CustomFAB(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        "assets/home_background3.png",
                        fit: BoxFit.fill,
                      ),
                      PageView(
                        controller: page,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          const DesktopPage(),
                          const OperationsPage(),
                          const DocumentsPage(),
                          InfoPage(storage: storage),
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                context.read<UserState>().user.userName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 100),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        await storage.write(
                                          "language",
                                          "ar",
                                        );
                                        await Get.updateLocale(
                                          const Locale("ar"),
                                        );
                                        setState(() {});
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: (storage.read("language") ??
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
                                                screenWidth(context) * 0.02,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        await storage.write(
                                          "language",
                                          "en",
                                        );
                                        await Get.updateLocale(
                                          const Locale("en"),
                                        );
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        decoration: BoxDecoration(
                                          color: (storage.read("language") ??
                                                      "ar") ==
                                                  "en"
                                              ? Colors.green
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          "english".tr,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                DateFormat("d-MM-yy").format(DateTime.now()),
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
                            const SizedBox(
                              width: 50,
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
                child: SideBar(
                  page: page,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
