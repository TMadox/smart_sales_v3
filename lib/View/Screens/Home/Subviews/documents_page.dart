import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smart_sales/View/Screens/Clients/clients_screen.dart';
import 'package:smart_sales/View/Screens/Employees/employees_view.dart';
import 'package:smart_sales/View/Screens/Expenses/expenses_view.dart';
import 'package:smart_sales/View/Screens/Home/Widgets/operation_button.dart';

class DocumentsPage extends StatefulWidget {
  const DocumentsPage({Key? key}) : super(key: key);

  @override
  State<DocumentsPage> createState() => _DocumentsPageState();
}

class _DocumentsPageState extends State<DocumentsPage> {
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
                            imagePath: "assets/payment_document.png",
                            title: "payment_document".tr,
                            onPressed: () {
                              Get.to(
                                () => const ClientsScreen(
                                  canPushReplace: false,
                                  sectionType: 102,
                                  canTap: true,
                                ),
                              );
                            },
                            visible:
                                storage.read("allow_payment_document") ?? true,
                          ),
                          OperationButton(
                            imagePath: "assets/collection_document.png",
                            title: "seizure_document".tr,
                            onPressed: () {
                              Get.to(
                                () => const ClientsScreen(
                                  canPushReplace: false,
                                  sectionType: 101,
                                  canTap: true,
                                ),
                              );
                            },
                            visible:
                                storage.read("allow_collection_document") ??
                                    true,
                          ),
                          OperationButton(
                            imagePath: "assets/expenses_document.png",
                            title: "expenses_document".tr,
                            onPressed: () {
                              Get.to(
                                () => const ExpensesView(
                                  sectionTypeNo: 108,
                                  canTap: true,
                                ),
                              );
                            },
                            visible:
                                storage.read("allow_expenses_document") ?? true,
                          ),
                          OperationButton(
                            imagePath: "assets/expenses_seizure.png",
                            title: "expenses_seizure_document".tr,
                            onPressed: () {
                              Get.to(
                                () => const ExpensesView(
                                  sectionTypeNo: 107,
                                  canTap: true,
                                ),
                              );
                            },
                            visible: storage
                                    .read("allow_expenses_seizure_document") ??
                                true,
                          ),
                          OperationButton(
                            imagePath: "assets/give-money.png",
                            title: "employee payment document".tr,
                            onPressed: () {
                              Get.to(
                                () => const EmployeeView(
                                  sectionTypeNo: 106,
                                  canTap: true,
                                  canPushReplace: false,
                                ),
                              );
                            },
                            visible: storage
                                    .read("allow_expenses_seizure_document") ??
                                true,
                          ),
                          OperationButton(
                            imagePath: "assets/take-money.png",
                            title: "employee seizure document".tr,
                            onPressed: () {
                              Get.to(
                                () => const EmployeeView(
                                  sectionTypeNo: 105,
                                  canTap: true,
                                  canPushReplace: false,
                                ),
                              );
                            },
                            visible: storage
                                    .read("allow_expenses_seizure_document") ??
                                true,
                          ),
                          // OperationButton(
                          //   imagePath: "assets/mow_payment.png",
                          //   title: "mow_payment_document".tr,
                          //   onPressed: () {
                          //     Get.to(
                          //       () => const MowView(
                          //         canTap: true,
                          //         sectionTypeNo: 104,
                          //         canPushReplace: false,
                          //       ),
                          //     );
                          //   },
                          //   visible:
                          //       storage.read("allow_mow_payment_document") ??
                          //           true,
                          // ),
                          // OperationButton(
                          //   imagePath: "assets/mow_seizure.png",
                          //   title: "mow_seizure_document".tr,
                          //   onPressed: () {
                          //     Get.to(
                          //       () => const MowView(
                          //         canTap: true,
                          //         sectionTypeNo: 103,
                          //         canPushReplace: false,
                          //       ),
                          //     );
                          //   },
                          //   visible:
                          //       storage.read("allow_mow_seizure_document") ??
                          //           true,
                          // ),
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
