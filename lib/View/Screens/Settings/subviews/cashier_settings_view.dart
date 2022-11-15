import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:smart_sales/App/Resources/screen_size.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smart_sales/View/Screens/Cashier/cashier_controller.dart';

class CashierSettingsView extends StatefulWidget {
  const CashierSettingsView({Key? key}) : super(key: key);

  @override
  State<CashierSettingsView> createState() => _CashierSettingsViewState();
}

class _CashierSettingsViewState extends State<CashierSettingsView> {
  final storage = GetStorage();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await storage.write("products_space", productSpace);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("cashier_receipt_settings".tr),
        ),
        body: Column(
          children: [
            Expanded(
              child: GetX<CashierController>(
                builder: (controller) {
                  return SettingsList(
                    contentPadding: EdgeInsets.zero,
                    platform: DevicePlatform.iOS,
                    sections: [
                      SettingsSection(tiles: [
                        SettingsTile.switchTile(
                          initialValue:
                              storage.read("show_cashier_details") ?? true,
                          onToggle: (value) {},
                          title: Text(
                            "show_cashier_details".tr,
                            style: GoogleFonts.cairo(),
                          ),
                        ),
                        SettingsTile.navigation(
                          title: Text(
                            "products_space".tr,
                            style: GoogleFonts.cairo(),
                          ),
                          trailing: Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    productSpace += 1;
                                  });
                                },
                                icon: const Icon(Icons.add),
                              ),
                              Text(productSpace.toString()),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    productSpace -= 1;
                                  });
                                },
                                icon: const Icon(Icons.remove),
                              )
                            ],
                          ),
                        )
                      ])
                    ],
                  );
                },
              ),
            ),
            ListTile(
              title: Text("cashier_receipt_spaces".tr),
              subtitle: Row(
                children: [
                  Expanded(
                    flex: productSpace < 0 ? productSpace.abs() : 1,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 1),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.blue,
                      ),
                      height: screenHeight(context) * 0.2,
                      child: Center(
                          child: AutoSizeText(
                        "categories_space".tr,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                    ),
                  ),
                  Expanded(
                    flex: productSpace > 0 ? productSpace : 1,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 1),
                      child: Center(
                          child: AutoSizeText(
                        "products_space".tr,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.blue,
                      ),
                      height: screenHeight(context) * 0.2,
                    ),
                  ),
                  Visibility(
                    visible: storage.read("show_cashier_details") ?? true,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 1),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.red,
                      ),
                      height: screenHeight(context) * 0.2,
                      width: screenWidth(context) * 0.5,
                      child: Center(
                        child: AutoSizeText(
                          "cashier_details_space".tr,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: screenSize(context).aspectRatio * 10,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
