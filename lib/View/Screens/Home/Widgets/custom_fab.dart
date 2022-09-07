import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hawk_fab_menu/hawk_fab_menu.dart';
import 'package:provider/provider.dart';
import 'package:smart_sales/App/Util/device.dart';
import 'package:smart_sales/App/Util/locator.dart';
import 'package:smart_sales/App/Util/routing.dart';
import 'package:smart_sales/Data/Database/Commands/save_data.dart';
import 'package:smart_sales/Data/Database/Shared/shared_storage.dart';
import 'package:smart_sales/Data/Models/client_model.dart';
import 'package:smart_sales/Data/Models/item_model.dart';
import 'package:smart_sales/Data/Models/options_model.dart';
import 'package:smart_sales/Data/Models/user_model.dart';
import 'package:smart_sales/Provider/clients_state.dart';
import 'package:smart_sales/Provider/general_state.dart';
import 'package:smart_sales/Provider/options_state.dart';
import 'package:smart_sales/Provider/user_state.dart';
import 'package:smart_sales/Services/Helpers/exceptions.dart';
import 'package:smart_sales/Services/Repositories/check_allowance_repo.dart';
import 'package:smart_sales/Services/Repositories/customers_repo.dart';
import 'package:smart_sales/Services/Repositories/delete_repo.dart';
import 'package:smart_sales/Services/Repositories/general_repository.dart';
import 'package:smart_sales/Services/Repositories/items_repo.dart';
import 'package:smart_sales/View/Screens/Home/home_viewmodel.dart';
import 'package:smart_sales/View/Screens/Items/Items_viewmodel.dart';
import 'package:smart_sales/View/Widgets/Common/common_button.dart';
import 'package:smart_sales/View/Widgets/Common/custom_textfield.dart';
import 'package:smart_sales/View/Widgets/Dialogs/error_dialog.dart';
import 'package:smart_sales/View/Widgets/Dialogs/general_snackbar.dart';
import 'package:smart_sales/View/Widgets/Dialogs/loading_dialog.dart';

class CustomFAB extends StatefulWidget {
  final Widget child;
  const CustomFAB({Key? key, required this.child}) : super(key: key);

  @override
  State<CustomFAB> createState() => _CustomFABState();
}

