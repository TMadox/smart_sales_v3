// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CashierSettingsModel {
  final int gridCount;
  final int productsFlex;
  final double tileSize;
  final bool showCart;
  final bool showOffers;
  CashierSettingsModel({
    required this.gridCount,
    required this.productsFlex,
    required this.tileSize,
    required this.showCart,
    required this.showOffers,
  });

  Map<String, dynamic> toMap() {
    return {
      'gridCount': gridCount,
      'productsFlex': productsFlex,
      'tileSize': tileSize,
      'showCart': showCart,
      'showOffers': showOffers,
    };
  }

  factory CashierSettingsModel.fromMap(Map<String, dynamic> map) {
    return CashierSettingsModel(
      gridCount: map['gridCount'] ?? 2,
      productsFlex: map['productsFlex'] ?? 2,
      tileSize: map['tileSize'] ?? 1.0,
      showCart: map['showCart'] ?? true,
      showOffers: map['showOffers'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory CashierSettingsModel.fromJson(String source) =>
      CashierSettingsModel.fromMap(json.decode(source));

  CashierSettingsModel copyWith({
    int? gridCount,
    int? productsFlex,
    double? tileSize,
    bool? showCart,
    bool? showOffers,
  }) {
    return CashierSettingsModel(
      gridCount: gridCount ?? this.gridCount,
      productsFlex: productsFlex ?? this.productsFlex,
      tileSize: tileSize ?? this.tileSize,
      showCart: showCart ?? this.showCart,
      showOffers: showOffers ?? this.showOffers,
    );
  }

  @override
  String toString() {
    return 'CashierSettingsModel(gridCount: $gridCount, productsFlex: $productsFlex, tileSize: $tileSize, showCart: $showCart, showOffers: $showOffers)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CashierSettingsModel &&
        other.gridCount == gridCount &&
        other.productsFlex == productsFlex &&
        other.tileSize == tileSize &&
        other.showCart == showCart &&
        other.showOffers == showOffers;
  }

  @override
  int get hashCode {
    return gridCount.hashCode ^
        productsFlex.hashCode ^
        tileSize.hashCode ^
        showCart.hashCode ^
        showOffers.hashCode;
  }
}
