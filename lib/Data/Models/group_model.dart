import 'dart:convert';

List<GroupModel> groupModelFromJson(String str) =>
    List<GroupModel>.from(json.decode(str).map((x) => GroupModel.fromMap(x)));

String groupModelToJson(List<GroupModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GroupModel {
  int? groupId;
  int? groupCode;
  String? groupName;
  GroupModel({
    this.groupId,
    this.groupCode,
    this.groupName,
  });

  GroupModel copyWith({
    int? groupId,
    int? groupCode,
    String? groupName,
  }) {
    return GroupModel(
      groupId: groupId ?? this.groupId,
      groupCode: groupCode ?? this.groupCode,
      groupName: groupName ?? this.groupName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'group_id': groupId,
      'group_code': groupCode,
      'group_name': groupName,
    };
  }

  factory GroupModel.fromMap(Map<String, dynamic> map) {
    return GroupModel(
      groupId: map['group_id']?.toInt(),
      groupCode: map['group_code']?.toInt(),
      groupName: map['group_name'],
    );
  }

  String toJson() => json.encode(toMap());

  factory GroupModel.fromJson(String source) =>
      GroupModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'GroupModel(groupId: $groupId, groupCode: $groupCode, groupName: $groupName)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GroupModel &&
        other.groupId == groupId &&
        other.groupCode == groupCode &&
        other.groupName == groupName;
  }

  @override
  int get hashCode =>
      groupId.hashCode ^ groupCode.hashCode ^ groupName.hashCode;
}
