import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smart_sales/App/Util/routing.dart';
import 'package:smart_sales/View/Screens/Clients/clients_screen.dart';
import 'package:smart_sales/View/Screens/Expenses/expenses_view.dart';
import 'package:smart_sales/View/Screens/Groups/groups_view.dart';
import 'package:smart_sales/View/Screens/Home/Widgets/operation_button.dart';
import 'package:smart_sales/View/Screens/Items/items_view.dart';
import 'package:smart_sales/View/Screens/Operations/operations_view.dart';
import 'package:smart_sales/View/Screens/Stors/stors_view.dart';

class InfoPage extends StatelessWidget {
  final GetStorage storage;
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
                        Get.to(() => const ItemsView(canTap: false));
                      },
                      title: "items".tr,
                      visible: storage.read("allow_view_items") ?? true,
                    ),
                    OperationButton(
                      imagePath: "assets/operations.png",
                      onPressed: () {
                        Get.to(
                          () => const OperationsView(),
                        );
                      },
                      title: "view_operations".tr,
                      visible: storage.read("allow_view_operations") ?? true,
                    ),
                    OperationButton(
                      imagePath: 'assets/clients.png',
                      onPressed: () {
                        Get.to(
                          () => const ClientsScreen(
                            canPushReplace: false,
                            sectionType: 0,
                            canTap: false,
                          ),
                        );
                      },
                      title: "clients".tr,
                      visible: storage.read("allow_view_clients") ?? true,
                    ),
                    OperationButton(
                      imagePath: "assets/stors.png",
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          Routes.storsRoute,
                          arguments: const StorsView(
                            canTap: false,
                            choosingSourceStor: false,
                            canPushReplace: false,
                          ),
                        );
                      },
                      title: "stors".tr,
                      visible: storage.read("allow_view_stors") ?? true,
                    ),
                    OperationButton(
                      imagePath: "assets/kinds.png",
                      onPressed: () {
                        Navigator.of(context).pushNamed(Routes.kindsRoute);
                      },
                      title: "kinds".tr,
                      visible: storage.read("allow_view_kinds") ?? true,
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
                      visible: storage.read("allow_view_expenses") ?? true,
                    ),
                    // OperationButton(
                    //   imagePath: "assets/mow.png",
                    //   onPressed: () {
                    //     Get.to(
                    //       () => const MowView(
                    //         canTap: false,
                    //         canPushReplace: false,
                    //       ),
                    //     );
                    //   },
                    //   title: "mows".tr,
                    //   visible: storage.read("allow_view_mows") ?? true,
                    // ),
                    OperationButton(
                      imagePath: "assets/group.png",
                      onPressed: () {
                        Get.to(
                          () => const GroupsView(),
                        );
                      },
                      title: "groups".tr,
                      visible: storage.read("allow_view_groups") ?? true,
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
