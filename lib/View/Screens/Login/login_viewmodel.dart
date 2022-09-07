import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:smart_sales/App/Util/device.dart';
import 'package:smart_sales/App/Util/locator.dart';
import 'package:smart_sales/Data/Database/Commands/save_data.dart';
import 'package:smart_sales/Data/Database/Secure/save_sensitive_data.dart';
import 'package:smart_sales/Data/Database/Shared/shared_storage.dart';
import 'package:smart_sales/Data/Models/client_model.dart';
import 'package:smart_sales/Data/Models/info_model.dart';
import 'package:smart_sales/Data/Models/item_model.dart';
import 'package:smart_sales/Data/Models/options_model.dart';
import 'package:smart_sales/Data/Models/power_model.dart';
import 'package:smart_sales/Data/Models/user_model.dart';
import 'package:smart_sales/Provider/general_state.dart';
import 'package:smart_sales/Provider/user_state.dart';
import 'package:smart_sales/Services/Helpers/exceptions.dart';
import 'package:smart_sales/Services/Repositories/customers_repo.dart';
import 'package:smart_sales/Services/Repositories/general_repository.dart';
import 'package:smart_sales/Services/Repositories/info_repo.dart';
import 'package:smart_sales/Services/Repositories/items_repo.dart';
import 'package:smart_sales/Services/Repositories/login_repo.dart';
import 'package:smart_sales/Services/Repositories/options_repo.dart';
import 'package:smart_sales/Services/Repositories/powers_repo.dart';
import 'package:smart_sales/View/Widgets/Dialogs/error_dialog.dart';

