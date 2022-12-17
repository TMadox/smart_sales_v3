import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smart_sales/App/Util/routing.dart';
import 'package:smart_sales/View/Screens/Clients/clients_screen.dart';
import 'package:smart_sales/View/Screens/Expenses/expenses_view.dart';
import 'package:smart_sales/View/Screens/Groups/groups_view.dart';
import 'package:smart_sales/View/Screens/Home/Widgets/operation_button.dart';
import 'package:smart_sales/View/Screens/Items/items_view.dart';
import 'package:smart_sales/View/Screens/Mow/mow_view.dart';
import 'package:smart_sales/View/Screens/Register/register_view.dart';
import 'package:smart_sales/View/Screens/Stors/stors_view.dart';

Widget selectWidget({
  required String type,
  required BuildContext context,
  required GetStorage storage,
}) {
  switch (type) {
    case "sales_receipt":
      {
        return OperationButton(
          imagePath: "assets/sales_operation.png",
          title: "sales_receipt".tr,
          onPressed: () {
            Get.to(
              () => const ClientsScreen(
                canPushReplace: false,
                sectionType: 1,
                canTap: true,
              ),
            );
          },
          visible: storage.read("allow_sales_receipt") ?? true,
        );
      }

    case "return_receipt":
      {
        return OperationButton(
          imagePath: "assets/return_operation.png",
          title: "return_receipt".tr,
          onPressed: () {
            Get.to(
              () => const ClientsScreen(
                canPushReplace: false,
                sectionType: 2,
                canTap: true,
              ),
            );
          },
          visible: storage.read("allow_return_receipt") ?? true,
        );
      }
    case "purchase_receipt":
      {
        return OperationButton(
          imagePath: "assets/purchase_receipt.png",
          title: "purchase_receipt".tr,
          onPressed: () {
            Get.to(
              () => const MowView(
                canTap: true,
                sectionTypeNo: 3,
                canPushReplace: false,
              ),
            );
          },
          visible: storage.read("allow_purchase_receipt") ?? true,
        );
      }
    case "purchase_return_receipt":
      {
        return OperationButton(
          imagePath: "assets/purchase_return_receipt.png",
          title: "purchase_return_receipt".tr,
          onPressed: () {
            Get.to(
              () => const MowView(
                canTap: true,
                sectionTypeNo: 4,
                canPushReplace: false,
              ),
            );
          },
          visible: storage.read("allow_purchase_return_receipt") ?? true,
        );
      }
    case "selling_order":
      {
        return OperationButton(
          imagePath: "assets/order.png",
          title: "selling_order".tr,
          onPressed: () {
            Get.to(
              () => const ClientsScreen(
                canPushReplace: false,
                sectionType: 17,
                canTap: true,
              ),
            );
          },
          visible: storage.read("allow_order_receipt") ?? true,
        );
      }
    case "purchase_order":
      {
        return OperationButton(
          imagePath: "assets/puchase_order.png",
          title: "purchase_order".tr,
          onPressed: () {
            Get.to(
              () => const ClientsScreen(
                canPushReplace: false,
                sectionType: 18,
                canTap: true,
              ),
            );
          },
          visible: storage.read("allow_purchase_order") ?? true,
        );
      }
    case "seizure_document":
      {
        return OperationButton(
          imagePath: "assets/collection_document.png",
          title: "seizure_document".tr,
          onPressed: () {
            // context
            //     .read<DocumentsViewmodel>()
            //     .setSelectedCustomer(input: ClientsModel());

            Get.to(
              () => const ClientsScreen(
                canPushReplace: false,
                sectionType: 101,
                canTap: true,
              ),
            );
            // Navigator.of(context).pushNamed(
            //   "salesReciepts",
            //   arguments: [false, 101],
            // );
          },
          visible: storage.read("allow_collection_document") ?? true,
        );
      }
    case "payment_document":
      {
        return OperationButton(
          imagePath: "assets/payment_document.png",
          title: "payment_document".tr,
          onPressed: () {
            // context
            //     .read<DocumentsViewmodel>()
            //     .setSelectedCustomer(input: ClientsModel());
            Get.to(
              () => const ClientsScreen(
                canPushReplace: false,
                sectionType: 102,
                canTap: true,
              ),
            );
          },
          visible: storage.read("allow_payment_document") ?? true,
        );
      }
    case "mow_seizure_document":
      {
        return OperationButton(
          imagePath: "assets/mow_seizure.png",
          title: "mow_seizure_document".tr,
          onPressed: () {
            Get.to(
              () => const MowView(
                canTap: true,
                sectionTypeNo: 103,
                canPushReplace: false,
              ),
            );
          },
          visible: storage.read("allow_mow_seizure_document") ?? true,
        );
      }
    case "mow_payment_document":
      {
        return OperationButton(
          imagePath: "assets/mow_payment.png",
          title: "mow_payment_document".tr,
          onPressed: () {
            Get.to(
              () => const MowView(
                canTap: true,
                sectionTypeNo: 104,
                canPushReplace: false,
              ),
            );
          },
          visible: storage.read("allow_mow_payment_document") ?? true,
        );
      }
    case "expenses_seizure_document":
      {
        return OperationButton(
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
          visible: storage.read("allow_expenses_seizure_document") ?? true,
        );
      }
    case "inventory":
      {
        return OperationButton(
          imagePath: "assets/gard.png",
          title: "inventory".tr,
          onPressed: () {
            Navigator.of(context).pushNamed(
              Routes.inventoryRoute,
            );
          },
          visible: storage.read("allow_inventory_receipt") ?? true,
        );
      }
    case "cashier_receipt":
      {
        return OperationButton(
          imagePath: "assets/cashier_receipt.png",
          title: "cashier_receipt".tr,
          onPressed: () {
            Get.to(
              () => const ClientsScreen(
                canPushReplace: false,
                sectionType: 31,
                canTap: true,
              ),
            );
          },
          visible: storage.read("allow_cashier_receipt") ?? true,
        );
      }
    case "expenses_document":
      {
        return OperationButton(
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
          visible: storage.read("allow_expenses_document") ?? true,
        );
      }
    case "items":
      {
        return OperationButton(
          imagePath: "assets/products.png",
          title: "items".tr,
          onPressed: () {
            Get.to(() => const ItemsView(canTap: false));
          },
          visible: storage.read("allow_view_items") ?? true,
        );
      }
    case "view_operations":
      {
        return OperationButton(
          imagePath: "assets/operations.png",
          title: "view_operations".tr,
          onPressed: () {
            Navigator.of(context).pushNamed("reciepts");
          },
          visible: storage.read("allow_view_operations") ?? true,
        );
      }
    case "clients":
      {
        return OperationButton(
          imagePath: "assets/clients.png",
          title: "clients".tr,
          onPressed: () {
            Get.to(
              () => const ClientsScreen(
                canPushReplace: false,
                sectionType: 1,
                canTap: false,
              ),
            );
          },
          visible: storage.read("allow_view_clients") ?? true,
        );
      }
    case "stors":
      {
        return OperationButton(
          imagePath: "assets/stors.png",
          title: "stors".tr,
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
          visible: storage.read("allow_view_stors") ?? true,
        );
      }
    case "stor_transfer":
      {
        return OperationButton(
          imagePath: "assets/stor_transfer.png",
          title: "stors".tr,
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
          visible: storage.read("allow_stor_transfer") ?? true,
        );
      }
    case "kinds":
      {
        return OperationButton(
          imagePath: "assets/kinds.png",
          title: "kinds".tr,
          onPressed: () {
            Navigator.of(context).pushNamed(Routes.kindsRoute);
          },
          visible: storage.read("allow_view_kinds") ?? true,
        );
      }
    case "expenses":
      {
        return OperationButton(
          imagePath: "assets/expenses.png",
          title: "expenses".tr,
          onPressed: () {
            Get.to(
              () => const ExpensesView(
                sectionTypeNo: 108,
                canTap: false,
              ),
            );
          },
          visible: storage.read("allow_view_expenses") ?? true,
        );
      }
    case "mows":
      {
        return OperationButton(
          imagePath: "assets/mow.png",
          title: "mows".tr,
          onPressed: () {
            Get.to(
              () => const MowView(
                canTap: false,
                canPushReplace: false,
                sectionTypeNo: 0,
              ),
            );
          },
          visible: storage.read("allow_view_mows") ?? true,
        );
      }
    case "groups":
      {
        return OperationButton(
          imagePath: "assets/group.png",
          title: "groups".tr,
          onPressed: () {
            Get.to(
              () => const GroupsView(),
            );
          },
          visible: storage.read("allow_view_groups") ?? true,
        );
      }
    case "new_rec":
      {
        return OperationButton(
          imagePath: "assets/new_rec.png",
          title: "new_rec".tr,
          onPressed: () {
            Get.to(
              () => const RegisterView(),
            );
          },
          visible: storage.read("allow_new_rec") ?? true,
        );
      }
    default:
      return Text(type);
  }
}
