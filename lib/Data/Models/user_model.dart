import 'dart:convert';

UserModel userModelFromString({required String str}) {
  return UserModel.fromMap(json.decode(str));
}

dynamic userStringFromModel({required UserModel input}) {
  return json.encode(input.toMap());
}

class UserModel {
  UserModel({
    this.defSarafAccId,
    this.userId,
    this.userCode,
    this.userName,
    this.passWord,
    this.defStorId,
    this.defAmAccId,
    this.defEmployAccId,
    this.defBoxAccId,
    this.fatDiscKind,
    this.ipPassword,
    this.ipAddress,
    this.fatMaxPer,
    this.fatMaxDisccValue,
    this.allowChangeDefEmploy,
    this.allowChangeDefStor,
    this.allowChangeDefBox,
    this.editPassword,
    this.branchId,
    this.compId,
    this.uploadDate,
  });

  final dynamic userId;
  final dynamic userCode;
  final dynamic userName;
  final dynamic passWord;
  final dynamic defStorId;
  final dynamic defAmAccId;
  final dynamic defEmployAccId;
  final dynamic defBoxAccId;
  final dynamic fatDiscKind;
  final dynamic fatMaxPer;
  final dynamic fatMaxDisccValue;
  final dynamic defSarafAccId;
  final dynamic ipPassword;
  final dynamic ipAddress;
  final dynamic allowChangeDefEmploy;
  final dynamic allowChangeDefStor;
  final dynamic allowChangeDefBox;
  final dynamic editPassword;
  final dynamic branchId;
  final dynamic compId;
  String? uploadDate;

  factory UserModel.fromMap(Map<dynamic, dynamic> json) => UserModel(
        userId: json["user_id"] ?? "",
        defSarafAccId: json["def_saraf_acc_id"] ?? "",
        userCode: json["user_code"] ?? "",
        userName: json["user_name"] ?? "",
        passWord: json["pass_word"] ?? "",
        defStorId: json["def_stor_id"] ?? "",
        defAmAccId: json["def_am_acc_id"] ?? "",
        defEmployAccId: json["def_employ_acc_id"] ?? "",
        defBoxAccId: json["def_box_acc_id"] ?? "",
        fatDiscKind: json["fat_disc_kind"] ?? "",
        fatMaxPer: json["fat_max_per"] ?? "",
        fatMaxDisccValue: json["fat_max_discc_value"] ?? "",
        allowChangeDefEmploy: json["allow_change_def_employ"] ?? "",
        allowChangeDefStor: json["allow_change_def_stor"] ?? "",
        allowChangeDefBox: json["allow_change_def_box"] ?? "",
        editPassword: json["edit_password"] ?? "",
        branchId: json["branch_id"] ?? 0,
        compId: json["comp_id"] ?? 0,
        ipAddress: json["ip_address"] ?? "",
        ipPassword: json["ip_password"] ?? "",
      );

  Map<dynamic, dynamic> toMap() => {
        "user_id": userId,
        "user_code": userCode,
        "user_name": userName,
        "pass_word": passWord,
        "def_stor_id": defStorId,
        "def_am_acc_id": defAmAccId,
        "def_employ_acc_id": defEmployAccId,
        "def_box_acc_id": defBoxAccId,
        "fat_disc_kind": fatDiscKind,
        "fat_max_per": fatMaxPer,
        "fat_max_discc_value": fatMaxDisccValue,
        "allow_change_def_employ": allowChangeDefEmploy,
        "allow_change_def_stor": allowChangeDefStor,
        "allow_change_def_box": allowChangeDefBox,
        "def_saraf_acc_id": defSarafAccId,
        "edit_password": editPassword,
        "branch_id": branchId,
        "comp_id": compId,
        "ip_address": ipAddress,
        "ip_password": ipPassword
      };
}
