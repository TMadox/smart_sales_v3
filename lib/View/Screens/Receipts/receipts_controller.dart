import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smart_sales/Data/Models/item_model.dart';
import 'package:smart_sales/Provider/powers_state.dart';
import 'package:smart_sales/View/Common/Controllers/general_controller.dart';
import 'package:smart_sales/View/Common/Widgets/Common/custom_cell.dart';
import 'package:smart_sales/View/Screens/Items/items_viewmodel.dart';

class ReceiptsController extends GetxController with GeneralController {
  scanBarcode({required BuildContext context}) async {
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", "Cancel", true, ScanMode.BARCODE);
    if (barcodeScanRes != '-1') {
      ItemsModel item = context
          .read<ItemsViewmodel>()
          .items
          .firstWhere((element) => element.unitBarcode == barcodeScanRes);
      addItem(input: item, context: context);
    }
  }

  void addNotes(String input) {
    currentReceipt.value.addAll({"notes": input});
  }

  List<String> itemTableColumns() {
    if (currentReceipt.value["saved"] == 1) {
      return [
        "number",
        "unit",
        "item",
        "qty",
        "price",
        "discount",
        "value",
        "free_qty",
        "remaining",
        "متبقي مجاني"
      ];
    } else if (currentReceipt.value["section_type_no"] == 5) {
      return [
        "number".tr,
        "unit".tr,
        "item".tr,
        "qty".tr,
      ];
    } else {
      return [
        "number".tr,
        "unit".tr,
        "item".tr,
        "qty".tr,
        "price".tr,
        "discount".tr,
        "value".tr,
        "free_qty".tr
      ];
    }
  }

  List<DataCell> itemTableDataCells(Map item, BuildContext context) {
    if (currentReceipt.value["saved"] == 1) {
      return [
        DataCell(
          CustomCell(
            isEditable: false,
            item: item,
            keyValue: 'fat_det_id',
            generalController: this,
          ),
        ),
        DataCell(
          CustomCell(
            isEditable: false,
            item: item,
            keyValue: 'unit_convert',
            generalController: this,
          ),
        ),
        DataCell(
          CustomCell(
            isEditable: false,
            item: item,
            keyValue: 'name',
            generalController: this,
          ),
        ),
        DataCell(
          CustomCell(
            isEditable: true,
            item: item,
            keyValue: 'fat_qty',
            controller: item["fat_qty_controller"],
            generalController: this,
          ),
        ),
        DataCell(
          CustomCell(
            isEditable: false,
            item: item,
            keyValue: 'original_price',
            generalController: this,
          ),
        ),
        DataCell(
          CustomCell(
            isEditable: false,
            item: item,
            keyValue: 'fat_disc_value_with_tax',
            generalController: this,
          ),
        ),
        DataCell(
          CustomCell(
            isEditable: false,
            item: item,
            keyValue: 'fat_value',
            generalController: this,
          ),
        ),
        DataCell(
          CustomCell(
            isEditable: true,
            item: item,
            keyValue: 'free_qty',
            controller: item["free_qty_controller"],
            generalController: this,
          ),
        ),
        DataCell(
          SizedBox(
            width: 30,
            child: AutoSizeText(
              (item["qty_remain"] - item["fat_qty"]).toString(),
              textAlign: TextAlign.center,
              maxLines: 1,
            ),
          ),
        ),
        DataCell(
          CustomCell(
            isEditable: false,
            item: item,
            keyValue: 'free_qty_remain',
            generalController: this,
          ),
        ),
      ];
    } else if (currentReceipt.value["section_type_no"] == 5) {
      return [
        DataCell(
          CustomCell(
            isEditable: false,
            item: item,
            keyValue: 'fat_det_id',
            generalController: this,
          ),
        ),
        DataCell(
          CustomCell(
            isEditable: false,
            item: item,
            keyValue: 'unit_convert',
            generalController: this,
          ),
        ),
        DataCell(
          CustomCell(
            isEditable: false,
            item: item,
            keyValue: 'name',
            generalController: this,
          ),
        ),
        DataCell(
          CustomCell(
            isEditable: true,
            item: item,
            keyValue: 'fat_qty',
            controller: item["fat_qty_controller"],
            generalController: this,
          ),
        ),
      ];
    } else {
      return [
        DataCell(
          CustomCell(
            isEditable: false,
            item: item,
            keyValue: 'fat_det_id',
            generalController: this,
          ),
        ),
        DataCell(
          CustomCell(
            isEditable: false,
            item: item,
            keyValue: 'unit_convert',
            generalController: this,
          ),
        ),
        DataCell(
          CustomCell(
            isEditable: false,
            item: item,
            keyValue: 'name',
            generalController: this,
          ),
        ),
        DataCell(
          CustomCell(
            isEditable: true,
            item: item,
            keyValue: 'fat_qty',
            controller: item["fat_qty_controller"],
            generalController: this,
          ),
        ),
        DataCell(
          CustomCell(
            isEditable: context.read<PowersState>().canEditItemPrice,
            item: item,
            keyValue: 'original_price',
            controller: item["fat_price_controller"],
            generalController: this,
          ),
        ),
        DataCell(
          CustomCell(
            isEditable: context.read<PowersState>().canEditItemDisc,
            item: item,
            keyValue: 'fat_disc_value_with_tax',
            controller: item["fat_disc_value_controller"],
            generalController: this,
          ),
        ),
        DataCell(
          CustomCell(
            isEditable: false,
            item: item,
            keyValue: 'fat_value',
            generalController: this,
          ),
        ),
        DataCell(
          CustomCell(
            isEditable: context.read<PowersState>().canEditFreeQty,
            item: item,
            keyValue: 'free_qty',
            controller: item["free_qty_controller"],
            generalController: this,
          ),
        ),
      ];
    }
  }

  void addSearchedItem({
    required String keyword,
    required BuildContext context,
  }) {
    ItemsModel item = context.read<ItemsViewmodel>().items.firstWhere(
          (element) => element.unitBarcode == keyword,
        );
    addItem(
      context: context,
      input: item,
    );
  }
}
