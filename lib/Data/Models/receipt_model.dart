import 'dart:convert';

class ReceiptModel {
  final int? number;
  final String? customerName;
  final double? totalAmount;
  final String? date;
  final String? time;
  final double? payment;
  final String? type;
  final int? totalProducts;
  ReceiptModel({
    this.number,
    this.customerName,
    this.totalAmount,
    this.date,
    this.time,
    this.payment,
    this.type,
    this.totalProducts,
  });

  ReceiptModel copyWith({
    int? number,
    String? customerName,
    double? totalAmount,
    String? date,
    String? time,
    double? payment,
    String? type,
    int? totalProducts,
  }) {
    return ReceiptModel(
      number: number ?? this.number,
      customerName: customerName ?? this.customerName,
      totalAmount: totalAmount ?? this.totalAmount,
      date: date ?? this.date,
      time: time ?? this.time,
      payment: payment ?? this.payment,
      type: type ?? this.type,
      totalProducts: totalProducts ?? this.totalProducts,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'number': number,
      'customerName': customerName,
      'totalAmount': totalAmount,
      'date': date,
      'time': time,
      'payment': payment,
      'type': type,
      'totalProducts': totalProducts,
    };
  }

  factory ReceiptModel.fromMap(Map<String, dynamic> map) {
    return ReceiptModel(
      number: map['number']?.toInt(),
      customerName: map['customerName'],
      totalAmount: map['totalAmount']?.toDouble(),
      date: map['date'],
      time: map['time'],
      payment: map['payment']?.toDouble(),
      type: map['type'],
      totalProducts: map['totalProducts']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory ReceiptModel.fromJson(String source) =>
      ReceiptModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ReceiptModel(number: $number, customerName: $customerName, totalAmount: $totalAmount, date: $date, time: $time, payment: $payment, type: $type, totalProducts: $totalProducts)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ReceiptModel &&
        other.number == number &&
        other.customerName == customerName &&
        other.totalAmount == totalAmount &&
        other.date == date &&
        other.time == time &&
        other.payment == payment &&
        other.type == type &&
        other.totalProducts == totalProducts;
  }

  @override
  int get hashCode {
    return number.hashCode ^
        customerName.hashCode ^
        totalAmount.hashCode ^
        date.hashCode ^
        time.hashCode ^
        payment.hashCode ^
        type.hashCode ^
        totalProducts.hashCode;
  }
}
