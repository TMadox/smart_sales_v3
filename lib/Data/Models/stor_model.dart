import 'dart:convert';

List<StorModel> storModelFromJson(String str) => List<StorModel>.from(
    json.decode(str).map((x) => StorModel.fromJson(json.encode(x))));

String storModelToJson(List<StorModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StorModel {
  final int storId;
  final int storCode;
  final String storName;
  StorModel({
    required this.storId,
    required this.storCode,
    required this.storName,
  });

  Map<String, dynamic> toMap() {
    return {
      'stor_id': storId,
      'stor_code': storCode,
      'stor_name': storName,
    };
  }

  factory StorModel.fromMap(Map<String, dynamic> map) {
    return StorModel(
      storId: map['stor_id']?.toInt() ?? 0,
      storCode: map['stor_code']?.toInt() ?? 0,
      storName: map['stor_name'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory StorModel.fromJson(String source) =>
      StorModel.fromMap(json.decode(source));
}
