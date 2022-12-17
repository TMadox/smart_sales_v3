import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:smart_sales/App/Resources/screen_size.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smart_sales/Data/Models/cashier_settings_model.dart';

class CashierSettingsView extends StatefulWidget {
  const CashierSettingsView({Key? key}) : super(key: key);

  @override
  State<CashierSettingsView> createState() => _CashierSettingsViewState();
}

class _CashierSettingsViewState extends State<CashierSettingsView> {
  final storage = GetStorage();
  late CashierSettingsModel cashierSettings;
  @override
  void initState() {
    cashierSettings = CashierSettingsModel.fromJson(
      storage.read("cashier_settings") ?? "{}",
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        GetStorage().write("cashier_settings", cashierSettings.toJson());
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("cashier_receipt_settings".tr),
        ),
        body: Column(
          children: [
            Expanded(
              child: SettingsList(
                contentPadding: EdgeInsets.zero,
                platform: DevicePlatform.iOS,
                sections: [
                  SettingsSection(
                    tiles: [
                      SettingsTile.switchTile(
                        initialValue: cashierSettings.showCart,
                        onToggle: (value) {
                          setState(() {
                            cashierSettings =
                                cashierSettings.copyWith(showCart: value);
                          });
                        },
                        title: Text(
                          "show_cashier_details".tr,
                          style: GoogleFonts.cairo(),
                        ),
                      ),
                      SettingsTile.switchTile(
                        initialValue: cashierSettings.showOffers,
                        onToggle: (value) {
                          setState(() {
                            cashierSettings =
                                cashierSettings.copyWith(showOffers: value);
                          });
                        },
                        title: Text(
                          "show offers".tr,
                          style: GoogleFonts.cairo(),
                        ),
                      ),
                      SettingsTile.navigation(
                        title: Text(
                          "products grid count".tr,
                          style: GoogleFonts.cairo(),
                        ),
                        trailing: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  cashierSettings = cashierSettings.copyWith(
                                      gridCount: (cashierSettings.gridCount + 1)
                                          .clamp(1, 4));
                                });
                              },
                              icon: const Icon(Icons.add),
                            ),
                            Text(cashierSettings.gridCount.toString()),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  cashierSettings = cashierSettings.copyWith(
                                      gridCount: (cashierSettings.gridCount - 1)
                                          .clamp(1, 4));
                                });
                              },
                              icon: const Icon(Icons.remove),
                            )
                          ],
                        ),
                      ),
                      SettingsTile.navigation(
                        title: Text(
                          "product tile height".tr +
                              " (" +
                              "default length is 1".tr +
                              ")",
                          style: GoogleFonts.cairo(),
                        ),
                        trailing: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(
                                  () {
                                    cashierSettings = cashierSettings.copyWith(
                                        tileSize:
                                            (cashierSettings.tileSize - 0.1)
                                                .clamp(0.1, 4));
                                  },
                                );
                              },
                              icon: const Icon(Icons.add),
                            ),
                            Text(
                              (4 - cashierSettings.tileSize).toStringAsFixed(1),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(
                                  () {
                                    cashierSettings = cashierSettings.copyWith(
                                        tileSize:
                                            (cashierSettings.tileSize + 0.1)
                                                .clamp(0.1, 4));
                                  },
                                );
                              },
                              icon: const Icon(Icons.remove),
                            )
                          ],
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
                                setState(
                                  () {
                                    cashierSettings = cashierSettings.copyWith(
                                      productsFlex:
                                          (cashierSettings.productsFlex + 1)
                                              .clamp(-4, 4),
                                    );
                                  },
                                );
                              },
                              icon: const Icon(Icons.add),
                            ),
                            Text(
                              cashierSettings.productsFlex.toString(),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(
                                  () {
                                    cashierSettings = cashierSettings.copyWith(
                                      productsFlex:
                                          (cashierSettings.productsFlex - 1)
                                              .clamp(-4, 4),
                                    );
                                  },
                                );
                              },
                              icon: const Icon(Icons.remove),
                            )
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            ListTile(
              title: Text("cashier_receipt_spaces".tr),
              subtitle: Row(
                children: [
                  Container(
                    width: screenWidth(context) * 0.2,
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
                  Expanded(
                    flex: cashierSettings.productsFlex > 0
                        ? cashierSettings.productsFlex
                        : 1,
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
                    visible:
                        !cashierSettings.showCart && cashierSettings.showOffers,
                    child: Expanded(
                      flex: cashierSettings.productsFlex < 0
                          ? cashierSettings.productsFlex.abs()
                          : 1,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 1),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.blue,
                        ),
                        height: screenHeight(context) * 0.2,
                        child: Center(
                            child: AutoSizeText(
                          "offers".tr,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: cashierSettings.showCart,
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
