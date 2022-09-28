import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:smart_sales/App/Util/locator.dart';
import 'package:smart_sales/Data/Models/client_model.dart';
import 'package:smart_sales/Provider/clients_state.dart';
import 'package:smart_sales/Services/Repositories/dio_repository.dart';
import 'package:smart_sales/View/Widgets/Dialogs/done_dialog.dart';
import 'package:smart_sales/View/Widgets/Dialogs/error_dialog.dart';

class RegisterViewmodel {
  Future<void> addRecord({
    required Map<String, dynamic> data,
    required BuildContext context,
  }) async {
    try {
      EasyLoading.show();
      final response = await locator.get<DioRepository>().get(
            data: data,
            path: "/am_add_new_rec",
          );
      switch (response) {
        case "-1":
          throw "خطا عام";
        case "-4":
          throw "غير مسموح بادخال عملاء من الموبايل";
        case "-7":
          throw "الاسم موجود مسبقا";
        case "-9":
          throw "حساب المندوب غير صحيح";
        case "-11":
          throw " ال reference I'd  غير صحيح";
        case "-13":
          throw "خطا في اضافه العميل الى ال api";
        case "-15":
          throw "تمت اضافه العميل في القاعده الاساسيه وال api  ولكن حدث خطا في ارساله للموبايل";
        default:
          {
            ClientsModel client =
                ClientsModel.fromMap(json.decode(response)[0]);
            await context.read<ClientsState>().addClient(client: client);
          }
      }
      doneDialog(context: context);
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      showErrorDialog(
        context: context,
        title: "error".tr,
        description: e.toString(),
      );
    }
  }
}
