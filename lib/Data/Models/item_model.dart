import 'dart:convert';

ItemsModel itemsModelFromJson({required String str}) =>
    ItemsModel.fromMap(json.decode(str));

String itemsJsonFromList({required List<ItemsModel> data}) => json.encode(
    data.map<Map<String, dynamic>>((number) => number.toMap()).toList());

List<ItemsModel> itemsListFromJson({required String input}) =>
    (json.decode(input) as List<dynamic>)
        .map<ItemsModel>((number) => ItemsModel.fromMap(number))
        .toList();

class ItemsModel {
  final int unitId;
  final int typeId;
  final String itemCode;
  String itemName;
  final String unitBarcode;
  final double genLowOutPer;
  final double kindId;
  final double groupId;
  final double outPrice;
  final double lowOutPer;
  final double outPrice2;
  final double lowOutPer2;
  final double outPrice3;
  final double lowOutPer3;
  final double outPrice4;
  final double lowOutPer4;
  final double outPrice5;
  final double lowOutPer5;
  final double outPrice6;
  final double lowOutPer6;
  final double outPrice7;
  final double lowOutPer7;
  final double outPrice8;
  final double lowOutPer8;
  final double marPrice;
  final double defOverPrice;
  final double avPrice;
  final double laPrice;
  final double unitConvert;
  final String unitName;
  num storId;
  final double taxPer;
  num curQty0;
  num curQty;
  ItemsModel({
    required this.unitId,
    required this.typeId,
    required this.itemCode,
    required this.itemName,
    required this.unitBarcode,
    required this.genLowOutPer,
    required this.kindId,
    required this.groupId,
    required this.outPrice,
    required this.lowOutPer,
    required this.outPrice2,
    required this.lowOutPer2,
    required this.outPrice3,
    required this.lowOutPer3,
    required this.outPrice4,
    required this.lowOutPer4,
    required this.outPrice5,
    required this.lowOutPer5,
    required this.outPrice6,
    required this.lowOutPer6,
    required this.outPrice7,
    required this.lowOutPer7,
    required this.outPrice8,
    required this.lowOutPer8,
    required this.marPrice,
    required this.defOverPrice,
    required this.avPrice,
    required this.laPrice,
    required this.unitConvert,
    required this.unitName,
    required this.storId,
    required this.taxPer,
    required this.curQty0,
    required this.curQty,
  });

  Map<String, dynamic> toMap() {
    return {
      'unit_id': unitId,
      'type_id': typeId,
      'item_code': itemCode,
      'item_name': itemName,
      'unit_barcode': unitBarcode,
      'gen_low_out_per': genLowOutPer,
      'kind_id': kindId,
      'group_id': groupId,
      'out_price': outPrice,
      'low_out_per': lowOutPer,
      'out_price2': outPrice2,
      'low_out_per2': lowOutPer2,
      'out_price3': outPrice3,
      'low_out_per3': lowOutPer3,
      'out_price4': outPrice4,
      'low_out_per4': lowOutPer4,
      'out_price5': outPrice5,
      'low_out_per5': lowOutPer5,
      'out_price6': outPrice6,
      'low_out_per6': lowOutPer6,
      'out_price7': outPrice7,
      'low_out_per7': lowOutPer7,
      'out_price8': outPrice8,
      'low_out_per8': lowOutPer8,
      'mar_price': marPrice,
      'def_over_price': defOverPrice,
      'av_price': avPrice,
      'la_price': laPrice,
      'unit_convert': unitConvert,
      'unit_name': unitName,
      'tax_per': taxPer,
      'stor_id': storId,
      'cur_qty0': curQty0,
      'cur_qty': curQty,
    };
  }

