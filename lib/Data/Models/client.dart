import 'dart:convert';
import 'package:smart_sales/Data/Models/entity.dart';

Client customerModelFromString({required String str}) {
  return Client.fromMap(json.decode(str));
}

String customersJsonFromList({required List<Client> data}) => json.encode(
      data.map<Map<String, dynamic>>((number) => number.toMap()).toList(),
    );

String customerStringFromModel({required Client input}) {
  return json.encode(input.toMap());
}

List<Client> customersListFromJson({required String input}) =>
    (json.decode(input) as List)
        .map<Client>(
          (number) => Client.fromMap(
            number,
          ),
        )
        .toList();

class Client extends Entity {
  Client({
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

  factory Client.fromMap(
    Map<String, dynamic> json,
  ) =>
      Client(
        id: json["am_id"] ?? 0,
        code: json["am_code"] ?? 0,
        name: json["am_name"] ?? "",
        accId: json["acc_id"] ?? 0,
        payByCash: json["pay_by_cash_only"] ?? 0,
        priceId: json["price_id"] ?? 0,
        employAccId: json["employ_acc_id"] ?? 0,
        taxFileNo: json["tax_file_no"] ?? "......",
        taxRecordNo: json["tax_record_no"] ?? "",
        maxCredit: json["max_credit"] ?? 0.0,
        curBalance: json["cur_balance"] ?? 0.0,
      );

  Map<String, dynamic> toMap() => {
        "am_id": id,
        "am_code": code,
        "am_name": name,
        "acc_id": accId,
        "price_id": priceId,
        "employ_acc_id": employAccId,
        "pay_by_cash_only": payByCash,
        "tax_file_no": taxFileNo,
        "tax_record_no": taxRecordNo,
        "max_credit": maxCredit,
        "cur_balance": curBalance,
      };

  Client copyWith({
    int? mowId,
    int? mowCode,
    String? mowName,
    int? accId,
    int? priceId,
    String? taxFileNo,
    String? taxRecordNo,
    double? curBalance,
    int? employAccId,
    double? maxCredit,
    double? payByCash,
  }) {
    return Client(
      id: mowId ?? id,
      code: mowCode ?? code,
      name: mowName ?? name,
      accId: accId ?? this.accId,
      priceId: priceId ?? this.priceId,
      taxFileNo: taxFileNo ?? this.taxFileNo,
      taxRecordNo: taxRecordNo ?? this.taxRecordNo,
      curBalance: curBalance ?? this.curBalance,
      employAccId: employAccId ?? this.employAccId,
      maxCredit: maxCredit ?? this.maxCredit,
      payByCash: payByCash ?? this.payByCash,
    );
  }
}
