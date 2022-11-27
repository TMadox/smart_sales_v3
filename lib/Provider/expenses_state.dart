import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
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
    await GetStorage().write("expenses", expenseModelToMap(expenses));
    return expenses.firstWhere((element) => element.accId == id).curBalance;
  }
}
