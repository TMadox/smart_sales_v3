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
import 'package:smart_sales/Provider/general_state.dart';
import 'package:smart_sales/View/Screens/Receipts/receipt_viewmodel.dart';
import 'package:smart_sales/View/Widgets/Common/alert_snackbar.dart';
import 'package:smart_sales/View/Widgets/Dialogs/error_dialog.dart';

class ItemsSource extends DataTableSource {
  final List<ItemsModel> items;
  final BuildContext context;
  final bool canTap;
  ItemsSource({
    required this.items,
    required this.context,
    required this.canTap,
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
        item.unitBarcode
      ];
    } else {
      return [
        item.unitId,
        item.itemName,
        unit,
        item.curQty,
        item.outPrice2,
        item.outPrice,
        item.unitBarcode
      ];
    }
  }

  @override
  DataRow? getRow(int index) {
    ItemsModel item = items[index];
    log(item.storId.toString());
    final cell = showAvPrice(item);
    return DataRow(
        color: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
          if ((index % 2) == 0) {
            return Colors.grey[200];
          }
          return null;
        }),
        cells: cell
            .mapIndexed((index, e) => DataCell(
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
                        if (context
                                    .read<PowersState>()
                                    .allowSellQtyLessThanZero ==
                                false &&
                            item.curQty < 0) {
                          showAlertSnackbar(
                            context: context,
                            text: "qty_error".tr,
                          );
                        } else {
                          context
                              .read<ReceiptViewmodel>()
                              .addNewItem(context: context, item: item);
                          Navigator.of(context).pop();
                        }
                      } catch (e) {
                        context.read<GeneralState>().removeLastItem();
                        showErrorDialog(
                          context: context,
                          description: e.toString(),
                          title: "error".tr,
                        );
                      }
                    }
                  },
                ))
            .toList());
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => items.length;

  @override
  int get selectedRowCount => 0;
}
