import 'dart:convert';

import 'package:smart_sales/Data/Models/entity.dart';

List<ExpenseModel> expenseModelFromMap(String str) => List<ExpenseModel>.from(
    json.decode(str).map((x) => ExpenseModel.fromMap(x)));

String expenseModelToMap(List<ExpenseModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class ExpenseModel extends Entity {
  ExpenseModel({
    required super.id,
    required super.code,
    required super.name,
    required super.accId,
    required super.priceId,
    required super.employAccId,
    required super.taxFileNo,
    required super.taxRecordNo,
    required super.maxCredit,
    required super.payByCash,
    required super.curBalance,
  });

  ExpenseModel copyWith({
    int? id,
    int? code,
    String? name,
    int? accId,
    int? priceId,
    String? taxFileNo,
    String? taxRecordNo,
    double? curBalance,
  }) {
    return ExpenseModel(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      accId: accId ?? this.accId,
      priceId: priceId ?? this.priceId,
      taxFileNo: taxFileNo ?? this.taxFileNo,
      taxRecordNo: taxRecordNo ?? this.taxRecordNo,
      curBalance: curBalance ?? this.curBalance,
      employAccId: 0,
      maxCredit: 0.0,
      payByCash: 1,
    );
  }

  factory ExpenseModel.fromMap(Map<String, dynamic> json) => ExpenseModel(
        employAccId: json["gen_acc_id"] ?? 0,
        name: json["acc_name"] ?? '',
        accId: json["acc_id"] ?? 0,
        curBalance: json["cur_balance"] ?? 0.0,
        id: json["acc_id"] ?? 0,
        code: 0,
        maxCredit: 0,
        payByCash: 0,
        priceId: 0,
        taxFileNo: '',
        taxRecordNo: '',
      );

  Map<String, dynamic> toMap() => {
        "gen_acc_id": employAccId,
        "acc_name": name,
        "acc_id": accId,
        "cur_balance": curBalance,
      };
}
