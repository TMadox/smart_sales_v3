import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_sales/App/Util/date.dart';
import 'package:smart_sales/App/Util/device.dart';
import 'package:smart_sales/App/Util/locator.dart';
import 'package:smart_sales/App/Util/routing.dart';
import 'package:smart_sales/Data/Models/client_model.dart';
import 'package:smart_sales/Data/Models/user_model.dart';
import 'package:smart_sales/Provider/customers_state.dart';
import 'package:smart_sales/Provider/general_state.dart';
import 'package:smart_sales/Provider/options_state.dart';
import 'package:smart_sales/Provider/powers_state.dart';
import 'package:smart_sales/Provider/user_state.dart';
import 'package:smart_sales/View/Screens/Documents/document_viewmodel.dart';

class ClientsViewmodel {
  num getStartingId({
    required BuildContext context,
    required int sectionTypeNo,
  }) {
    if (context.read<GeneralState>().finalReceipts[sectionTypeNo.toString()] ==
        null) {
      return 0;
    } else {
      return context
              .read<GeneralState>()
              .finalReceipts[sectionTypeNo.toString()]["oper_id"] ??
          0;
    }
  }

  Future<void> intializeReceipt({
    required BuildContext context,
    required ClientModel client,
    required int sectionTypeNo,
    required bool canPushReplacement,
    required int selectedStorId,
  }) async {
    UserModel loggedUser = context.read<UserState>().user;
    context.read<GeneralState>().setCurrentReceipt(input: {
      "oper_code":
          getStartingId(context: context, sectionTypeNo: sectionTypeNo) + 1,
      "basic_acc_id": client.accId,
      "client_acc_id": loggedUser.defBoxAccId,
      "oper_id":
          getStartingId(context: context, sectionTypeNo: sectionTypeNo) + 1,
      "allow_sell_qty_less_zero":
          context.read<PowersState>().allowSellQtyLessThanZero,
      "items_count": 0.0,
      "credit_before": client.curBalance ?? 0.0,
      "credit_after": client.curBalance ?? 0.0,
      "extend_time": DateTime.now().toString(),
      "section_type_no": sectionTypeNo,
      "oper_time": CurrentDate.getCurrentTime(),
      "employ_id": client.employAccId,
      "cst_tax": client.taxFileNo,
      "cash_value": 0.0,
      "created_user_id": loggedUser.userId,
      "created_user_ip": loggedUser.ipAddress,
      "user_name": client.amName,
      'created_date': CurrentDate.getCurrentDate(),
      'oper_date': CurrentDate.getCurrentDate(),
      "oper_due_date": CurrentDate.getCurrentDate(),
      "oper_value": 0.0,
      "oper_disc_per": 0.0,
      "oper_disc_value": 0.0,
      "oper_add_per": 0.0,
      "oper_add_value": 0.0,
      "oper_net_value": 0.0,
      "reside_value": 0.0,
      "tax_per": 0.0,
      "tax_value": 0.0,
      "total_tax": 0.0,
      "oper_net_value_with_tax": 0.0,
      "oper_profit": 0.0,
      "is_form_for_fat": 1,
      "is_form_has_affect_on_stock": 1,
      "is_form_for_output_stock": 1,
      "selected_stor_id": selectedStorId,
      "stor_id": loggedUser.defStorId,
      "comp_id": loggedUser.compId,
      "branch_id": loggedUser.branchId,
      "is_saved_in_server": 1,
      "refrence_id": locator.get<DeviceParam>().deviceId,
      "save_eror_mes": "0",
      "sender_oper_id": loggedUser.userId,
      "is_review_from_sender": 0,
      "is_sender_complete_status": 0,
      "employee_name": loggedUser.userName,
      "saved": 0,
      "oper_disc_value_with_tax": 0.0,
      "oper_add_value_with_tax": 0.0,
      "use_tax_system":
          context.read<OptionsState>().options[0].optionValue ?? 0.0,
      "use_price_with_tax":
          context.read<OptionsState>().options[1].optionValue ?? 0.0,
      "is_for_price_with_tax":
          context.read<OptionsState>().options[1].optionValue,
      "notes": ""
    });

    if (sectionTypeNo == 101 || sectionTypeNo == 102) {
      context.read<DocumentsViewmodel>().setSelectedCustomer(input: client);
    } else {
      context.read<CustomersState>().setCurrentCustomer(customer: client);
    }
    if (canPushReplacement) {
      int count = 0;
      Navigator.of(context).pushNamedAndRemoveUntil(
        "ReceiptCreation",
        (route) => count++ >= 2,
        arguments: client,
      );
    } else {
      if (sectionTypeNo == 101 || sectionTypeNo == 102) {
        await Navigator.of(context)
            .pushNamed(Routes.documentsRoute, arguments: sectionTypeNo);
      } else if (sectionTypeNo == 98) {
        await Navigator.of(context)
            .pushNamed(Routes.inventoryRoute, arguments: client);
      } else if (sectionTypeNo == 51) {
        await Navigator.of(context)
            .pushNamed(Routes.cashierRoute, arguments: client);
      } else {
        await Navigator.of(context)
            .pushNamed("ReceiptCreation", arguments: client);
      }
    }
  }
}
