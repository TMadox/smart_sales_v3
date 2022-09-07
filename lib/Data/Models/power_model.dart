import 'dart:convert';

List<PowersModel> powersModelFromMap(String str) =>
    List<PowersModel>.from(json.decode(str).map((x) => PowersModel.fromMap(x)));

String powersModelToMap(List<PowersModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class PowersModel {
  PowersModel({
    this.powerId,
    this.powerCode,
    this.powerName,
    this.powerState,
    this.defState,
  });

  final int? powerId;
  final String? powerCode;
  final String? powerName;
  final int? powerState;
  final String? defState;

  factory PowersModel.fromMap(Map<String, dynamic> json) => PowersModel(
        powerId: json["power_id"],
        powerCode: json["power_code"],
        powerName: json["power_name"],
        powerState: json["power_state"],
        defState: json["def_state"],
      );

  Map<String, dynamic> toMap() => {
        "power_id": powerId,
        "power_code": powerCode,
        "power_name": powerName,
        "power_state": powerState,
        "def_state": defState,
      };
}
