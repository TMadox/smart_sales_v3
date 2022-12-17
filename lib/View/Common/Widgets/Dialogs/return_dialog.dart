import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smart_sales/Data/Models/client.dart';
import 'package:smart_sales/Data/Models/mow_model.dart';
import 'package:smart_sales/Provider/mow_state.dart';
import 'package:smart_sales/Provider/clients_state.dart';
import 'package:smart_sales/Provider/general_state.dart';
import 'package:smart_sales/View/Common/Features/starting_id.dart';
import 'package:smart_sales/View/Screens/Receipts/receipt_view.dart';
import 'package:smart_sales/View/Screens/Receipts/receipts_controller.dart';

void showReturnDialog({required BuildContext context, required Map receipt}) {
  showAnimatedDialog(
    context: context,
    animationType: DialogTransitionType.slideFromLeft,
    curve: Curves.fastOutSlowIn,
    duration: const Duration(milliseconds: 500),
    builder: (bcontext) {
      return AlertDialog(
        title: Center(
            child: Text(
          "return_dialog_title".tr,
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
        )),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                    partReturn(
                      context: context,
                      receipt: receipt,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: Text(
                    "return_dialog_first_type".tr,
                    style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
                  )),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () async {
                    await fullReturn(
                      context: context,
                      receipt: receipt,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: Text(
                    "return_dialog_second_type".tr,
                    style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
                  )),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                    newReceipt(context: context, receipt: receipt);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: Text(
                    "return_dialog_third_type".tr,
                    style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
                  )),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: Text(
                    "return_dialog_close".tr,
                    style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
                  )),
            )
          ],
        ),
      );
    },
  );
}

