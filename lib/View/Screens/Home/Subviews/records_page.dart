import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_sales/App/Util/locator.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smart_sales/View/Screens/Home/Widgets/operation_button.dart';
import 'package:smart_sales/View/Screens/Register/register_view.dart';

class RecordsPage extends StatefulWidget {
  const RecordsPage({Key? key}) : super(key: key);

  @override
  State<RecordsPage> createState() => _RecordsPageState();
}

class _RecordsPageState extends State<RecordsPage> {
  final storage = GetStorage();

  @override
  Widget build(BuildContext context) {
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
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    SizedBox(
                      width: constrains.maxWidth * 0.89,
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: constrains.maxWidth * 0.02,
                        runSpacing: constrains.maxHeight * 0.02,
                        children: [
                          OperationButton(
                            imagePath: "assets/new_rec.png",
                            title: "new_rec".tr,
                            onPressed: () {
                              Get.to(
                                () => const RegisterView(),
                              );
                            },
                            visible: storage.read("allow_new_rec") ?? true,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
