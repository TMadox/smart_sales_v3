import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:smart_sales/App/Resources/strings_manager.dart';
import 'package:smart_sales/App/Util/device.dart';
import 'package:smart_sales/App/Util/locator.dart';
import 'package:smart_sales/Data/Database/Commands/save_data.dart';
import 'package:smart_sales/Data/Database/Secure/save_sensitive_data.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smart_sales/Data/Models/client_model.dart';
import 'package:smart_sales/Data/Models/info_model.dart';
import 'package:smart_sales/Data/Models/options_model.dart';
import 'package:smart_sales/Data/Models/power_model.dart';
import 'package:smart_sales/Data/Models/user_model.dart';
import 'package:smart_sales/Provider/general_state.dart';
import 'package:smart_sales/Provider/user_state.dart';
import 'package:smart_sales/Services/Helpers/exceptions.dart';
import 'package:smart_sales/Services/Repositories/customers_repo.dart';
import 'package:smart_sales/Services/Repositories/dio_repository.dart';
import 'package:smart_sales/Services/Repositories/info_repo.dart';
import 'package:smart_sales/Services/Repositories/login_repo.dart';
import 'package:smart_sales/Services/Repositories/options_repo.dart';
import 'package:smart_sales/Services/Repositories/powers_repo.dart';
import 'package:smart_sales/View/Widgets/Dialogs/general_dialog.dart';

class LoginViewmodel extends ChangeNotifier {
  final storage = GetStorage();
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
            .then(
          (user) async {
            await locator.get<SaveSensitiveData>().saveSensitiveData(
                  input: userStringFromModel(input: user),
                );
            locator.get<DioRepository>().init(
                  context: context,
                  ipPassword: user.ipPassword,
                  ipAddress: user.ipAddress,
                );
            if (context.read<GeneralState>().receiptsList.isEmpty) {
              final List<OptionsModel> optionsList =
                  await getOptions(user: user);
              final OptionsModel transAllStors =
                  optionsList.firstWhere((option) => option.optionId == 6);
              final OptionsModel transAllAm =
                  optionsList.firstWhere((option) => option.optionId == 5);
              await saveDataLocally(
                items: transAllStors.optionValue == 0
                    ? await locator.get<DioRepository>().get(
                        path: '/get_data_items_with_stor_id',
                        data: {
                          "stor_id": user.defStorId,
                        },
                      )
                    : await locator.get<DioRepository>().get(
                          path: '/get_data_items',
                        ),
                types: transAllStors.optionValue == 1
                    ? await locator
                        .get<DioRepository>()
                        .get(path: '/get_data_types_qtys')
                    : null,
                options: optionsList,
                info: await getInfo(user: user),
                customers: transAllAm.optionValue == 0
                    ? await locator.get<DioRepository>().get(
                        path: '/get_data_am_by_employ_acc_id',
                        data: {"employ_acc_id": user.defEmployAccId},
                      )
                    : await locator.get<DioRepository>().get(
                          path: '/get_data_am',
                        ),
                userPowers: await getPower(user: user),
                stors: await locator
                    .get<DioRepository>()
                    .get(path: '/get_data_stors'),
                kinds: await locator
                    .get<DioRepository>()
                    .get(path: '/get_data_kinds'),
                mows: await locator
                    .get<DioRepository>()
                    .get(path: '/get_data_mow'),
                expenses: await locator
                    .get<DioRepository>()
                    .get(path: '/get_data_expense'),
                groups: await locator
                    .get<DioRepository>()
                    .get(path: '/get_data_groups'),
                powers: await locator
                    .get<DioRepository>()
                    .get(path: '/get_data_powers'),
              );
            }
            storage.write(StringsManager.loggedBefore, true);
            await storage.write("loaded_items", false);
            Navigator.of(context).pushReplacementNamed("splash");
          },
        );
      } catch (e) {
        if (e is DioError) {
          String message = DioExceptions.fromDioError(e).toString();
          generalDialog(
            dialogType: DialogType.ERROR,
            context: context,
            title: "error".tr,
            message: message,
            onOkText: "ok".tr,
            onOkColor: Colors.green,
            onOkIcon: const Icon(Icons.check),
          );
        } else {
          generalDialog(
            dialogType: DialogType.ERROR,
            context: context,
            title: "error".tr,
            message: e.toString(),
            onOkText: "ok".tr,
            onOkColor: Colors.green,
            onOkIcon: const Icon(Icons.check),
          );
        }
      } finally {
        EasyLoading.dismiss();
      }
    }
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
    await locator.get<SaveData>().saveOptionsData(input: options);
    await locator.get<SaveData>().saveInfoData(info: info);
    await locator.get<SaveData>().savePowersInfo(powers: userPowers);
    await storage.write("stors", stors);
    await storage.write("kinds", kinds);
    await storage.write("items", items);
    await storage.write("mows", mows);
    await storage.write("expenses", expenses);
    await storage.write("groups", groups);
    await storage.write("customers", customers);
    await storage.write("powers", powers);
    if (types != null) {
      await storage.write("types", types);
    } else {
      await storage.remove("types");
    }
  }
}
