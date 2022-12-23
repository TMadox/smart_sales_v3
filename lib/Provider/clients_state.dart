import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_sales/App/Util/locator.dart';
import 'package:smart_sales/Data/Database/Commands/save_data.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smart_sales/Data/Models/client.dart';
import 'package:smart_sales/Data/Models/options_model.dart';
import 'package:smart_sales/Data/Models/user_model.dart';
import 'package:smart_sales/Provider/options_state.dart';
import 'package:smart_sales/Services/Repositories/dio_repository.dart';

class ClientsState extends ChangeNotifier {
  List<Client> clients = [];
  String lastCustomerFetchDate = "";

  Future<void> addClient({
    required Client client,
  }) async {
    clients.add(client);
    await locator.get<SaveData>().saveCustomersData(
          input: clients,
        );
  }

  Future<String> fetchClients({
    required bool transAllAm,
    required UserModel user,
  }) async {
    final response = transAllAm == false
        ? await DioRepository.to.get(
            path: '/get_data_am_by_employ_acc_id',
            data: {"employ_acc_id": user.defEmployAccId},
          )
        : await DioRepository.to.get(
            path: '/get_data_am',
          );
    await GetStorage().write("customers", response);
    return response;
  }

  void loadClients() {
    clients =
        customersListFromJson(input: GetStorage().read("customers") ?? "[]");
  }

  Future<List<Client>> reloadClients({
    required BuildContext context,
    required UserModel user,
  }) async {
    final OptionsModel transAllAm = context
        .read<OptionsState>()
        .options
        .firstWhere((option) => option.optionId == 5);
    await fetchClients(transAllAm: transAllAm.optionValue == 1, user: user);
    loadClients();
    return clients;
  }

  Future<void> saveClients() async {
    await locator.get<SaveData>().saveCustomersData(
          input: clients,
        );
  }

  Future<double> editCustomer({
    required int id,
    required num amount,
    required int sectionType,
  }) async {
    if (sectionType == 2 || sectionType == 101) {
      double originalAmount =
          clients.firstWhere((element) => element.accId == id).curBalance;
      final Client client =
          clients.firstWhere((element) => element.accId == id);
      clients[clients.indexOf(client)] = clients[clients.indexOf(client)]
          .copyWith(curBalance: (originalAmount - amount));
    } else {
      double originalAmount =
          clients.firstWhere((element) => element.accId == id).curBalance;
      final Client client =
          clients.firstWhere((element) => element.accId == id);
      clients[clients.indexOf(client)] = clients[clients.indexOf(client)]
          .copyWith(curBalance: (originalAmount + amount));
    }
    await locator.get<SaveData>().saveCustomersData(
          input: clients,
        );
    return clients.firstWhere((element) => element.accId == id).curBalance;
  }
}
