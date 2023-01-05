import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:smart_sales/Data/Database/Commands/read_data.dart';
import 'package:smart_sales/Data/Database/Commands/save_data.dart';
import 'package:smart_sales/Provider/clients_state.dart';
import 'package:smart_sales/Provider/expenses_state.dart';
import 'package:smart_sales/Provider/mow_state.dart';
import 'package:smart_sales/Provider/user_state.dart';
import 'package:smart_sales/View/Screens/Items/items_viewmodel.dart';

class RecycleController extends GetxController {
  final Rx<List<Map>> recycledOperations = Rx<List<Map>>([]);
  void loadOperations() {
    recycledOperations.value = ReadData().readRecylePin();
  }

  Future<void> moveFromRecycleBin(
      {required Map input, required BuildContext context}) async {
    List<Map> operations = ReadData().readOperations();
    recycledOperations.value.remove(input);
    update();
    operations.add(input);
    List<Map> products = List.from(json.decode(input["products"]));
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
            );
        break;
      case 108:
      case 107:
        await context.read<ExpenseState>().editExpenses(
              id: input["basic_acc_id"] ?? 0,
              amount: input["reside_value"] ?? 0.0,
              sectionType: input["section_type_no"],
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
            );
        break;
    }
    await SaveData()
        .saveRecyclePin(recycledOperations: recycledOperations.value);
    await SaveData().saveOperationsData(operations: operations);
  }
}
