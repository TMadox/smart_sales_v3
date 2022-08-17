import 'package:auto_size_text/auto_size_text.dart';
import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_sales/App/Resources/screen_size.dart';
import 'package:smart_sales/App/Util/routing.dart';
import 'package:smart_sales/View/Screens/Clients/clients_screen.dart';
import 'package:smart_sales/View/Screens/Expenses/expenses_view.dart';
import 'package:smart_sales/View/Screens/Groups/groups_view.dart';
import 'package:smart_sales/View/Screens/Home/Widgets/operation_button.dart';
import 'package:smart_sales/View/Screens/Mow/mow_view.dart';
import 'package:smart_sales/View/Screens/Stors/stors_view.dart';

class InfoPage extends StatelessWidget {
  final SharedPreferences storage;
  const InfoPage({
    Key? key,
    required this.storage,
  }) : super(key: key);

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
            return Center(
              child: SizedBox(
                width: constrains.maxWidth * 0.89,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  runSpacing: constrains.maxHeight * 0.02,
                  spacing: constrains.maxWidth * 0.02,
                  children: [
                    OperationButton(
                      imagePath: "assets/products.png",
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(Routes.itemsRoute, arguments: false);
                      },
                      title: "items".tr,
                      visible: storage.getBool("allow_view_items") ?? true,
                    ),
                    OperationButton(
                      imagePath: "assets/operations.png",
                      onPressed: () {
                        Navigator.of(context).pushNamed("reciepts");
                      },
                      title: "view_operations".tr,
                      visible: storage.getBool("allow_view_operations") ?? true,
                    ),
                    OperationButton(
                      imagePath: 'assets/clients.png',
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          "clients",
                          arguments: const ClientsScreen(
                            canPushReplace: false,
                            sectionType: 0,
                            canTap: false,
                          ),
                        );
                      },
                      title: "clients".tr,
                      visible: storage.getBool("allow_view_clients") ?? true,
                    ),
                    OperationButton(
                      imagePath: "assets/stors.png",
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          Routes.storsRoute,
                          arguments: const StorsView(
                            canTap: false,
                            choosingReceivingStor: false,
                            canPushReplace: false,
                          ),
                        );
                      },
                      title: "stors".tr,
                      visible: storage.getBool("allow_view_stors") ?? true,
                    ),
                    OperationButton(
                      imagePath: "assets/kinds.png",
                      onPressed: () {
                        Navigator.of(context).pushNamed(Routes.kindsRoute);
                      },
                      title: "kinds".tr,
                      visible: storage.getBool("allow_view_kinds") ?? true,
                    ),
                    OperationButton(
                      imagePath: "assets/expenses.png",
                      onPressed: () {
                        Get.to(
                          () => const ExpensesView(
                            sectionTypeNo: 108,
                            canTap: false,
                          ),
                        );
                      },
                      title: "expenses".tr,
                      visible: storage.getBool("allow_view_expenses") ?? true,
                    ),
                    OperationButton(
                      imagePath: "assets/mow.png",
                      onPressed: () {
                        Get.to(
                          () => const MowView(
                            canTap: false,
                            canPushReplace: false,
                          ),
                        );
                      },
                      title: "mows".tr,
                      visible: storage.getBool("allow_view_mows") ?? true,
                    ),
                    OperationButton(
                      imagePath: "assets/group.png",
                      onPressed: () {
                        Get.to(
                          () => const GroupsView(),
                        );
                      },
                      title: "groups".tr,
                      visible: storage.getBool("allow_view_groups") ?? true,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
