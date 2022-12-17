import 'dart:convert';

import 'package:smart_sales/Data/Models/entity.dart';

List<MowModel> mowModelFromMap(String str) =>
    List<MowModel>.from(json.decode(str).map((x) => MowModel.fromMap(x)));

String mowModelToMap(List<MowModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class MowModel extends Entity {
  MowModel({
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

  MowModel copyWith({
    int? mowId,
    int? mowCode,
    String? mowName,
    int? accId,
    int? priceId,
    String? taxFileNo,
    String? taxRecordNo,
    double? curBalance,
  }) {
    return MowModel(
      id: mowId ?? id,
      code: mowCode ?? code,
      name: mowName ?? name,
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

  Map<String, dynamic> toMap() {
    return {
      'mow_id': id,
      'mow_code': code,
      'mow_name': name,
      'acc_id': accId,
      'price_id': priceId,
      'tax_file_no': taxFileNo,
      'tax_record_no': taxRecordNo,
      'cur_balance': curBalance,
    };
  }

  factory MowModel.fromMap(Map<String, dynamic> map) {
    return MowModel(
      id: map['mow_id']?.toInt() ?? 0,
      code: map['mow_code']?.toInt() ?? 0,
      name: map['mow_name'] ?? '',
      accId: map['acc_id']?.toInt() ?? 0,
      priceId: map['price_id']?.toInt() ?? 0,
      taxFileNo: map['tax_file_no'] ?? "",
      taxRecordNo: map['tax_record_no'] ?? "",
      curBalance: map['cur_balance']?.toDouble() ?? 0.0,
      employAccId: 0,
      maxCredit: 0,
      payByCash: null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MowModel.fromJson(String source) =>
      MowModel.fromMap(json.decode(source));
}
