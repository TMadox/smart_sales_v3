import 'dart:convert';

List<ExpenseModel> expenseModelFromMap(String str) => List<ExpenseModel>.from(
    json.decode(str).map((x) => ExpenseModel.fromMap(x)));

String expenseModelToMap(List<ExpenseModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class ExpenseModel {
  ExpenseModel({
    required this.genAccId,
    required this.accName,
    required this.accId,
    required this.curBalance,
  });

   int genAccId;
   String accName;
   int accId;
   double curBalance;

  factory ExpenseModel.fromMap(Map<String, dynamic> json) => ExpenseModel(
        genAccId: json["gen_acc_id"] ?? 0,
        accName: json["acc_name"] ?? '',
        accId: json["acc_id"] ?? 0,
        curBalance: json["cur_balance"] ?? 0.0,
      );

  Map<String, dynamic> toMap() => {
        "gen_acc_id": genAccId,
        "acc_name": accName,
        "acc_id": accId,
        "cur_balance": curBalance,
      };
}
