// To parse this JSON data, do
//
//     final optionsModel = optionsModelFromMap(jsonString);

import 'dart:convert';

OptionsModel optionsModelFromMap(String str) =>
    OptionsModel.fromMap(json.decode(str));
List<OptionsModel> optionsListFromJson({required String input}) =>
    (json.decode(input) as List<dynamic>)
        .map<OptionsModel>((number) => OptionsModel.fromMap(number))
        .toList();
String optionsModelToMap(OptionsModel data) => json.encode(data.toMap());

String optionsJsonFromList({required List<OptionsModel> data}) => json.encode(
    data.map<Map<String, dynamic>>((number) => number.toMap()).toList());

class OptionsModel {
  OptionsModel({
    this.optionId,
    this.optionCode,
    this.optionNsame,
    this.optionValue,
  });

  final int? optionId;
  final String? optionCode;
  final String? optionNsame;
  final double? optionValue;

  factory OptionsModel.fromMap(Map<String, dynamic> json) => OptionsModel(
        optionId: json["option_id"],
        optionCode: json["option_code"],
        optionNsame: json["option_nsame"],
        optionValue: json["option_value"],
      );

  Map<String, dynamic> toMap() => {
        "option_id": optionId,
        "option_code": optionCode,
        "option_nsame": optionNsame,
        "option_value": optionValue,
      };
}
