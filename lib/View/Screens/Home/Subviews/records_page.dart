import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            runSpacing: 10,
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
      ),
    );
  }
}
