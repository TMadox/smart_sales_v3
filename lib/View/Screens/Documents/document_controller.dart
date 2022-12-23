import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:smart_sales/App/Printing/create_pdf.dart';
import 'package:smart_sales/App/Resources/values_manager.dart';
import 'package:smart_sales/App/Util/get_location.dart';
import 'package:smart_sales/Data/Models/entity.dart';
import 'package:smart_sales/Data/Models/location_model.dart';
import 'package:smart_sales/Provider/clients_state.dart';
import 'package:smart_sales/Provider/expenses_state.dart';
import 'package:smart_sales/Provider/mow_state.dart';
import 'package:smart_sales/View/Common/Features/init_receipt.dart';
import 'package:smart_sales/View/Screens/Base/base_controller.dart';

class DocumentsController extends GetxController with BaseController {
  final Rx<Map> document = Rx({"totalProducts": 0});

  void startDocument({
    required Entity entity,
    required BuildContext context,
    required int sectionTypeNo,
    required int? selectedStorId,
  }) {
    document.value = InitReceipt().build(
      entity: entity,
      context: context,
      sectionTypeNo: sectionTypeNo,
      selectedStorId: selectedStorId,
    );
  }

  void editDocument({required Map input}) {
    document.update((val) {
      val!.addAll(input);
      val.addAll({"credit_after": calculateCreditAfter()});
    });
  }

  String title(int sectionTypeNo) {
    switch (sectionTypeNo) {
      case 101:
      case 104:
      case 106:
      case 108:
        return "payment from".tr;
      case 102:
      case 103:
      case 105:
      case 107:
        return "seizure from".tr;
      default:
        return "";
    }
  }

  num calculateCreditAfter() {
    num creditBefore = document.value["credit_before"];
    num resideValue = document.value["cash_value"];
    int sectionNo = document.value["section_type_no"];
    switch (sectionNo) {
      case 101:
      case 104:
      case 106:
      case 108:
        return creditBefore - resideValue;
      case 102:
      case 103:
      case 105:
      case 107:
        return creditBefore + resideValue;
      default:
        return creditBefore;
    }
  }

  Future<void> wrapDocument(BuildContext context) async {
    LocationModel locationData = await getLocationData();
    document.value["oper_value"] = document.value["cash_value"];
    document.value["reside_value"] = document.value["cash_value"];
    document.value["oper_net_value"] = document.value["cash_value"];
    document.value.addAll({
      "products": "[]",
      "location_code": locationData.locationCode,
      "location_name": locationData.locationName,
      "credit_after": await editCustomers(context: context),
      "extend_time_2": DateTime.now().toString(),
      "saved": 1,
    });
    final List<Map> operations =
        List<Map>.from(json.decode(GetStorage().read("operations") ?? "[]"));
    final Map finalOperations =
        json.decode(GetStorage().read("finalReceipt") ?? "{}");
    operations.add(document.value);
    finalOperations[document.value["section_type_no"].toString()] =
        document.value;
    await saveOperations(
      operations: operations,
      finalOperations: finalOperations,
    );
  }

  Future<num> editCustomers({
    required BuildContext context,
  }) async {
    double creditAfter = 0;
    if (document.value["section_type_no"] == 103 ||
        document.value["section_type_no"] == 104) {
      creditAfter = await context.read<MowState>().editMows(
            id: document.value["basic_acc_id"],
            amount: document.value["reside_value"] ?? 0.0,
            sectionType: document.value["section_type_no"],
          );
    } else if (document.value["section_type_no"] == 108 ||
        document.value["section_type_no"] == 107) {
      creditAfter = await context.read<ExpenseState>().editExpenses(
            id: document.value["basic_acc_id"],
            amount: document.value["reside_value"] ?? 0.0,
            sectionType: document.value["section_type_no"],
          );
    } else if (document.value["section_type_no"] == 101 ||
        document.value["section_type_no"] == 102) {
      creditAfter = await context.read<ClientsState>().editCustomer(
            id: document.value["basic_acc_id"],
            amount: document.value["reside_value"],
            sectionType: document.value["section_type_no"],
          );
    }
    return ValuesManager.checkNum(creditAfter);
  }

  Future<void> finishDocument({
    required Map inputs,
    required BuildContext context,
    bool share = false,
    bool savePdf = false,
  }) async {
    try {
      Get.back();
      EasyLoading.show();
      await wrapDocument(context);
      if (savePdf && !share) {
        await createPDF(
          bContext: context,
          receipt: document.value,
        );
      } else if (!savePdf && share) {
        await createPDF(
          bContext: context,
          receipt: document.value,
          share: true,
        );
      }
      EasyLoading.showSuccess(
        "document created successfully".tr,
        duration: const Duration(seconds: 5),
        dismissOnTap: true,
      );
      Get.back();
    } catch (e) {
      log(e.toString());
      EasyLoading.showError("error".tr);
    }
  }
}
