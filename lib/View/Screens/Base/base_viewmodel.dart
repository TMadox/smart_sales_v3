import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:smart_sales/App/Printing/create_pdf.dart';
import 'package:smart_sales/App/Util/date.dart';
import 'package:smart_sales/App/Util/device.dart';
import 'package:smart_sales/App/Util/locator.dart';
import 'package:smart_sales/App/Util/select_cst_class.dart';
import 'package:smart_sales/Data/Database/Commands/save_data.dart';
import 'package:smart_sales/Data/Database/Shared/shared_storage.dart';
import 'package:smart_sales/Data/Models/item_model.dart';
import 'package:smart_sales/Provider/customers_state.dart';
import 'package:smart_sales/Provider/options_state.dart';
import 'package:smart_sales/Provider/general_state.dart';
import 'package:smart_sales/Provider/powers_state.dart';
import 'package:smart_sales/Provider/user_state.dart';
import 'package:smart_sales/Services/Repositories/upload_repo.dart';
import 'package:smart_sales/View/Screens/Items/Items_viewmodel.dart';
import 'package:smart_sales/View/Screens/Receipts/receipt_viewmodel.dart';
import 'package:smart_sales/View/Widgets/Common/alert_snackbar.dart';
import 'package:smart_sales/View/Widgets/Dialogs/exit_dialog.dart';
import 'package:smart_sales/View/Widgets/Dialogs/warning_dialog.dart';

abstract class BaseViewmodel {
  int getStartingId({required BuildContext context, required int sectionNo}) {
    if (context.read<GeneralState>().finalReceipts[sectionNo.toString()] ==
        null) {
      return 0;
    } else {
      return context.read<GeneralState>().finalReceipts[sectionNo.toString()]
              ["oper_id"] ??
          0;
    }
  }

  Future<void> onUpload(BuildContext context) async {
    try {
      if (!context.read<GeneralState>().isUploading) {
        context.read<GeneralState>().uploading = true;
        await locator
            .get<UploadReceipts>()
            .requestUploadReceipts(context: context);
        await locator.get<SaveData>().saveReceiptsData(
            input: context.read<GeneralState>().receiptsList, context: context);
      }
    } catch (e) {
      showAlertSnackbar(context: context, text: "خطا في الرفع التلقائي");
    } finally {
      context.read<GeneralState>().uploading = false;
    }
  }

  Future<void> onFinishOperation({
    required BuildContext context,
    bool? doShare,
    bool? doPrint,
    Function? doAfter,
  }) async {
    try {
      await context.read<GeneralState>().computeReceipt(
            context: context,
          );
      if (doPrint == true) {
        await createPDF(
          bContext: context,
          receipt: context.read<GeneralState>().receiptsList.last,
          share: doShare ?? false,
        );
      }
    } finally {
      doAfter;
    }
  }

  Future<void> onDelete(BuildContext context) async {
    context.read<GeneralState>().removeFromListReceiptItems(
          inputs: context.read<ReceiptViewmodel>().selectedItems,
        );
  }

  bool onExit({required BuildContext context, required Map data}) {
    final generalState = context.read<GeneralState>();
    if (generalState.receiptItems.isNotEmpty) {
      warningDialog(
        context: context,
        warningText: 'receipt_still_inprogress'.tr,
        btnCancelText: "exit".tr,
        btnOkText: 'stay'.tr,
        onCancel: () {
          if ((locator.get<SharedStorage>().prefs.getBool("request_visit") ??
              true)) {
            exitDialog(
              context: context,
              data: data,
            );
            return false;
          } else {
            Navigator.pop(context);
          }
        },
      );
      return false;
    } else {
      if ((locator.get<SharedStorage>().prefs.getBool("request_visit") ??
          true)) {
        exitDialog(
          context: context,
          data: data,
        );
        return false;
      } else {
        Navigator.pop(context);
        return true;
      }
    }
  }

