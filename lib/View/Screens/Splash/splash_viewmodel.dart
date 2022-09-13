import 'dart:convert';
import 'dart:developer';
import 'package:smart_sales/Data/Models/type_model.dart';
import 'package:smart_sales/View/Widgets/Common/alert_snackbar.dart';
import 'package:universal_io/io.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:smart_sales/App/Util/locator.dart';
import 'package:smart_sales/Data/Database/Commands/read_data.dart';
import 'package:smart_sales/Data/Database/Shared/shared_storage.dart';
import 'package:smart_sales/Data/Models/client_model.dart';
import 'package:smart_sales/Data/Models/expense_model.dart';
import 'package:smart_sales/Data/Models/group_model.dart';
import 'package:smart_sales/Data/Models/item_model.dart';
import 'package:smart_sales/Data/Models/kinds_model.dart';
import 'package:smart_sales/Data/Models/mow_model.dart';
import 'package:smart_sales/Data/Models/options_model.dart';
import 'package:smart_sales/Data/Models/stor_model.dart';
import 'package:smart_sales/Data/Models/user_model.dart';
import 'package:smart_sales/Provider/clients_state.dart';
import 'package:smart_sales/Provider/expenses_state.dart';
import 'package:smart_sales/Provider/general_state.dart';
import 'package:smart_sales/Provider/groups_state.dart';
import 'package:smart_sales/Provider/info_state.dart';
import 'package:smart_sales/Provider/kinds_state.dart';
import 'package:smart_sales/Provider/mow_state.dart';
import 'package:smart_sales/Provider/options_state.dart';
import 'package:smart_sales/Provider/powers_state.dart';
import 'package:smart_sales/Provider/stor_state.dart';
import 'package:smart_sales/Provider/user_state.dart';
import 'package:smart_sales/Services/Repositories/general_repository.dart';
import 'package:smart_sales/View/Screens/Home/home_view.dart';
import 'package:smart_sales/View/Screens/Items/Items_viewmodel.dart';
import 'package:smart_sales/View/Screens/Login/login_screen.dart';
import 'package:smart_sales/View/Screens/Settings/settings_viewmodel.dart';
import '../../../Data/Models/info_model.dart';

class SplashViewmodel extends ChangeNotifier {
  loadingFunction(BuildContext context) async {
    //get instance of the shared storage
    final instance = locator.get<SharedStorage>();
    //get stored user info
    String? user = instance.prefs.getString("user");
    //get login info that is going to be used in logging in and inject it into the instance of userstate
    context.read<UserState>().setLoginInfo(
      input: {
        "ip_password": instance.ipPassword,
        "ip_address": instance.ipAddress,
        "user_id": instance.userId,
      },
    );

    //if the platform is web then do some changes.
    if (!kIsWeb) {
      if (Platform.isIOS || Platform.isAndroid) {
        if (await Permission.location.isDenied) {
          await Permission.location.request();
        }
      }
    }
    //if the user is null, that means that the user hasn't logged in yet. xfere him to login screen
    if (user == null) {
      return const LoginScreen();
    } else {
      try {
        //Check if author wants the user to login only within set period
        if (instance.prefs.getBool("allow_shift") ?? false) {
          if (instance.prefs.containsKey("shift_end_time") &&
              instance.prefs.containsKey("shift_start_time")) {
            DateTime startDate =
                DateTime.parse(instance.prefs.getString("shift_start_time")!);
            DateTime endDate =
                DateTime.parse(instance.prefs.getString("shift_end_time")!);
            DateTime now = DateTime(
              1,
              1,
              1,
              DateTime.now().hour,
              DateTime.now().minute,
              DateTime.now().second,
              DateTime.now().millisecond,
              DateTime.now().microsecond,
            );
            log("end date" + endDate.toString());
            log("start date" + startDate.toString());
            log("now date" + now.toString());
            if ((startDate.isBefore(now) && endDate.isAfter(now)) == false) {
              showAlertSnackbar(
                  context: context, text: "لا يمكن الدخول في غير ساعات العمل");
              throw "error";
            }
          }
        }
        //start reading stored data then inject them in their prespective instances
        await context.read<SplashViewmodel>().readStoredData(
              context: context,
              user: userModelFromString(str: user),
              reference: instance,
            );
        //define values for the general repository to be used in api calls
        locator.get<GeneralRepository>().init(
              context: context,
              ipAddress: userModelFromString(str: user).ipAddress,
              ipPassword: userModelFromString(str: user).ipPassword,
            );
        return const HomeScreen();
      } catch (e) {
        log(e.toString());
        //if the process fails, go to login screen again.
        return const LoginScreen();
      }
    }
  }

