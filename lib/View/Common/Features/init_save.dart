import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_sales/App/Util/date.dart';
import 'package:smart_sales/App/Util/device.dart';
import 'package:smart_sales/App/Util/get_location.dart';
import 'package:smart_sales/App/Util/locator.dart';
import 'package:smart_sales/Data/Database/Commands/read_data.dart';
import 'package:smart_sales/Data/Database/Commands/save_data.dart';
import 'package:smart_sales/Provider/options_state.dart';
import 'package:smart_sales/Provider/user_state.dart';

class InitSave {
  Future<void> build({
    required BuildContext context,
    required Map data,
  }) async {
    final loggedUser = context.read<UserState>().user;
    data.addAll(
      {
        "extend_time_2": DateTime.now().toString(),
        "is_sender_complete_status": 0,
        "oper_id": 0,
        "employee_name": loggedUser.userName,
        "oper_time": CurrentDate.getCurrentTime(),
        "section_type_no": 9999,
        "reside_value": 0.0,
        "cash_value": 0.0,
        "products": [],
        "location_code": (await getLocationData()).locationCode,
        "location_name": (await getLocationData()).locationName,
        "credit_after": 0.0,
        "saved": 0,
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
        "sender_oper_id": ReadData().readOperations().length,
        "is_review_from_sender": 0,
        "oper_disc_value_with_tax": 0.0,
        "oper_add_value_with_tax": 0.0,
        "use_tax_system":
            context.read<OptionsState>().options[0].optionValue ?? 0.0,
        "use_price_with_tax":
            context.read<OptionsState>().options[1].optionValue ?? 0.0,
        "is_for_price_with_tax":
            context.read<OptionsState>().options[1].optionValue,
      },
    );
    final List<Map> operations = ReadData().readOperations();
    final Map finalOperations = ReadData().readLastOperations();
    operations.add(data);
    finalOperations[data["section_type_no"].toString()] = data;
    await SaveData().saveOperationsData(operations: operations);
  }
}