  changeValue(
      {item,
      required String key,
      required TextEditingController controller,
      required GeneralState generalState,
      value}) {
    if (value != "" && value != ".") {
      if (key == "fat_qty" || key == "free_qty") {
        generalState.changeItemValue(
          item: item,
          input: {key: double.parse(value)},
        );
      } else {
        generalState.changeItemValue(
          item: item,
          input: {key: double.parse(value)},
        );
      }
    } else {
      controller.text = (key == "fat_qty") ? 1.toString() : 0.0.toString();
      controller.selection = TextSelection(
        baseOffset: 0,
        extentOffset: controller.value.text.length,
      );
      generalState.changeItemValue(
        item: item,
        input: {key: (key == "fat_qty") ? 1 : 0.0},
      );
    }
  }

  String operationName(int input) {
    switch (input) {
      case 0:
        return "تحميل";
      case 1:
        return "sales_receipt".tr;
      case 2:
        return "return_receipt".tr;
      case 17:
        return "selling_order".tr;
      case 18:
        return "purchase_order".tr;
      case 98:
        return "inventory_receipt".tr;
      case 3:
        return "purchase_receipt".tr;
      case 4:
        return "purchase_return_receipt".tr;
      default:
        return "عملية";
    }
  }

  Future<void> saveVisit(
      {required BuildContext context, required Map data}) async {
    final loggedUser = context.read<UserState>().user;
    data.addAll({
      "extend_time_2": DateTime.now().toString(),
      "is_sender_complete_status": 0,
      "oper_id": 0,
      "employee_name": loggedUser.userName,
      "oper_time": CurrentDate.getCurrentTime(),
      "section_type_no": 9999,
      "reside_value": 0.0,
      "cash_value": 0.0,
      "oper_code": 0,
      "client_acc_id": loggedUser.defBoxAccId,
      "items_count": 0.0,
      "created_user_id": loggedUser.userId,
      "created_user_ip": loggedUser.ipAddress,
      'created_date': CurrentDate.getCurrentDate(),
      'oper_date': CurrentDate.getCurrentDate(),
      "oper_due_date": CurrentDate.getCurrentDate(),
      "oper_value": 0.0,
      "oper_disc_per": 0.0,
      "oper_disc_value": 0.0,
      "oper_add_per": 0.0,
      "oper_add_value": 0.0,
      "oper_net_value": 0.0,
      "tax_per": 0.0,
      "tax_value": 0.0,
      "oper_net_value_with_tax": 0.0,
      "pay_method_id": 1,
      "oper_profit": 0.0,
      "is_form_for_fat": 1,
      "is_form_has_affect_on_stock": 1,
      "is_form_for_output_stock": 1,
      "stor_id": loggedUser.defStorId,
      "comp_id": loggedUser.compId,
      "branch_id": loggedUser.branchId,
      "is_saved_in_server": 1,
      "refrence_id": locator.get<DeviceParam>().deviceId,
      "save_eror_mes": "0",
      "sender_oper_id": context.read<GeneralState>().receiptsList.length,
      "is_review_from_sender": 0,
      "oper_disc_value_with_tax": 0.0,
      "oper_add_value_with_tax": 0.0,
      "saved": 0,
      "use_tax_system":
          context.read<OptionsState>().options[0].optionValue ?? 0.0,
      "use_price_with_tax":
          context.read<OptionsState>().options[1].optionValue ?? 0.0,
      "is_for_price_with_tax":
          context.read<OptionsState>().options[1].optionValue,
    });
    context.read<GeneralState>().setCurrentReceipt(input: data);
    await context.read<GeneralState>().computeReceipt(context: context);
    await locator.get<SaveData>().saveReceiptsData(
          input: context.read<GeneralState>().receiptsList,
          context: context,
        );
  }

