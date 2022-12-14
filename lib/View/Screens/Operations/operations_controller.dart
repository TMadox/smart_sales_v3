import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:smart_sales/Data/Database/Commands/read_data.dart';
import 'package:smart_sales/Data/Database/Commands/save_data.dart';
import 'package:smart_sales/Provider/clients_state.dart';
import 'package:smart_sales/Provider/expenses_state.dart';
import 'package:smart_sales/Provider/mow_state.dart';
import 'package:smart_sales/Provider/user_state.dart';
import 'package:smart_sales/View/Screens/Items/items_viewmodel.dart';

class OperationsController extends GetxController {
  Map currentReceipt = {"totalProducts": 0};
  List selectedItems = [];
  final Rx<List<Map>> operations = Rx<List<Map>>([]);
  List<Map> receiptItems = [];

  void loadOperations() {
    operations.value = ReadData().readOperations();
    update();
  }

  Map loadLastOperations() {
    return Map.from(json.decode(GetStorage().read("lastOperations") ?? "{}"));
  }

  Future<void> moveToRecyclePin(
      {required Map input, required BuildContext context}) async {
    List<Map> recycledOperations = ReadData().readRecylePin();
    operations.value.remove(input);
    recycledOperations.add(input);
    List<Map> products = List.from(json.decode(input["products"].toString()));
    for (var element in products) {
      element.remove("fat_qty_controller");
      element.remove("fat_disc_value_controller");
      element.remove("free_qty_controller");
      element.remove("fat_price_controller");
      context.read<ItemsViewmodel>().editItemQty(
            id: element["unit_id"],
            qty: element["fat_qty"],
            unitMulti: element["unit_convert"],
            storId: input["selected_stor_id"] ??
                context.read<UserState>().user.defStorId,
            sectionTypeNo: input["section_type_no"],
            reverse: true,
          );
    }
    switch (input["section_type_no"]) {
      case 3:
      case 4:
      case 103:
      case 104:
        await context.read<MowState>().editMows(
              id: input["basic_acc_id"],
              amount: input["reside_value"] ?? 0.0,
              sectionType: input["section_type_no"],
              reverse: true,
            );
        break;
      case 108:
      case 107:
        await context.read<ExpenseState>().editExpenses(
              id: input["basic_acc_id"] ?? 0,
              amount: input["reside_value"] ?? 0.0,
              sectionType: input["section_type_no"],
              reverse: true,
            );
        break;
      case 1:
      case 2:
      case 101:
      case 102:
      case 31:
      case 51:
        await context.read<ClientsState>().editCustomer(
              id: input["basic_acc_id"],
              amount: input["reside_value"],
              sectionType: input["section_type_no"],
              reverse: true,
            );
        break;
    }
    await SaveData().saveRecyclePin(recycledOperations: recycledOperations);
    await SaveData().saveOperationsData(operations: operations.value);
    loadOperations();
    update();
  }
}