class _CustomFABState extends State<CustomFAB> {
  final HomeViewmodel _homeViewmodel = HomeViewmodel();
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);
  String password = "";
  @override
  Widget build(BuildContext context) {
    return HawkFabMenu(
      buttonBorder: const BorderSide(
        color: Color(0xFF074fb3),
        width: 4,
      ),
      fabColor: Colors.white,
      iconColor: const Color(0xFF074fb3),
      items: [
        HawkFabMenuItem(
          label: 'request_reload'.tr,
          ontap: () async {
            EasyLoading.show();
            await _homeViewmodel.newRequest(context);
            EasyLoading.dismiss();
          },
          icon: const Icon(Icons.request_page),
          color: Colors.indigo,
        ),
        HawkFabMenuItem(
          label: 'update_items_accounts'.tr,
          ontap: () async {
            await updateInfo(context: context);
          },
          icon: const Icon(Icons.upgrade),
          color: Colors.cyan,
        ),
        HawkFabMenuItem(
          label: 'update_items_accounts_with_amount'.tr,
          ontap: () async {
            await retrieveNewInfo(context);
          },
          icon: const Icon(Icons.update),
          color: Colors.orange,
        ),
        HawkFabMenuItem(
          label: 'settings'.tr,
          ontap: () async {
            AwesomeDialog(
              context: context,
              dialogType: DialogType.INFO_REVERSED,
              animType: AnimType.SCALE,
              body: Column(
                children: [
                  Text(
                    "wait".tr,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  CustomTextField(
                    hintText: 'enter_api_password'.tr,
                    name: 'ip_password',
                    activated: true,
                    onChanged: (text) {
                      password = text.toString();
                    },
                  ),
                ],
              ),
              btnOk: CommonButton(
                onPressed: () {
                  if (password ==
                      context.read<UserState>().user.ipPassword.toString()) {
                    password = "";
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed(Routes.settingsRoute);
                  }
                },
                title: "enter".tr,
                icon: const Icon(
                  Icons.login,
                ),
                color: Colors.blue,
              ),
            ).show();
          },
          icon: const Icon(Icons.settings),
          color: Colors.green,
        ),
        HawkFabMenuItem(
          label: "exit".tr,
          ontap: () async {
            // locator.get<ReadData>().box.clear();
            await locator.get<SharedStorage>().prefs.remove("user");
            context.read<UserState>().setLoggedUser(input: UserModel());
            Navigator.of(context).pushReplacementNamed('/');
          },
          icon: const Icon(Icons.logout),
          color: Colors.red,
        ),
      ],
      body: widget.child,
    );
  }

  retrieveNewInfo(BuildContext context) async {
    try {
      isDialOpen.value = false;
      EasyLoading.show();
      final user = context.read<UserState>().user;
      if (context.read<GeneralState>().receiptsList.isNotEmpty &&
          context
              .read<GeneralState>()
              .receiptsList
              .where((element) => element["is_sender_complete_status"] == 0)
              .isNotEmpty) {
        showErrorDialog(
          context: context,
          title: "error".tr,
          description: "operations_not_uploaded_yet".tr,
        );
      } else {
        switch (await locator
            .get<CheckAllowanceRepo>()
            .requestCheckAllowance(context)) {
          case 0:
            throw "can't_get_yet".tr;
          case 7:
            throw "no_request_found".tr;
          case 1:
            {
              await context
                  .read<ItemsViewmodel>()
                  .refillItems(context: context, user: user);
              await context
                  .read<ClientsState>()
                  .refillClients(context: context, user: user);
            }
            break;
          default:
        }
        responseSnackbar(
          context,
          "reload_successful".tr,
        );
      }
    } catch (e) {
      if (e is DioError) {
        String message = DioExceptions.fromDioError(e).toString();
        showErrorDialog(
            context: context, description: message, title: "error".tr);
      } else {
        showErrorDialog(
            context: context, description: e.toString(), title: "error".tr);
      }
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> updateInfo({required BuildContext context}) async {
    try {
      isDialOpen.value = false;
      showLoaderDialog(context);
      final user = context.read<UserState>().user;
      compare(
        await locator.get<ItemRepo>().requestItems(
              ip: user.ipAddress,
              ipPassword: user.ipPassword,
              storeId: user.defStorId,
            ),
        await locator.get<CustomersRepo>().requestCustomers(
              ipAddress: user.ipAddress,
              employerId: user.defEmployAccId,
              ipPassword: user.ipPassword,
            ),
      );
      await context.read<ItemsViewmodel>().saveItems();
      await context.read<ClientsState>().saveClients();
      Get.back();
      responseSnackbar(context, "update_successful".tr);
    } catch (e) {
      Get.back();
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
    }
  }

  deleteReceipts(BuildContext context) async {
    try {
      if (context.read<GeneralState>().receiptsList.isNotEmpty &&
          context
              .read<GeneralState>()
              .receiptsList
              .where((element) => element["is_sender_complete_status"] == 0)
              .isNotEmpty) {
        Get.back();
        showErrorDialog(
          context: context,
          title: "error".tr,
          description: "operations_not_uploaded_yet".tr,
        );
      } else {
        if (await locator.get<DeleteRepo>().requestDeleteRepo(
              context: context,
            )) {
          throw "operations_not_exported_yet".tr;
        }
        responseSnackbar(context, "operations_deleted".tr);
      }
    } catch (e) {
      if (e is DioError) {
        String message = DioExceptions.fromDioError(e).toString();
        showErrorDialog(
            context: context, description: message, title: "error".tr);
      } else {
        showErrorDialog(
          context: context,
          description: e.toString(),
          title: "error".tr,
        );
      }
    }
  }

  // saveData({
  //   required List<ItemsModel> items,
  //   required List<ClientModel> customers,
  // }) async {
  //   await locator.get<SaveData>().saveItemsData(input: items);
  //   await locator.get<SaveData>().saveCustomersData(input: customers);
  // }

  compare(List<ItemsModel> items, List<ClientsModel> customers) {
    final currentCustomers = context.read<ClientsState>().clients;
    final currentItems = context.read<ItemsViewmodel>().items;
    for (var newItem in items) {
      if (currentItems
          .where((currentItem) => currentItem.unitId == newItem.unitId)
          .isEmpty) {
        currentItems.add(newItem);
      } else {
        ItemsModel matchingItem = currentItems
            .firstWhere((element) => element.unitId == newItem.unitId);
        if (matchingItem.itemName != newItem.itemName) {
          int index = currentItems.indexOf(matchingItem);
          currentItems[index].itemName = newItem.itemName;
        }
      }
    }
    for (var newCustomer in customers) {
      if (currentCustomers
          .where(
              (currentCustomer) => currentCustomer.accId == newCustomer.accId!)
          .isEmpty) {
        currentCustomers.add(newCustomer);
      }
    }
  }
}
