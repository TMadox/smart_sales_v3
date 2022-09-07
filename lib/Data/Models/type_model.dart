// To parse this JSON data, do
//
//     final stors = storsFromJson(jsonString);

import 'dart:convert';

List<TypeModel> typeModelFromJson(String str) =>
    List<TypeModel>.from(json.decode(str).map((x) => TypeModel.fromJson(x)));

String typeModelToJson(List<TypeModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TypeModel {
  TypeModel({
    required this.qtyId,
    required this.typeId,
    required this.itemId,
    required this.storId,
    required this.curQty0,
    required this.noInQty,
  });

  final num qtyId;
  final num typeId;
  final num itemId;
  final num storId;
  final num curQty0;
  final num noInQty;

  factory TypeModel.fromJson(Map<String, dynamic> json) => TypeModel(
        qtyId: json["qty_id"] ?? 0,
        typeId: json["type_id"] ?? 0,
        itemId: json["item_id"] ?? 0,
        storId: json["stor_id"] ?? 0,
        curQty0: json["cur_qty0"] ?? 0.0,
        noInQty: json["no_in_qty"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "qty_id": qtyId,
        "type_id": typeId,
        "item_id": itemId,
        "stor_id": storId,
        "cur_qty0": curQty0,
        "no_in_qty": noInQty,
      };
}