class LoginViewmodel extends ChangeNotifier {
  final storage = locator.get<SharedStorage>();
  Future<void> validateAndLogin({
    required BuildContext context,
    required GlobalKey<FormBuilderState> formKey,
  }) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      try {
        EasyLoading.show();
        if (context.read<GeneralState>().receiptsList.isNotEmpty &&
            context
                .read<GeneralState>()
                .receiptsList
                .where((element) =>
                    element["created_user_id"].toString() ==
                    context.read<UserState>().loginInfo['user_id'].toString())
                .isEmpty &&
            context
                .read<GeneralState>()
                .receiptsList
                .where((element) =>
                    element["created_user_id"].toString() ==
                    context
                        .read<UserState>()
                        .loginInfo['ip_address']
                        .toString())
                .isEmpty) {
          throw "incompatible_id_with_receipts".tr;
        }
        await locator
            .get<LoginRepo>()
            .requestLogin(
              ipAddress: context.read<UserState>().loginInfo["ip_address"],
              ipPassword: context.read<UserState>().loginInfo["ip_password"],
              userId: int.parse(context.read<UserState>().loginInfo['user_id']),
              password: formKey.currentState!.value["password"],
              username: formKey.currentState!.value["username"],
              ref: locator.get<DeviceParam>().deviceId.toString(),
            )
            .then((user) async {
          locator.get<GeneralRepository>().init(
                context: context,
                ipPassword: user.ipPassword,
                ipAddress: user.ipAddress,
              );
          final List<OptionsModel> optionsList = await getOptions(user: user);
          final OptionsModel transAllStors =
              optionsList.firstWhere((option) => option.optionId == 6);
          final OptionsModel transAllAm =
              optionsList.firstWhere((option) => option.optionId == 5);
          await saveDataLocally(
            items: transAllStors.optionValue == 0
                ? await locator.get<GeneralRepository>().get(
                    path: '/get_data_items_with_stor_id',
                    data: {
                      "stor_id": user.defStorId,
                    },
                  )
                : await locator.get<GeneralRepository>().get(
                      path: '/get_data_items',
                    ),
            types: transAllStors.optionValue == 1
                ? await locator
                    .get<GeneralRepository>()
                    .get(path: '/get_data_types_qtys')
                : null,
            user: userStringFromModel(input: user),
            options: optionsList,
            info: await getInfo(user: user),
            customers: transAllAm.optionValue == 0
                ? await locator.get<GeneralRepository>().get(
                    path: '/get_data_am_by_employ_acc_id',
                    data: {"employ_acc_id": user.defEmployAccId},
                  )
                : await locator.get<GeneralRepository>().get(
                      path: '/get_data_am',
                    ),
            userPowers: await getPower(user: user),
            stors: transAllStors.optionValue == 1.0
                ? await locator
                    .get<GeneralRepository>()
                    .get(path: '/get_data_stors')
                : "[]",
            kinds: await locator
                .get<GeneralRepository>()
                .get(path: '/get_data_kinds'),
            mows: await locator
                .get<GeneralRepository>()
                .get(path: '/get_data_mow'),
            expenses: await locator
                .get<GeneralRepository>()
                .get(path: '/get_data_expense'),
            groups: await locator
                .get<GeneralRepository>()
                .get(path: '/get_data_groups'),
            powers: await locator
                .get<GeneralRepository>()
                .get(path: '/get_data_powers'),
          );
          storage.loggedBefore = true;
          Navigator.of(context).pushReplacementNamed("splash");
        });
      } catch (e) {
        if (e is DioError) {
          String message = DioExceptions.fromDioError(e).toString();
          showErrorDialog(
            context: context,
            description: message,
            title: "error".tr,
          );
        } else {
          showErrorDialog(
            context: context,
            description: e.toString(),
            title: "error".tr,
          );
        }
      } finally {
        EasyLoading.dismiss();
      }
    }
  }

  Future<List<ItemsModel>> getItems({
    required UserModel user,
    required bool getAllItems,
  }) async {
    return await locator.get<ItemRepo>().requestItems(
          ip: user.ipAddress,
          ipPassword: user.ipPassword,
          storeId: getAllItems ? null : user.defStorId,
        );
  }

  Future<List<ClientsModel>> getCustomers({required UserModel user}) async {
    return await locator.get<CustomersRepo>().requestCustomers(
        ipAddress: user.ipAddress,
        employerId: user.defEmployAccId,
        ipPassword: user.ipPassword);
  }

  getOptions({required UserModel user}) async {
    return await locator.get<OptionsRepo>().requiredOptions(
          ip: user.ipAddress,
          ipPassword: user.ipPassword,
        );
  }

  getPower({required UserModel user}) async {
    return await locator.get<PowersRepo>().requestPowers(
          ip: user.ipAddress,
          ipPassword: user.ipPassword,
          userId: user.userId,
        );
  }

  Future<InfoModel> getInfo({required UserModel user}) async {
    return await locator.get<InfoRepo>().requestInfo(
          ip: user.ipAddress,
          ipPassword: user.ipPassword,
        );
  }

  saveDataLocally({
    required String user,
    required String items,
    required String customers,
    required InfoModel info,
    required List<PowersModel> userPowers,
    required String powers,
    required List<OptionsModel> options,
    required String stors,
    required String kinds,
    required String mows,
    required String expenses,
    required String groups,
    String? types,
  }) async {
    await locator.get<SaveSensitiveData>().saveSensitiveData(input: user);
    await locator.get<SaveData>().saveOptionsData(input: options);
    await locator.get<SaveData>().saveInfoData(info: info);
    await locator.get<SaveData>().savePowersInfo(powers: userPowers);
    await storage.prefs.setString("stors", stors);
    await storage.prefs.setString("kinds", kinds);
    await storage.prefs.setString("items", items);
    await storage.prefs.setString("mows", mows);
    await storage.prefs.setString("expenses", expenses);
    await storage.prefs.setString("groups", groups);
    await storage.prefs.setString("customers", customers);
    await storage.prefs.setString("powers", powers);
    if (types != null) {
      await storage.prefs.setString("types", types);
    } else {
      await storage.prefs.remove("types");
    }
  }
}
