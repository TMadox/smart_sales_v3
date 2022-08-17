// To parse this JSON data, do
//
//      mowModel = mowModelFromJson(jsonString);

import 'dart:convert';

List<MowModel> mowModelFromMap(String str) =>
    List<MowModel>.from(json.decode(str).map((x) => MowModel.fromMap(x)));

String mowModelToMap(List<MowModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class MowModel {
  MowModel({
    required this.mowId,
    required this.mowCode,
    required this.mowName,
    required this.accId,
    required this.priceId,
    required this.taxFileNo,
    required this.taxRecordNo,
    required this.curBalance,
  });

   int mowId;
   int mowCode;
   String mowName;
   int accId;
   int priceId;
   String taxFileNo;
   String taxRecordNo;
   double curBalance;

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
      mowId: mowId ?? this.mowId,
      mowCode: mowCode ?? this.mowCode,
      mowName: mowName ?? this.mowName,
      accId: accId ?? this.accId,
      priceId: priceId ?? this.priceId,
      taxFileNo: taxFileNo ?? this.taxFileNo,
      taxRecordNo: taxRecordNo ?? this.taxRecordNo,
      curBalance: curBalance ?? this.curBalance,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'mow_id': mowId,
      'mow_code': mowCode,
      'mow_name': mowName,
      'acc_id': accId,
      'price_id': priceId,
      'tax_file_no': taxFileNo,
      'tax_record_no': taxRecordNo,
      'cur_balance': curBalance,
    };
  }

  factory MowModel.fromMap(Map<String, dynamic> map) {
    return MowModel(
      mowId: map['mow_id']?.toInt() ?? 0,
      mowCode: map['mow_code']?.toInt() ?? 0,
      mowName: map['mow_name'] ?? '',
      accId: map['acc_id']?.toInt() ?? 0,
      priceId: map['price_id']?.toInt() ?? 0,
      taxFileNo: map['tax_file_no'] ?? "",
      taxRecordNo: map['tax_record_no'] ?? "",
      curBalance: map['cur_balance']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory MowModel.fromJson(String source) =>
      MowModel.fromMap(json.decode(source));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MowModel &&
        other.mowId == mowId &&
        other.mowCode == mowCode &&
        other.mowName == mowName &&
        other.accId == accId &&
        other.priceId == priceId &&
        other.taxFileNo == taxFileNo &&
        other.taxRecordNo == taxRecordNo &&
        other.curBalance == curBalance;
  }

  @override
  int get hashCode {
    return mowId.hashCode ^
        mowCode.hashCode ^
        mowName.hashCode ^
        accId.hashCode ^
        priceId.hashCode ^
        taxFileNo.hashCode ^
        taxRecordNo.hashCode ^
        curBalance.hashCode;
  }
}
