import 'dart:developer';
import 'package:auto_size_text/auto_size_text.dart';
// ignore: implementation_imports
import 'package:collection/src/iterable_extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_sales/App/Resources/screen_size.dart';
import 'package:smart_sales/App/Resources/values_manager.dart';
import 'package:smart_sales/Data/Models/item_model.dart';
import 'package:provider/provider.dart';
import 'package:smart_sales/Provider/powers_state.dart';
import 'package:smart_sales/View/Screens/Items/items_viewmodel.dart';
import 'package:smart_sales/View/Common/Widgets/Common/alert_snackbar.dart';
import 'package:smart_sales/View/Common/Widgets/Dialogs/error_dialog.dart';
import 'package:smart_sales/View/Screens/Receipts/receipts_controller.dart';

class ItemsSource extends DataTableSource {
  final List<ItemsModel> items;
  final BuildContext context;
  final bool canTap;
  final ItemsViewmodel state;
  ItemsSource({
    required this.items,
    required this.context,
    required this.canTap,
    required this.state,
  });
  List showAvPrice(ItemsModel item) {
    String unit = double.parse(item.unitConvert.toString()) > 1.0
        ? item.unitName.toString() + " " + item.unitConvert.toString()
        : item.unitName.toString();
    if (context.read<PowersState>().showPurchasePrices) {
      return [
        item.unitId,
        item.itemName,
        unit,
        item.curQty,
        item.outPrice2,
        item.outPrice,
        item.avPrice,
        item.laPrice,
        item.unitBarcode,
        item.storId,
      ];
    } else {
      return [
        item.unitId,
        item.itemName,
        unit,
        item.curQty,
        item.outPrice2,
        item.outPrice,
        item.unitBarcode,
        item.storId,
      ];
    }
  }

  @override
  DataRow? getRow(int index) {
    ItemsModel item = items[index];
    final cell = showAvPrice(item);
    return DataRow(
      selected: state.selectedItems.contains(item),
      onSelectChanged: canTap
          ? (v) {
              if (v!) {
                state.addToSelectedItems(input: item);
              } else {
                state.removeFromSelectedItems(input: item);
              }
            }
          : null,
      color: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if ((index % 2) == 0) {
          return Colors.grey[200];
        }
        return null;
      }),
      cells: cell
          .mapIndexed(
            (index, e) => DataCell(
              index != 1
                  ? SizedBox(
                      width: screenWidth(context) * 0.2,
                      child: Center(
                        child: AutoSizeText(
                          ValuesManager.doubleToString(e),
                          overflow: TextOverflow.visible,
                          maxLines: 1,
                        ),
                      ),
                    )
                  : Text(
                      ValuesManager.doubleToString(e),
                    ),
              onTap: () {
                if (canTap) {
                  try {
                    if (context.read<PowersState>().allowSellQtyLessThanZero ==
                            false &&
                        item.curQty < 0) {
                      showAlertSnackbar(
                        context: context,
                        text: "qty_error".tr,
                      );
                    } else {
                      Get.find<ReceiptsController>()
                          .addItem(input: item, context: context);
                      Get.back();
                    }
                  } catch (e) {
                    log(e.toString());
                    Get.find<ReceiptsController>().removeLastItem();
                    showErrorDialog(
                      context: context,
                      description: e.toString(),
                      title: "error".tr,
                    );
                  }
                }
              },
            ),
          )
          .toList(),
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => items.length;

  @override
  int get selectedRowCount => 0;
}
