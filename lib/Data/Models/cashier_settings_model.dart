// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CashierSettingsModel {
  final int girdCount;
  final int productsFlex;
  final double tileSize;
  CashierSettingsModel({
    required this.girdCount,
    required this.productsFlex,
    required this.tileSize,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'girdCount': girdCount,
      'productsFlex': productsFlex,
      'tileSize': tileSize,
    };
  }

  factory CashierSettingsModel.fromMap(Map<String, dynamic> map) {
    return CashierSettingsModel(
      girdCount: map['girdCount'] ?? 3,
      productsFlex: map['productsFlex'] ?? 2,
      tileSize: map['tileSize'] ?? 1.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory CashierSettingsModel.fromJson(String source) =>
      CashierSettingsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  CashierSettingsModel copyWith({
    int? girdCount,
    int? productsFlex,
    double? tileSize,
  }) {
    return CashierSettingsModel(
      girdCount: girdCount ?? this.girdCount,
      productsFlex: productsFlex ?? this.productsFlex,
      tileSize: tileSize ?? this.tileSize,
    );
  }

  @override
  String toString() =>
      'CashierSettingsModel(girdCount: $girdCount, productsFlex: $productsFlex, tileSize: $tileSize)';

  @override
  bool operator ==(covariant CashierSettingsModel other) {
    if (identical(this, other)) return true;

    return other.girdCount == girdCount &&
        other.productsFlex == productsFlex &&
        other.tileSize == tileSize;
  }

  @override
  int get hashCode =>
      girdCount.hashCode ^ productsFlex.hashCode ^ tileSize.hashCode;
}
