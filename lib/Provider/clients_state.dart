import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_sales/App/Util/locator.dart';
import 'package:smart_sales/Data/Database/Commands/save_data.dart';
import 'package:smart_sales/Data/Models/client_model.dart';
import 'package:smart_sales/Data/Models/options_model.dart';
import 'package:smart_sales/Data/Models/user_model.dart';
import 'package:smart_sales/Provider/options_state.dart';
import 'package:smart_sales/Services/Repositories/general_repository.dart';

class ClientsState extends ChangeNotifier {
  List<ClientsModel> clients = [];
  String lastCustomerFetchDate = "";
  ClientsModel? currentClient;

  void setCurrentCustomer({
    required ClientsModel customer,
  }) {
    currentClient = customer;
    notifyListeners();
  }

  Future<void> addClient({
    required ClientsModel client,
  }) async {
    clients.add(client);
    await locator.get<SaveData>().saveCustomersData(
          input: clients,
        );
  }

  void fillCustomers({
    required List<ClientsModel> input,
  }) {
    lastCustomerFetchDate = DateTime.now().toString();
    clients = input;
  }

  Future<void> refillClients({
    required BuildContext context,
    required UserModel user,
  }) async {
    final OptionsModel transAllAm = context
        .read<OptionsState>()
        .options
        .firstWhere((option) => option.optionId == 5);
    clients = transAllAm.optionValue == 0
        ? customersListFromJson(
            input: await locator.get<GeneralRepository>().get(
              path: '/get_data_am_by_employ_acc_id',
              data: {"employ_acc_id": user.defEmployAccId},
            ),
          )
        : customersListFromJson(
            input: await locator.get<GeneralRepository>().get(
                  path: '/get_data_am',
                ),
          );
    await locator.get<SaveData>().saveCustomersData(
          input: clients,
        );
  }

  Future<void> saveClients() async {
    await locator.get<SaveData>().saveCustomersData(
          input: clients,
        );
  }

  Future<double> editCustomer({
    required int id,
    required double amount,
    required int sectionType,
  }) async {
    if (sectionType == 2 || sectionType == 101) {
      double originalAmount =
          clients.firstWhere((element) => element.accId == id).curBalance ??
              0.0;
      clients.firstWhere((element) => element.accId == id).curBalance =
          (originalAmount - amount);
    } else {
      double originalAmount =
          clients.firstWhere((element) => element.accId == id).curBalance ??
              0.0;
      clients.firstWhere((element) => element.accId == id).curBalance =
          (originalAmount + amount);
    }
    await locator.get<SaveData>().saveCustomersData(
          input: clients,
        );
    return clients.firstWhere((element) => element.accId == id).curBalance!;
  }
}