  factory ItemsModel.fromMap(Map<String, dynamic> map) {
    return ItemsModel(
      unitId: map['unit_id']?.toInt() ?? 0,
      typeId: map['type_id']?.toInt() ?? 0,
      itemCode: map['item_code'] ?? '',
      itemName: map['item_name'] ?? '',
      unitBarcode: map['unit_barcode'] ?? '',
      genLowOutPer: map['gen_low_out_per']?.toDouble() ?? 0.0,
      kindId: map['kind_id']?.toDouble() ?? 0.0,
      groupId: map['group_id']?.toDouble() ?? 0.0,
      outPrice: map['out_price']?.toDouble() ?? 0.0,
      lowOutPer: map['low_out_per']?.toDouble() ?? 0.0,
      outPrice2: map['out_price2']?.toDouble() ?? 0.0,
      lowOutPer2: map['low_out_per2']?.toDouble() ?? 0.0,
      outPrice3: map['out_price3']?.toDouble() ?? 0.0,
      lowOutPer3: map['low_out_per3']?.toDouble() ?? 0.0,
      outPrice4: map['out_price4']?.toDouble() ?? 0.0,
      lowOutPer4: map['low_out_per4']?.toDouble() ?? 0.0,
      outPrice5: map['out_price5']?.toDouble() ?? 0.0,
      lowOutPer5: map['low_out_per5']?.toDouble() ?? 0.0,
      outPrice6: map['out_price6']?.toDouble() ?? 0.0,
      lowOutPer6: map['low_out_per6']?.toDouble() ?? 0.0,
      outPrice7: map['out_price7']?.toDouble() ?? 0.0,
      lowOutPer7: map['low_out_per7']?.toDouble() ?? 0.0,
      outPrice8: map['out_price8']?.toDouble() ?? 0.0,
      lowOutPer8: map['low_out_per8']?.toDouble() ?? 0.0,
      marPrice: map['mar_price']?.toDouble() ?? 0.0,
      defOverPrice: map['def_over_price']?.toDouble() ?? 0.0,
      avPrice: map['av_price']?.toDouble() ?? 0.0,
      laPrice: map['la_price']?.toDouble() ?? 0.0,
      unitConvert: map['unit_convert']?.toDouble() ?? 0.0,
      unitName: map['unit_name'] ?? '',
      storId: map['stor_id']?.toInt() ?? 0,
      taxPer: map['tax_per']?.toDouble() ?? 0.0,
      curQty0: map['cur_qty0']?.toDouble() ?? 0.0,
      curQty: map['cur_qty']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ItemsModel.fromJson(String source) =>
      ItemsModel.fromMap(json.decode(source));

  ItemsModel copyWith({
    int? unitId,
    int? typeId,
    String? itemCode,
    String? itemName,
    String? unitBarcode,
    double? genLowOutPer,
    double? kindId,
    double? groupId,
    double? outPrice,
    double? lowOutPer,
    double? outPrice2,
    double? lowOutPer2,
    double? outPrice3,
    double? lowOutPer3,
    double? outPrice4,
    double? lowOutPer4,
    double? outPrice5,
    double? lowOutPer5,
    double? outPrice6,
    double? lowOutPer6,
    double? outPrice7,
    double? lowOutPer7,
    double? outPrice8,
    double? lowOutPer8,
    double? marPrice,
    double? defOverPrice,
    double? avPrice,
    double? laPrice,
    double? unitConvert,
    String? unitName,
    num? storId,
    double? taxPer,
    num? curQty0,
    num? curQty,
  }) {
    return ItemsModel(
      unitId: unitId ?? this.unitId,
      typeId: typeId ?? this.typeId,
      itemCode: itemCode ?? this.itemCode,
      itemName: itemName ?? this.itemName,
      unitBarcode: unitBarcode ?? this.unitBarcode,
      genLowOutPer: genLowOutPer ?? this.genLowOutPer,
      kindId: kindId ?? this.kindId,
      groupId: groupId ?? this.groupId,
      outPrice: outPrice ?? this.outPrice,
      lowOutPer: lowOutPer ?? this.lowOutPer,
      outPrice2: outPrice2 ?? this.outPrice2,
      lowOutPer2: lowOutPer2 ?? this.lowOutPer2,
      outPrice3: outPrice3 ?? this.outPrice3,
      lowOutPer3: lowOutPer3 ?? this.lowOutPer3,
      outPrice4: outPrice4 ?? this.outPrice4,
      lowOutPer4: lowOutPer4 ?? this.lowOutPer4,
      outPrice5: outPrice5 ?? this.outPrice5,
      lowOutPer5: lowOutPer5 ?? this.lowOutPer5,
      outPrice6: outPrice6 ?? this.outPrice6,
      lowOutPer6: lowOutPer6 ?? this.lowOutPer6,
      outPrice7: outPrice7 ?? this.outPrice7,
      lowOutPer7: lowOutPer7 ?? this.lowOutPer7,
      outPrice8: outPrice8 ?? this.outPrice8,
      lowOutPer8: lowOutPer8 ?? this.lowOutPer8,
      marPrice: marPrice ?? this.marPrice,
      defOverPrice: defOverPrice ?? this.defOverPrice,
      avPrice: avPrice ?? this.avPrice,
      laPrice: laPrice ?? this.laPrice,
      unitConvert: unitConvert ?? this.unitConvert,
      unitName: unitName ?? this.unitName,
      storId: storId ?? this.storId,
      taxPer: taxPer ?? this.taxPer,
      curQty0: curQty0 ?? this.curQty0,
      curQty: curQty ?? this.curQty,
    );
  }
}
