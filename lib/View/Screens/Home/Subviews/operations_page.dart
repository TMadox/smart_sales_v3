import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_sales/App/Util/routing.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smart_sales/View/Screens/Clients/clients_screen.dart';
import 'package:smart_sales/View/Screens/Home/Widgets/operation_button.dart';
import 'package:smart_sales/View/Screens/Mow/mow_view.dart';
import 'package:smart_sales/View/Screens/Stors/stors_view.dart';

class OperationsPage extends StatefulWidget {
  const OperationsPage({Key? key}) : super(key: key);

  @override
  State<OperationsPage> createState() => _OperationsPageState();
}

class _OperationsPageState extends State<OperationsPage> {
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
                            visible:
                                storage.read("allow_sales_receipt") ?? true,
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                "clients",
                                arguments: const ClientsScreen(
                                  canPushReplace: false,
                                  sectionType: 1,
                                  canTap: true,
                                ),
                              );
                            },
                            imagePath: "assets/sales_operation.png",
                            title: "sales_receipt".tr,
                          ),
                          OperationButton(
                            visible:
                                storage.read("allow_return_receipt") ?? true,
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                "clients",
                                arguments: const ClientsScreen(
                                  canPushReplace: false,
                                  sectionType: 2,
                                  canTap: true,
                                ),
                              );
                            },
                            imagePath: "assets/return_operation.png",
                            title: "return_receipt".tr,
                          ),
                          OperationButton(
                            visible:
                                storage.read("allow_order_receipt") ?? true,
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                "clients",
                                arguments: const ClientsScreen(
                                  canPushReplace: false,
                                  sectionType: 17,
                                  canTap: true,
                                ),
                              );
                            },
                            imagePath: "assets/order.png",
                            title: "selling_order".tr,
                          ),
                          OperationButton(
                            visible:
                                storage.read("allow_purchase_receipt") ?? true,
                            onPressed: () {
                              Get.to(
                                () => const MowView(
                                  canTap: true,
                                  sectionTypeNo: 3,
                                  canPushReplace: false,
                                ),
                              );
                            },
                            imagePath: "assets/purchase_receipt.png",
                            title: "purchase_receipt".tr,
                          ),
                          OperationButton(
                            visible:
                                storage.read("allow_purchase_return_receipt") ??
                                    true,
                            onPressed: () {
                              Get.to(
                                () => const MowView(
                                  canTap: true,
                                  sectionTypeNo: 4,
                                  canPushReplace: false,
                                ),
                              );
                            },
                            imagePath: "assets/purchase_return_receipt.png",
                            title: "purchase_return_receipt".tr,
                          ),
                          OperationButton(
                            visible:
                                storage.read("allow_cashier_receipt") ?? true,
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                "clients",
                                arguments: const ClientsScreen(
                                  canPushReplace: false,
                                  sectionType: 31,
                                  canTap: true,
                                ),
                              );
                            },
                            imagePath: "assets/cashier_receipt.png",
                            title: "cashier_receipt".tr,
                          ),
                          OperationButton(
                            imagePath: "assets/puchase_order.png",
                            title: "purchase_order".tr,
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                "clients",
                                arguments: const ClientsScreen(
                                  canPushReplace: false,
                                  sectionType: 18,
                                  canTap: true,
                                ),
                              );
                            },
                            visible:
                                storage.read("allow_purchase_order") ?? true,
                          ),
                          OperationButton(
                            imagePath: "assets/stor_transfer.png",
                            title: "stor_transfer".tr,
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                Routes.storsRoute,
                                arguments: const StorsView(
                                  canTap: true,
                                  choosingSourceStor: false,
                                  canPushReplace: false,
                                ),
                              );
                            },
                            visible:
                                storage.read("allow_stor_transfer") ?? true,
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
