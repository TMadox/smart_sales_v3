import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:smart_sales/App/Util/locator.dart';
import 'package:smart_sales/Data/Database/Commands/read_data.dart';
import 'package:smart_sales/Data/Models/client.dart';
import 'package:smart_sales/Data/Models/item_model.dart';
import 'package:smart_sales/Data/Models/options_model.dart';
import 'package:smart_sales/Provider/clients_state.dart';
import 'package:smart_sales/Provider/options_state.dart';
import 'package:smart_sales/Provider/user_state.dart';
import 'package:smart_sales/Services/Helpers/exceptions.dart';
import 'package:smart_sales/Services/Repositories/delete_repo.dart';
import 'package:smart_sales/Services/Repositories/request_allowance_repo.dart';
import 'package:smart_sales/View/Common/Widgets/Dialogs/error_dialog.dart';
import 'package:smart_sales/View/Common/Widgets/Dialogs/general_snackbar.dart';
import 'package:smart_sales/View/Screens/Items/items_viewmodel.dart';

class HomeController {
  compare(
    List<ItemsModel> items,
    List<Client> customers,
    BuildContext context,
  ) {
    final currentCustomers = context.read<ClientsState>().clients;
    final currentItems = context.read<ItemsViewmodel>().items;
    for (var newItem in items) {
      if (currentItems
          .where((currentItem) => currentItem.unitId == newItem.unitId)
          .isEmpty) {
        currentItems.add(newItem);
      } else {
        ItemsModel matchingItem = currentItems
            .firstWhere((element) => element.unitId == newItem.unitId);
        if (matchingItem.itemName != newItem.itemName) {
          int index = currentItems.indexOf(matchingItem);
          currentItems[index].itemName = newItem.itemName;
        }
      }
    }
    for (var newCustomer in customers) {
      if (currentCustomers
          .where(
              (currentCustomer) => currentCustomer.accId == newCustomer.accId)
          .isEmpty) {
        currentCustomers.add(newCustomer);
      }
    }
  }

  Future<void> updateItemsNclients({required BuildContext context}) async {
    try {
      EasyLoading.show();
      final user = context.read<UserState>().user;
      final OptionsModel transAllStors = context
          .read<OptionsState>()
          .options
          .firstWhere((option) => option.optionId == 6);
      final OptionsModel transAllAm = context
          .read<OptionsState>()
          .options
          .firstWhere((option) => option.optionId == 5);
      compare(
        itemsListFromJson(
          input: await context.read<ItemsViewmodel>().fetchItems(
                user: user,
                transAllStors: transAllStors.optionValue == 1,
              ),
        ),
        customersListFromJson(
          input: await context.read<ClientsState>().fetchClients(
                transAllAm: transAllAm.optionValue == 1,
                user: user,
              ),
        ),
        context,
      );
      await context.read<ItemsViewmodel>().saveItems();
      await context.read<ClientsState>().saveClients();
      EasyLoading.dismiss();
      responseSnackbar(context, "update_successful".tr);
    } catch (e) {
      Get.back();
      if (e is DioError) {
        String message = DioExceptions.fromDioError(e).toString();
        showErrorDialog(
          context: context,
          description: message,
          title: "error".tr,
        );
      } else {
        showErrorDialog(
          context: context,
          description: e.toString(),
          title: "error".tr,
        );
      }
    }
  }

  Future<void> getNewItemsNclients(BuildContext context) async {
    try {
      final List<Map> operations = ReadData().readOperations();
      EasyLoading.show();
      final user = context.read<UserState>().user;
      if (operations.isNotEmpty) {
        showErrorDialog(
          context: context,
          title: "error".tr,
          description: "operations_not_uploaded_yet".tr,
        );
      } else {
        await context.read<ItemsViewmodel>().reloadItems(
              context: context,
              user: user,
            );
        await context.read<ClientsState>().reloadClients(
              context: context,
              user: user,
            );
        responseSnackbar(
          context,
          "reload_successful".tr,
        );
      }
    } catch (e) {
      if (e is DioError) {
        String message = DioExceptions.fromDioError(e).toString();
        showErrorDialog(
          context: context,
          description: message,
          title: "error".tr,
        );
      } else {
        e.printInfo();
        showErrorDialog(
          context: context,
          description: e.toString(),
          title: "error".tr,
        );
      }
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> newRequest(BuildContext context) async {
    final List<Map> operations = ReadData().readOperations();
    try {
      if (operations.isNotEmpty &&
          operations
              .where((element) => element["is_sender_complete_status"] == 0)
              .isNotEmpty) {
        showErrorDialog(
          context: context,
          title: "error".tr,
          description: "operations_not_uploaded_yet".tr,
        );
      } else {
        if (await locator.get<DeleteRepo>().requestDeleteRepo(
              context: context,
              operations: operations,
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
}