void partReturn({required BuildContext context, required Map receipt}) {
  Map loadedReceipt = Map.from(receipt);
  bool hasRemaining = false;
  List<Map> products = List.from(json.decode(loadedReceipt["products"]));
  for (var element in products) {
    if ((element["qty_remain"] != 0) || (element["free_qty_remain"] != 0)) {
      hasRemaining = true;
    }
  }
  if (hasRemaining) {
    for (var element in products) {
      element["fat_qty"] = 0;
      element["free_qty"] = 0;
    }
    if (loadedReceipt["section_type_no"] == 1) {
      loadedReceipt["credit_before"] = context
          .read<ClientsState>()
          .clients
          .firstWhere(
              (element) => element.accId == loadedReceipt["basic_acc_id"])
          .curBalance;
    } else {
      loadedReceipt["credit_before"] = context
          .read<MowState>()
          .mows
          .firstWhere(
              (element) => element.accId == loadedReceipt["basic_acc_id"])
          .curBalance;
    }
    loadedReceipt["section_type_no"] =
        getReturnId(parentTypeNo: receipt["section_type_no"]);
    loadedReceipt["parent_id"] = receipt["oper_code"];
    loadedReceipt["oper_id"] =
        StartingId().get(loadedReceipt["section_type_no"]);
    loadedReceipt["oper_code"] =
        StartingId().get(loadedReceipt["section_type_no"]);
    loadedReceipt["is_sender_complete_status"] = 0;
    loadedReceipt["extend_time"] = DateTime.now().toString();
    Get.find<ReceiptsController>().setReceipt(loadedReceipt);
    Get.find<ReceiptsController>()
        .fillReceiptWithItems(input: products, addController: false);
    Navigator.of(context).pop();
    if (loadedReceipt["section_type_no"] == 2) {
      Get.to(
        () => ReceiptView(
          entity: context.read<ClientsState>().clients.firstWhere(
                (element) => element.accId == loadedReceipt["basic_acc_id"],
              ),
          sectionTypeNo: 2,
          resetReceipt: false,
        ),
      );
    } else {
      MowModel mow = context.read<MowState>().mows.firstWhere(
          (element) => element.accId == loadedReceipt["basic_acc_id"]);
      Get.toNamed("receiptEdit", arguments: mow);
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("part_return_text".tr),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

fullReturn({required BuildContext context, required Map receipt}) async {
  Map loadedReceipt = Map.from(receipt);
  bool hasRemaining = false;
  List<Map> products = List.from(json.decode(loadedReceipt["products"]));
  for (var element in products) {
    if ((element["qty_remain"] != 0) || (element["free_qty_remain"] != 0)) {
      hasRemaining = true;
    }
  }
  if (hasRemaining) {
    EasyLoading.show();
    for (var element in products) {
      element["fat_qty"] = element["qty_remain"];
      element["free_qty"] = element["free_qty_remain"];
      element["qty_remain"] = 0;
      element["free_qty_remain"] = 0;
    }
    if (loadedReceipt["section_type_no"] == 1) {
      loadedReceipt["credit_before"] = context
          .read<ClientsState>()
          .clients
          .firstWhere(
              (element) => element.accId == loadedReceipt["basic_acc_id"])
          .curBalance;
    } else {
      loadedReceipt["credit_before"] = context
          .read<MowState>()
          .mows
          .firstWhere(
              (element) => element.accId == loadedReceipt["basic_acc_id"])
          .curBalance;
    }
    loadedReceipt["section_type_no"] =
        getReturnId(parentTypeNo: receipt["section_type_no"]);
    loadedReceipt["parent_id"] = receipt["oper_code"];
    loadedReceipt["saved"] = 0;
    loadedReceipt["is_sender_complete_status"] = 0;
    loadedReceipt["oper_id"] = StartingId().get(receipt["section_type_no"]);
    loadedReceipt["oper_code"] = StartingId().get(receipt["section_type_no"]);
    loadedReceipt["extend_time"] = DateTime.now().toString();
    // context.read<GeneralState>().setCurrentReceipt(input: loadedReceipt);
    // context
    //     .read<GeneralState>()
    //     .fillReceiptWithItems(input: products, addController: false);
    await saveReceipt(context);
    EasyLoading.dismiss();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("full_return_text".tr),
        behavior: SnackBarBehavior.floating,
      ),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("part_return_text".tr),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

Future<void> newReceipt(
    {required BuildContext context, required Map receipt}) async {
  if (checkIfAllowed(context: context, receipt: receipt)) {
    Map loadedReceipt = Map.from(receipt);
    List<Map> products = List.from(json.decode(loadedReceipt["products"]));
    await fullReturn(
      context: context,
      receipt: receipt,
    );
    for (var element in products) {
      element["fat_qty"] = 1;
      element["free_qty"] = 0;
    }
    if (loadedReceipt["section_type_no"] == 1) {
      loadedReceipt["credit_before"] = context
          .read<ClientsState>()
          .clients
          .firstWhere(
              (element) => element.accId == loadedReceipt["basic_acc_id"])
          .curBalance;
    } else {
      loadedReceipt["credit_before"] = context
          .read<MowState>()
          .mows
          .firstWhere(
              (element) => element.accId == loadedReceipt["basic_acc_id"])
          .curBalance;
    }
    loadedReceipt["saved"] = 0;
    loadedReceipt["oper_id"] = StartingId().get(loadedReceipt["oper_id"]);
    loadedReceipt["oper_code"] = StartingId().get(loadedReceipt["oper_id"]);
    loadedReceipt["is_sender_complete_status"] = 0;
    loadedReceipt["extend_time"] = DateTime.now().toString();
    // context.read<GeneralState>().setCurrentReceipt(input: loadedReceipt);
    // context
    //     .read<GeneralState>()
    //     .fillReceiptWithItems(input: products, addController: true);
    Navigator.of(context).pop();
    if (loadedReceipt["section_type_no"] == 1) {
      final Client client = context.read<ClientsState>().clients.firstWhere(
            (element) => element.accId == loadedReceipt["basic_acc_id"],
          );
      Get.to(() => ReceiptView(
            entity: client,
            sectionTypeNo: 1,
            resetReceipt: true,
          ));
    } else {
      final MowModel mow = context.read<MowState>().mows.firstWhere(
            (element) => element.accId == loadedReceipt["basic_acc_id"],
          );
      Get.to(() => ReceiptView(
            entity: mow,
            sectionTypeNo: 1,
            resetReceipt: true,
          ));
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("part_return_text".tr),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

bool checkIfAllowed({required BuildContext context, required Map receipt}) {
  bool hasRemaining = false;
  List<Map> products = List.from(json.decode(receipt["products"]));
  for (var element in products) {
    if ((element["qty_remain"] != 0) || (element["free_qty_remain"] != 0)) {
      hasRemaining = true;
    }
  }
  return hasRemaining;
}

saveReceipt(BuildContext context) async {
  // context.read<GeneralState>().setRemainingQty();
  // await context.read<GeneralState>().computeReceipt(context: context);
}

int getReturnId({required int parentTypeNo}) {
  switch (parentTypeNo) {
    case 1:
      return 2;
    case 3:
      return 4;
    default:
      return 2;
  }
}
