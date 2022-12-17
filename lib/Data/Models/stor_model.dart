import 'dart:convert';

import 'package:smart_sales/Data/Models/entity.dart';

List<StorModel> storModelFromJson(String str) => List<StorModel>.from(
    json.decode(str).map((x) => StorModel.fromJson(json.encode(x))));

String storModelToJson(List<StorModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StorModel extends Entity {
  StorModel({
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

  Map<String, dynamic> toMap() {
    return {
      'stor_id': id,
      'stor_code': code,
      'stor_name': name,
    };
  }

  factory StorModel.fromMap(Map<String, dynamic> map) {
    return StorModel(
      id: map['stor_id'] ?? 0,
      name: map['stor_name'] ?? "",
      code: map['stor_code'] ?? 0,
      accId: 0,
      curBalance: 0,
      employAccId: 0,
      maxCredit: 0,
      payByCash: 0,
      priceId: 0,
      taxFileNo: '',
      taxRecordNo: '',
    );
  }

  String toJson() => json.encode(toMap());

  factory StorModel.fromJson(String source) =>
      StorModel.fromMap(json.decode(source));
}
