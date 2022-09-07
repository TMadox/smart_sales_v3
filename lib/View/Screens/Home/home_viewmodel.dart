import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_sales/App/Util/locator.dart';
import 'package:smart_sales/App/Util/routing.dart';
import 'package:smart_sales/Data/Models/client_model.dart';
import 'package:smart_sales/Provider/general_state.dart';
import 'package:smart_sales/Services/Helpers/exceptions.dart';
import 'package:smart_sales/Services/Repositories/delete_repo.dart';
import 'package:smart_sales/Services/Repositories/request_allowance_repo.dart';
import 'package:smart_sales/View/Screens/Base/base_viewmodel.dart';
import 'package:smart_sales/View/Screens/Clients/clients_screen.dart';
import 'package:smart_sales/View/Screens/Documents/document_viewmodel.dart';
import 'package:smart_sales/View/Screens/Expenses/expenses_view.dart';
import 'package:smart_sales/View/Screens/Groups/groups_view.dart';
import 'package:smart_sales/View/Screens/Home/Widgets/operation_button.dart';
import 'package:smart_sales/View/Screens/Inventory/inventory_viewmodel.dart';
import 'package:smart_sales/View/Screens/Mow/mow_view.dart';
import 'package:smart_sales/View/Screens/Register/register_view.dart';
import 'package:smart_sales/View/Screens/Stors/stors_view.dart';
import 'package:smart_sales/View/Widgets/Dialogs/error_dialog.dart';
import 'package:smart_sales/View/Widgets/Dialogs/general_snackbar.dart';
import 'package:provider/provider.dart';

class HomeViewmodel extends ChangeNotifier with BaseViewmodel {
  Future<void> newRequest(BuildContext context) async {
    try {
      if (context.read<GeneralState>().receiptsList.isNotEmpty &&
          context
              .read<GeneralState>()
              .receiptsList
              .where((element) => element["is_sender_complete_status"] == 0.0)
              .isNotEmpty) {
        showErrorDialog(
          context: context,
          title: "error".tr,
          description: "operations_not_uploaded_yet".tr,
        );
      } else {
        if (await locator.get<DeleteRepo>().requestDeleteRepo(
              context: context,
            )) {
          throw "operations_not_exported_yet".tr;
        }
        await locator.get<RequestAllowanceRepo>().requestAllowance(context);
        responseSnackbar(
          context,
          "operations_removed_request_made".tr,
        );
      }
    } catch (e) {
      log(e.toString());
      if (e is DioError) {
        String message = DioExceptions.fromDioError(e).toString();
        showErrorDialog(
            context: context, description: message, title: "error".tr);
      } else {
        showErrorDialog(
            context: context, description: e.toString(), title: "error".tr);
      }
    }
  }

  Widget selectWidget({
    required String type,
    required BuildContext context,
    required SharedPreferences storage,
  }) {
    switch (type) {
      case "sales_receipt":
        {
          return OperationButton(
            imagePath: "assets/sales_operation.png",
            title: "sales_receipt".tr,
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
            visible: storage.getBool("allow_sales_receipt") ?? true,
          );
        }

      case "return_receipt":
        {
          return OperationButton(
            imagePath: "assets/return_operation.png",
            title: "return_receipt".tr,
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
            visible: storage.getBool("allow_return_receipt") ?? true,
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
            visible: storage.getBool("allow_purchase_receipt") ?? true,
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
            visible: storage.getBool("allow_purchase_return_receipt") ?? true,
          );
        }
      case "selling_order":
        {
          return OperationButton(
            imagePath: "assets/order.png",
            title: "selling_order".tr,
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
            visible: storage.getBool("allow_order_receipt") ?? true,
          );
        }
      case "purchase_order":
        {
          return OperationButton(
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
            visible: storage.getBool("allow_purchase_order") ?? true,
          );
        }
      case "seizure_document":
        {
          return OperationButton(
            imagePath: "assets/collection_document.png",
            title: "seizure_document".tr,
            onPressed: () {
              context
                  .read<DocumentsViewmodel>()
                  .setSelectedCustomer(input: ClientsModel());
              Navigator.of(context).pushNamed(
                "clients",
                arguments: const ClientsScreen(
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
            visible: storage.getBool("allow_collection_document") ?? true,
          );
        }
      case "payment_document":
        {
          return OperationButton(
            imagePath: "assets/payment_document.png",
            title: "payment_document".tr,
            onPressed: () {
              context
                  .read<DocumentsViewmodel>()
                  .setSelectedCustomer(input: ClientsModel());
              Navigator.of(context).pushNamed(
                "clients",
                arguments: const ClientsScreen(
                  canPushReplace: false,
                  sectionType: 102,
                  canTap: true,
                ),
              );
            },
            visible: storage.getBool("allow_payment_document") ?? true,
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
            visible: storage.getBool("allow_mow_seizure_document") ?? true,
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
            visible: storage.getBool("allow_mow_payment_document") ?? true,
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
            visible: storage.getBool("allow_expenses_seizure_document") ?? true,
          );
        }
      case "inventory":
        {
          return OperationButton(
            imagePath: "assets/gard.png",
            title: "inventory".tr,
            onPressed: () {
              context.read<InventoryViewmodel>().newInventoryDocument(context);
              Navigator.of(context).pushNamed(
                Routes.inventoryRoute,
              );
            },
            visible: storage.getBool("allow_inventory_receipt") ?? true,
          );
        }
      case "cashier_receipt":
        {
          return OperationButton(
            imagePath: "assets/cashier_receipt.png",
            title: "cashier_receipt".tr,
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
            visible: storage.getBool("allow_cashier_receipt") ?? true,
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
            visible: storage.getBool("allow_expenses_document") ?? true,
          );
        }
      case "items":
        {
          return OperationButton(
            imagePath: "assets/products.png",
            title: "items".tr,
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(Routes.itemsRoute, arguments: false);
            },
            visible: storage.getBool("allow_view_items") ?? true,
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
            visible: storage.getBool("allow_view_operations") ?? true,
          );
        }
      case "clients":
        {
          return OperationButton(
            imagePath: "assets/clients.png",
            title: "clients".tr,
            onPressed: () {
              Navigator.of(context).pushNamed("clients");
            },
            visible: storage.getBool("allow_view_clients") ?? true,
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
                  choosingReceivingStor: false,
                  canPushReplace: false,
                ),
              );
            },
            visible: storage.getBool("allow_view_stors") ?? true,
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
                  choosingReceivingStor: false,
                  canPushReplace: false,
                ),
              );
            },
            visible: storage.getBool("allow_stor_transfer") ?? true,
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
            visible: storage.getBool("allow_view_kinds") ?? true,
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
            visible: storage.getBool("allow_view_expenses") ?? true,
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
                ),
              );
            },
            visible: storage.getBool("allow_view_mows") ?? true,
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
            visible: storage.getBool("allow_view_groups") ?? true,
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
            visible: storage.getBool("allow_new_rec") ?? true,
          );
        }
      default:
        return Text(type);
    }
  }
}
