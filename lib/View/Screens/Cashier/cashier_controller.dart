import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:smart_sales/Data/Models/item_model.dart';
import 'package:smart_sales/Provider/general_state.dart';
import 'package:smart_sales/Provider/powers_state.dart';
import 'package:smart_sales/View/Screens/Base/base_viewmodel.dart';
import 'package:smart_sales/View/Widgets/Common/alert_snackbar.dart';
import 'package:smart_sales/View/Widgets/Dialogs/error_dialog.dart';

class CashierController extends GetxController with BaseViewmodel {
  final selectedKindId = 0.obs;
  final List<ItemsModel> items;
  final filteredItems = Rx<List<ItemsModel>>([]);
  String searchWord = '';

  CashierController({
    required this.items,
  }) {
    filteredItems.value = filterItems(
      input: items,
      kindsId: selectedKindId.value,
      searchWord: searchWord,
    );
  }

  void setSelectedKind({required int input}) {
    selectedKindId.value = input;
    filteredItems.value = filterItems(
      input: items,
      kindsId: selectedKindId.value,
      searchWord: searchWord,
    );
  }

  void setSearchWord(String input) {
    searchWord = input;
    filteredItems.value = filterItems(
      input: items,
      kindsId: selectedKindId.value,
      searchWord: searchWord,
    );
  }

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
      filteredItems.value = filterItems(
        input: items,
        searchWord: '',
        kindsId: null,
      );
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
    required int? kindsId,
    required String searchWord,
  }) {
    final List<ItemsModel> items = input;
    if (searchWord != "") {
      if (kindsId == null) {
        return input
            .where((element) => element.itemName.contains(searchWord))
            .toList();
      } else {
        return items
            .where((element) => (element.kindId == kindsId &&
                element.itemName.contains(searchWord)))
            .toList();
      }
    } else {
      if (kindsId == null) {
        return input;
      } else {
        return items.where((element) => element.kindId == kindsId).toList();
      }
    }
  }
}