  addNewItem({required BuildContext context, required ItemsModel item}) {
    context.read<GeneralState>().addItem(item: {
      "fat_det_id": context.read<ItemsViewmodel>().items.indexOf(item),
      "oper_id": context.read<GeneralState>().currentReceipt["oper_id"],
      "unit_convert": item.unitConvert,
      "unit_name": item.unitName,
      "barcode": item.unitBarcode,
      "fat_item_no": 1,
      "fat_qty": 1.0,
      "original_qty": item.curQty,
      "original_qty_after": item.curQty,
      "fat_price": context.read<CustomersState>().currentCustomer == null
          ? 0.0
          : selectCstClass(
              context: context,
              item: item,
              customerClass:
                  context.read<CustomersState>().currentCustomer!.priceId!,
            ),
      "original_price": context.read<CustomersState>().currentCustomer == null
          ? 0.0
          : selectCstClass(
              context: context,
              item: item,
              customerClass:
                  context.read<CustomersState>().currentCustomer!.priceId!,
            ),
      "fat_qty_controller": TextEditingController(text: 1.toString()),
      "fat_disc_value_controller": TextEditingController(text: 0.0.toString()),
      "free_qty_controller": TextEditingController(text: 0.toString()),
      "fat_price_controller": TextEditingController(
          text: context.read<CustomersState>().currentCustomer == null
              ? "0.0"
              : selectCstClass(
                      context: context,
                      item: item,
                      customerClass: context
                          .read<CustomersState>()
                          .currentCustomer!
                          .priceId!)
                  .toString()),
      "fat_disc_per": 0.0,
      "fat_disc_value": 0.0,
      "fat_disc_value_with_tax": 0.0,
      "fat_disc_per2": 0.0,
      "fat_disc_value2": 0.0,
      "fat_disc_per3": 0.0,
      "fat_disc_value3": 0.0,
      "fat_add_per": item.taxPer,
      "fat_add_value": 0.0,
      "fat_add_price_value": 0.0,
      "fat_disc_price": 0.0,
      "fat_net_price": context.read<CustomersState>().currentCustomer == null
          ? 0.0
          : selectCstClass(
              context: context,
              item: item,
              customerClass:
                  context.read<CustomersState>().currentCustomer!.priceId!),
      "fat_value": context.read<CustomersState>().currentCustomer == null
          ? 0.0
          : selectCstClass(
              context: context,
              item: item,
              customerClass:
                  context.read<CustomersState>().currentCustomer!.priceId!),
      "fat_net_value": context.read<CustomersState>().currentCustomer == null
          ? 0.0
          : selectCstClass(
              context: context,
              item: item,
              customerClass:
                  context.read<CustomersState>().currentCustomer!.priceId!),
      "fat_profit": 1.0,
      "profit": 1.0,
      "free_qty": 0.0,
      "name": item.itemName,
      "unit_id": item.unitId.toInt(),
      "tax_per": item.taxPer,
      "fat_price_with_tax":
          context.read<CustomersState>().currentCustomer == null
              ? 0.0
              : selectCstClass(
                  context: context,
                  item: item,
                  customerClass:
                      context.read<CustomersState>().currentCustomer!.priceId!,
                ),
      "notes": "",
      "can_sell_with_lower_price":
          context.read<PowersState>().canSellWithLowerPrice,
      "least_selling_price":
          context.read<CustomersState>().currentCustomer == null
              ? 0.0
              : calcLeastSellingPrice(context: context, item: item),
      "least_selling_price_with_tax":
          context.read<CustomersState>().currentCustomer == null
              ? 0.0
              : calcLeastSellingPriceWithoutTax(context: context, item: item)
    });
  }

  scanBarcode({required BuildContext context}) async {
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", "Cancel", true, ScanMode.BARCODE);
    if (barcodeScanRes != '-1') {
      ItemsModel item = context
          .read<ItemsViewmodel>()
          .items
          .firstWhere((element) => element.unitBarcode == barcodeScanRes);
      addNewItem(context: context, item: item);
    }
  }

  calcLeastSellingPrice(
      {required BuildContext context, required ItemsModel item}) {
    double per = selectCstPer(
      context: context,
      customerClass: context.read<CustomersState>().currentCustomer!.priceId!,
      item: item,
    );
    if (context.read<GeneralState>().currentReceipt["use_price_with_tax"] ==
        1) {
      return (item.avPrice + (item.avPrice * (per / 100))) *
          ((item.taxPer / 100) + 1);
    } else {
      return (item.avPrice + (item.avPrice * (per / 100)));
    }
  }

  calcLeastSellingPriceWithoutTax(
      {required BuildContext context, required ItemsModel item}) {
    double per = selectCstPer(
        context: context,
        customerClass: context.read<CustomersState>().currentCustomer!.priceId!,
        item: item);
    return (item.avPrice + (item.avPrice * (per / 100)));
  }
}
