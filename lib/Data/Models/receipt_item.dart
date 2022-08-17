// To parse this JSON data, do
//
//     final receiptItemModel = receiptItemModelFromMap(jsonString);

import 'dart:convert';

ReceiptItemModel receiptItemModelFromMap(String str) =>
    ReceiptItemModel.fromMap(json.decode(str));

String receiptItemModelToMap(ReceiptItemModel data) =>
    json.encode(data.toMap());

class ReceiptItemModel {
  ReceiptItemModel({
    this.fatDetId,
    this.operId,
    this.unitId,
    this.unitConvert,
    this.fatItemNo,
    this.fatQty,
    this.fatPrice,
    this.fatDiscPer,
    this.fatDiscValue,
    this.fatDiscPer2,
    this.fatDiscValue2,
    this.fatDiscPer3,
    this.fatDiscValue3,
    this.fatAddPer,
    this.fatAddValue,
    this.fatAddPriceValue,
    this.fatDiscPrice,
    this.fatNetPrice,
    this.fatValue,
    this.fatNetValue,
    this.fatProfit,
    this.profict,
    this.freeQty,
    this.name,
  });

  final int? fatDetId;
  final int? operId;
  final int? unitId;
  final double? unitConvert;
  final int? fatItemNo;
  final int? fatQty;
  final double? fatPrice;
  final double? fatDiscPer;
  final double? fatDiscValue;
  final double? fatDiscPer2;
  final double? fatDiscValue2;
  final double? fatDiscPer3;
  final double? fatDiscValue3;
  final double? fatAddPer;
  final double? fatAddValue;
  final double? fatAddPriceValue;
  final double? fatDiscPrice;
  final double? fatNetPrice;
  final double? fatValue;
  final double? fatNetValue;
  final double? fatProfit;
  final double? profict;
  final int? freeQty;
  final String? name;

  factory ReceiptItemModel.fromMap(Map<String, dynamic> json) =>
      ReceiptItemModel(
        fatDetId: json["fat_det_id"],
        operId: json["oper_id"],
        unitId: json["unit_id"],
        unitConvert: json["unit_convert"],
        fatItemNo: json["fat_item_no"],
        fatQty: json["fat_qty"],
        fatPrice: json["fat_price"],
        fatDiscPer: json["fat_disc_per"],
        fatDiscValue: json["fat_disc_value"],
        fatDiscPer2: json["fat_disc_per2"],
        fatDiscValue2: json["fat_disc_value2"],
        fatDiscPer3: json["fat_disc_per3"],
        fatDiscValue3: json["fat_disc_value3"],
        fatAddPer: json["fat_add_per"],
        fatAddValue: json["fat_add_value"],
        fatAddPriceValue: json["fat_add_price_value"],
        fatDiscPrice: json["fat_disc_price"],
        fatNetPrice: json["fat_net_price"],
        fatValue: json["fat_value"],
        fatNetValue: json["fat_net_value"],
        fatProfit: json["fat_profit"],
        profict: json["profict"],
        freeQty: json["free_qty"],
        name: json["name"],
      );

  Map<String, dynamic> toMap() => {
        "fat_det_id": fatDetId,
        "oper_id": operId,
        "unit_id": unitId,
        "unit_convert": unitConvert,
        "fat_item_no": fatItemNo,
        "fat_qty": fatQty,
        "fat_price": fatPrice,
        "fat_disc_per": fatDiscPer,
        "fat_disc_value": fatDiscValue,
        "fat_disc_per2": fatDiscPer2,
        "fat_disc_value2": fatDiscValue2,
        "fat_disc_per3": fatDiscPer3,
        "fat_disc_value3": fatDiscValue3,
        "fat_add_per": fatAddPer,
        "fat_add_value": fatAddValue,
        "fat_add_price_value": fatAddPriceValue,
        "fat_disc_price": fatDiscPrice,
        "fat_net_price": fatNetPrice,
        "fat_value": fatValue,
        "fat_net_value": fatNetValue,
        "fat_profit": fatProfit,
        "profict": profict,
        "free_qty": freeQty,
        "name": name,
      };
}
