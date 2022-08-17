import 'package:flutter/foundation.dart';
import 'package:smart_sales/App/Util/locator.dart';
import 'package:smart_sales/Data/Database/Commands/save_data.dart';
import 'package:smart_sales/Data/Models/client_model.dart';

class CustomersState extends ChangeNotifier {
  List<ClientModel> customers = [];
  String lastCustomerFetchDate = "";
  ClientModel? currentCustomer;

  void setCurrentCustomer({
    required ClientModel customer,
  }) {
    currentCustomer = customer;
    notifyListeners();
  }

  Future<void> addClient({
    required ClientModel client,
  }) async {
    customers.add(client);
    await locator.get<SaveData>().saveCustomersData(
          input: customers,
        );
  }

  void fillCustomers({
    required List<ClientModel> input,
  }) {
    lastCustomerFetchDate = DateTime.now().toString();
    customers = input;
  }

  Future<double> editCustomer({
    required int id,
    required double amount,
    required int sectionType,
  }) async {
    if (sectionType == 2 || sectionType == 101) {
      double originalAmount =
          customers.firstWhere((element) => element.accId == id).curBalance ??
              0.0;
      customers.firstWhere((element) => element.accId == id).curBalance =
          (originalAmount - amount);
    } else {
      double originalAmount =
          customers.firstWhere((element) => element.accId == id).curBalance ??
              0.0;
      customers.firstWhere((element) => element.accId == id).curBalance =
          (originalAmount + amount);
    }
    await locator.get<SaveData>().saveCustomersData(
          input: customers,
        );
    return customers.firstWhere((element) => element.accId == id).curBalance!;
  }
}
