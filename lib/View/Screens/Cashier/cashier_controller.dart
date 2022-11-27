import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:smart_sales/App/Util/routing.dart';
import 'package:smart_sales/Data/Models/cashier_settings_model.dart';
import 'package:smart_sales/Data/Models/item_model.dart';
import 'package:smart_sales/Provider/general_state.dart';
import 'package:smart_sales/Provider/powers_state.dart';
import 'package:smart_sales/View/Screens/Base/base_viewmodel.dart';
import 'package:smart_sales/View/Screens/Cashier/Widget/cashier_save_dialog.dart';
import 'package:smart_sales/View/Screens/Cashier/Widget/chashier_dialog_body.dart';
import 'package:smart_sales/View/Widgets/Common/alert_snackbar.dart';
import 'package:smart_sales/View/Widgets/Dialogs/error_dialog.dart';

class CashierController extends GetxController with BaseViewmodel {
  final selectedKindId = Rxn<int>();
  final selectedGroupId = Rxn<int>();
  final List<ItemsModel> items;
  final selectedItems = Rx<List<Map>>([]);
  final filteredItems = Rx<List<ItemsModel>>([]);
  String searchWord = '';
  final cashierSettings = Rx(
    CashierSettingsModel(
      gridCount: 2,
      productsFlex: 2,
      tileSize: 1.0,
      showCart: false,
      showOffers: true,
    ),
  );

  CashierController({
    required this.items,
  }) {
    filteredItems.value = filterItems();
    cashierSettings.value = CashierSettingsModel.fromJson(
      GetStorage().read<String>("cashier_settings") ?? "{}",
    );
  }

  void setSelectedKind({required int? input}) {
    selectedKindId.value = input;
    filteredItems.value = filterItems();
  }

  void updateShowCart({
    required bool input,
  }) {
    cashierSettings.value = cashierSettings.value.copyWith(showCart: input);
    GetStorage().write("cashier_settings", cashierSettings.toJson());
  }

  void clearSelectedItems() {
    selectedItems.value.clear();
  }

  void selectItem({required Map input, required bool value}) {
    if (value) {
      selectedItems.update(
        (val) {
          val!.add(input);
        },
      );
    } else {
      selectedItems.update(
        (val) {
          val!.remove(input);
        },
      );
    }
  }

  void setSearchWord(String input) {
    searchWord = input;
    filteredItems.value = filterItems();
  }

  void setGroupId(int? input) {
    selectedGroupId.value = input;
    filteredItems.value = filterItems();
  }

  void addCashierItem({
    required BuildContext context,
    required ItemsModel item,
    required GeneralState generalState,
    required int qty,
  }) {
    try {
      if (context.read<PowersState>().allowSellQtyLessThanZero == false &&
          item.curQty < 0) {
        showAlertSnackbar(
          context: context,
          text: "qty_error".tr,
        );
      } else {
        addNewItem(
          context: context,
          item: item,
          qty: qty,
        );
      }
      filteredItems.value = filterItems();
      Get.back();
      update();
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

  void saveChashier({
    required BuildContext context,
    required GeneralState generalState,
  }) {
    if (context.read<GeneralState>().receiptItems.isEmpty) {
      showAlertSnackbar(
        context: context,
        text: "no_items".tr,
      );
    } else {
      generalState.changeReceiptValue(
        input: {
          "cash_value": generalState.currentReceipt["oper_net_value_with_tax"],
          "saraf_cash_value": 0.0,
        },
      );
      cashierSaveDialog(
        context: context,
        body: ChashierDialogBody(
          generalState: generalState,
        ),
        onSave: () async {
          Get.back();
          EasyLoading.show();
          await onFinishOperation(
            context: context,
            doShare: false,
          );
          EasyLoading.dismiss();
          Navigator.of(context).pushNamedAndRemoveUntil(
            Routes.homeRoute,
            (route) => false,
          );
        },
        onCancel: () {
          Get.back();
        },
        onPrint: () async {
          Get.back();
          EasyLoading.show();
          await onFinishOperation(
            context: context,
            doPrint: true,
          );
          EasyLoading.dismiss();

          Navigator.of(context).pushNamedAndRemoveUntil(
            Routes.homeRoute,
            (route) => false,
          );
        },
        onShare: () async {
          Get.back();
          EasyLoading.show();
          await onFinishOperation(
            context: context,
            doShare: true,
            doPrint: true,
          );
          EasyLoading.dismiss();
          Navigator.of(context).pushNamedAndRemoveUntil(
            Routes.homeRoute,
            (route) => false,
          );
        },
      );
    }
  }
  // void addOrIncrementItem({
  //   required BuildContext context,
  //   required ItemsModel item,
  //   required GeneralState generalState,
  //   required int qty,
  // }) {
  //   try {
  //     if (context.read<PowersState>().allowSellQtyLessThanZero == false &&
  //         item.curQty < 0) {
  //       showAlertSnackbar(
  //         context: context,
  //         text: "qty_error".tr,
  //       );
  //     } else {
  //       if (generalState.receiptItems
  //           .where((element) => element["unit_id"] == item.unitId)
  //           .isEmpty) {
  //         addNewItem(
  //           context: context,
  //           item: item,
  //         );
  //       } else {
  //         final Map tempItem = generalState.receiptItems
  //             .firstWhere((element) => element["unit_id"] == item.unitId);
  //         final TextEditingController textEditingController =
  //             tempItem["fat_qty_controller"];
  //         textEditingController.text =
  //             (double.parse(tempItem["fat_qty"].toString()) + 1).toString();
  //         generalState.changeItemValue(
  //           input: {
  //             "fat_qty": double.parse(tempItem["fat_qty"].toString()) + 1
  //           },
  //           item: tempItem,
  //         );
  //       }
  //     }
  //     filteredItems.value = filterItems(
  //       input: items,
  //       searchWord: '',
  //       kindsId: null,
  //     );
  //     update();
  //   } catch (e) {
  //     log(e.toString());
  //     generalState.removeLastItem();
  //     showErrorDialog(
  //       context: context,
  //       description: e.toString(),
  //       title: "error".tr,
  //     );
  //   }
  // }

  List<ItemsModel> filterItems() {
    final List<ItemsModel> items = groupsFilter();
    if (searchWord != "") {
      if (selectedKindId.value == null) {
        return items
            .where((element) => element.itemName.contains(searchWord))
            .toList();
      } else {
        return items
            .where((element) => (element.kindId == selectedKindId.value &&
                element.itemName.contains(searchWord)))
            .toList();
      }
    } else {
      if (selectedKindId.value == null) {
        return items;
      } else {
        return items
            .where((element) => element.kindId == selectedKindId.value)
            .toList();
      }
    }
  }

  List<ItemsModel> groupsFilter() {
    if (selectedGroupId.value != null) {
      return items
          .where((element) => (element.groupId == selectedGroupId.value &&
              element.itemName.contains(searchWord)))
          .toList();
    } else {
      return items;
    }
  }
}
