import 'dart:convert';

import 'package:smart_sales/Data/Models/entity.dart';

List<Employee> employeeFromMap(String str) =>
    List<Employee>.from(json.decode(str).map((x) => Employee.fromJson(x)));

String employeeToMap(List<Employee> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Employee extends Entity {
  Employee({
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

  factory Employee.fromJson(Map<String, dynamic> json) => Employee(
        id: json["employ_id"] ?? 0,
        name: json["employ_name"] ?? "",
        accId: json["acc_id"] ?? 0,
        code: 0,
        curBalance: 0,
        employAccId: 0,
        maxCredit: 0,
        payByCash: 0,
        priceId: 0,
        taxFileNo: '',
        taxRecordNo: '',
      );

  Map<String, dynamic> toJson() => {
        "employ_id": id,
        "employ_name": name,
        "acc_id": accId,
      };
}
