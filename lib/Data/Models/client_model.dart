// To parse this JSON data, do
//
//     final customerModel = customerModelFromJson(jsonString);

import 'dart:convert';

ClientModel customerModelFromString({required String str}) {
  return ClientModel.fromMap(json.decode(str));
}

String customersJsonFromList({required List<ClientModel> data}) => json.encode(
      data.map<Map<String, dynamic>>((number) => number.toMap()).toList(),
    );

String customerStringFromModel({required ClientModel input}) {
  return json.encode(input.toMap());
}

List<ClientModel> customersListFromJson({required String input}) =>
    (json.decode(input) as List)
        .map<ClientModel>(
          (number) => ClientModel.fromMap(
            number,
          ),
        )
        .toList();

class ClientModel {
  ClientModel({
    this.amId,
    this.amCode,
    this.amName,
    this.accId,
    this.priceId,
    this.employAccId,
    this.taxFileNo,
    this.taxRecordNo,
    this.maxCredit,
    this.curBalance,
  });

  final int? amId;
  final int? amCode;
  final String? amName;
  final int? accId;
  final int? priceId;
  final int? employAccId;
  final String? taxFileNo;
  final String? taxRecordNo;
  double? maxCredit;
  double? curBalance;

  factory ClientModel.fromMap(
    Map<String, dynamic> json,
  ) =>
      ClientModel(
        amId: json["am_id"] ?? 0,
        amCode: json["am_code"] ?? 0,
        amName: json["am_name"] ?? "",
        accId: json["acc_id"] ?? 0,
        priceId: json["price_id"] ?? 0,
        employAccId: json["employ_acc_id"] ?? 0,
        taxFileNo: json["tax_file_no"] ?? "......",
        taxRecordNo: json["tax_record_no"] ?? "",
        maxCredit: json["max_credit"] ?? 0.0,
        curBalance: json["cur_balance"] ?? 0.0,
      );

  Map<String, dynamic> toMap() => {
        "am_id": amId,
        "am_code": amCode,
        "am_name": amName,
        "acc_id": accId,
        "price_id": priceId,
        "employ_acc_id": employAccId,
        "tax_file_no": taxFileNo,
        "tax_record_no": taxRecordNo,
        "max_credit": maxCredit,
        "cur_balance": curBalance,
      };
}
