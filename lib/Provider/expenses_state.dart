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
    required num amount,
    required int sectionType,
    bool? reverse,
  }) async {
    int factor = 1;
    if (reverse ?? false) {
      factor = -1;
    }
    double originalAmount =
        expenses.firstWhere((element) => element.accId == id).curBalance;
    if (sectionType == 108) {
      final ExpenseModel mow =
          expenses.firstWhere((element) => element.accId == id);
      expenses[expenses.indexOf(mow)] = expenses[expenses.indexOf(mow)]
          .copyWith(curBalance: (originalAmount - (amount * factor)));
    } else {
      final ExpenseModel mow =
          expenses.firstWhere((element) => element.accId == id);
      expenses[expenses.indexOf(mow)] = expenses[expenses.indexOf(mow)]
          .copyWith(curBalance: (originalAmount + (amount * factor)));
    }
    await GetStorage().write("expenses", expenseModelToMap(expenses));
    return expenses.firstWhere((element) => element.accId == id).curBalance;
  }
}
