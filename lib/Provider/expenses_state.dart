import 'package:flutter/material.dart';
import 'package:smart_sales/App/Util/locator.dart';
import 'package:smart_sales/Data/Database/Shared/shared_storage.dart';
import 'package:smart_sales/Data/Models/expense_model.dart';

class ExpenseState extends ChangeNotifier {
  List<ExpenseModel> expenses = [];

  void fillExpenses({required List<ExpenseModel> input}) {
    expenses = List.from(input);
  }

  Future<double> editExpenses({
    required int id,
    required double amount,
    required int sectionType,
  }) async {
    double originalAmount =
        expenses.firstWhere((element) => element.accId == id).curBalance;
    if (sectionType == 108) {
      expenses.firstWhere((element) => element.accId == id).curBalance =
          (originalAmount - amount);
    } else {
      expenses.firstWhere((element) => element.accId == id).curBalance =
          (originalAmount + amount);
    }
    await locator
        .get<SharedStorage>()
        .prefs
        .setString("expenses", expenseModelToMap(expenses));
    return expenses.firstWhere((element) => element.accId == id).curBalance;
  }
}