  readStoredData({
    required BuildContext context,
    required UserModel user,
    required SharedStorage reference,
  }) async {
    final customersList = customersListFromJson(
        input: locator.get<ReadData>().readCustomersData()!);
    List<ItemsModel> itemsList =
        itemsListFromJson(input: locator.get<ReadData>().readItemsData()!);
    final List<Map> receiptsList = List<Map>.from(
        json.decode(locator.get<ReadData>().readReceiptsData() ?? "[]"));
    final List<OptionsModel> optionsList = optionsListFromJson(
        input: locator.get<ReadData>().readOptionsData() ?? "[]");
    final info =
        infoModelFromMap(locator.get<ReadData>().readInfoData() ?? "[]");

    final Map finalreceipt = locator.get<ReadData>().loadLastId();
    final stors = storModelFromJson(reference.prefs.getString("stors")!);
    final kinds = kindModelFromJson(reference.prefs.getString("kinds")!);
    final mows = mowModelFromMap(reference.prefs.getString("mows")!);
    final expenses =
        expenseModelFromMap(reference.prefs.getString("expenses")!);
    final groups = groupModelFromJson(reference.prefs.getString("groups")!);
    List<TypeModel> types = [];
    if (reference.prefs.getString("types") != null) {
      types = typeModelFromJson(reference.prefs.getString("types")!);
      if (types.length != itemsList.length) {
        List<ItemsModel> tempItems = [];
        for (var type in types) {
          ItemsModel item = itemsList
              .firstWhere(
                (element) => element.typeId == type.typeId,
              )
              .copyWith();
          item = item.copyWith(
            curQty0: (type.curQty0 / item.unitConvert),
            curQty: (type.curQty0 / item.unitConvert),
            storId: type.storId,
          );
          tempItems.add(item);
        }
        itemsList = List.from(tempItems);
      }
    }
    context.read<SettingsViewmodel>().getStoredPrintingData();
    injectData(
      context: context,
      customers: customersList,
      items: itemsList,
      user: user,
      finalReceipt: finalreceipt,
      receipts: receiptsList,
      options: optionsList,
      info: info,
      stors: stors,
      kinds: kinds,
      mows: mows,
      expenses: expenses,
      groups: groups,
      types: types,
    );
  }

  Future<dynamic> timeoutAfter(
      {required int sec, required Function() onTimeout}) async {
    return Future.delayed(Duration(seconds: sec), onTimeout);
  }

  injectData({
    required UserModel user,
    required List<ClientsModel> customers,
    required Map finalReceipt,
    required List<ItemsModel> items,
    required BuildContext context,
    required List<OptionsModel> options,
    required InfoModel info,
    required List<Map> receipts,
    required List<StorModel> stors,
    required List<KindsModel> kinds,
    required List<MowModel> mows,
    required List<ExpenseModel> expenses,
    required List<GroupModel> groups,
    required List<TypeModel> types,
  }) {
    context.read<ItemsViewmodel>().fillTypeQty(input: types);
    context.read<ItemsViewmodel>().fillItems(input: items);
    context.read<ClientsState>().fillCustomers(input: customers);
    context.read<UserState>().setLoggedUser(input: user);
    context.read<GeneralState>().fillReceiptsList(input: receipts);
    context.read<OptionsState>().fillOptions(input: options);
    context.read<InfoState>().fillInfo(input: info);
    context.read<PowersState>().fillPowers();
    context.read<GeneralState>().setfinalReceipts(finalReceipt);
    context.read<StoreState>().fillStors(input: stors, context: context);
    context.read<KindsState>().fillKinds(input: kinds);
    context.read<MowState>().fillMows(input: mows);
    context.read<ExpenseState>().fillExpenses(input: expenses);
    context.read<GroupsState>().fillGroups(input: groups);
  }
}
