import 'dart:convert';

List<KindsModel> kindModelFromJson(String str) =>
    List<KindsModel>.from(json.decode(str).map((x) => KindsModel.fromMap(x)));

String kindModelToJson(List<KindsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class KindsModel {
  final int kindId;
  final int kindCode;
  final String kindName;
  KindsModel({
    required this.kindId,
    required this.kindCode,
    required this.kindName,
  });

  KindsModel copyWith({
    int? kindId,
    int? kindCode,
    String? kindName,
  }) {
    return KindsModel(
      kindId: kindId ?? this.kindId,
      kindCode: kindCode ?? this.kindCode,
      kindName: kindName ?? this.kindName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'kind_id': kindId,
      'kind_code': kindCode,
      'kind_name': kindName,
    };
  }

  factory KindsModel.fromMap(Map<String, dynamic> map) {
    return KindsModel(
      kindId: map['kind_id'] ?? '',
      kindCode: map['kind_code'] ?? '',
      kindName: map['kind_name'] ?? '',
    );
  }
}
