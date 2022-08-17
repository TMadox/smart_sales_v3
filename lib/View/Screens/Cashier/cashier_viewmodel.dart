import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:smart_sales/Data/Models/item_model.dart';
import 'package:smart_sales/Data/Models/kinds_model.dart';
import 'package:smart_sales/Provider/general_state.dart';
import 'package:smart_sales/Provider/powers_state.dart';
import 'package:smart_sales/View/Screens/Base/base_viewmodel.dart';
import 'package:smart_sales/View/Widgets/Common/alert_snackbar.dart';
import 'package:smart_sales/View/Widgets/Dialogs/error_dialog.dart';

class CashierViewmodel extends BaseViewmodel {
  void addOrIncrementItem({
    required BuildContext context,
    required ItemsModel item,
    required GeneralState generalState,
  }) {
    try {
      if (context.read<PowersState>().allowSellQtyLessThanZero == false &&
          item.curQty < 0) {
        showAlertSnackbar(
          context: context,
          text: "qty_error".tr,
        );
      } else {
        if (generalState.receiptItems
            .where((element) => element["unit_id"] == item.unitId)
            .isEmpty) {
          addNewItem(
            context: context,
            item: item,
          );
        } else {
          final Map tempItem = generalState.receiptItems
              .firstWhere((element) => element["unit_id"] == item.unitId);
          final TextEditingController textEditingController =
              tempItem["fat_qty_controller"];
          textEditingController.text =
              (double.parse(tempItem["fat_qty"].toString()) + 1).toString();
          generalState.changeItemValue(
            input: {
              "fat_qty": double.parse(tempItem["fat_qty"].toString()) + 1
            },
            item: tempItem,
          );
        }
      }
    } catch (e) {
      log(e.toString());
      generalState.removeLastItem();
      showErrorDialog(
        context: context,
        description: e.toString(),
        title: "error".tr,
      );
    }
  }

  List<ItemsModel> filterItems({
    required List<ItemsModel> input,
    required KindsModel? kindsModel,
    required String searchWord,
  }) {
    final List<ItemsModel> items = input;
    if (searchWord != "") {
      if (kindsModel == null) {
        return input
            .where((element) => element.itemName.contains(searchWord))
            .toList();
      } else {
        return items
            .where((element) => (element.kindId == kindsModel.kindId &&
                element.itemName.contains(searchWord)))
            .toList();
      }
    } else {
      if (kindsModel == null) {
        return input;
      } else {
        return items
            .where((element) => element.kindId == kindsModel.kindId)
            .toList();
      }
    }
  }
}
