import 'package:flutter/cupertino.dart';
import 'package:smart_sales/Data/Models/group_model.dart';

class GroupsState extends ChangeNotifier {
  List<GroupModel> groups = [];

  void fillGroups({required List<GroupModel> input}) {
    groups = List.from(input);
  }
}
