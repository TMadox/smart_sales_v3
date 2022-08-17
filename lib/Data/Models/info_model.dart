import 'dart:convert';

InfoModel infoModelFromMap(String str) => InfoModel.fromMap(json.decode(str));

String infoModelToMap(InfoModel data) => json.encode(data.toMap());

class InfoModel {
  InfoModel({
    this.headerId,
    this.companyName,
    this.companyAddress,
    this.companyTel,
    this.companyFax,
    this.companyLic,
    this.companyTax,
  });

  final int? headerId;
  final String? companyName;
  final String? companyAddress;
  final String? companyTel;
  final String? companyFax;
  final String? companyLic;
  final String? companyTax;

  factory InfoModel.fromMap(Map<String, dynamic> json) => InfoModel(
        headerId: json["header_id"],
        companyName: json["company_name"],
        companyAddress: json["company_address"],
        companyTel: json["company_tel"],
        companyFax: json["company_fax"],
        companyLic: json["company_lic"],
        companyTax: json["company_tax"],
      );

  Map<String, dynamic> toMap() => {
        "header_id": headerId,
        "company_name": companyName,
        "company_address": companyAddress,
        "company_tel": companyTel,
        "company_fax": companyFax,
        "company_lic": companyLic,
        "company_tax": companyTax,
      };
}
