import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:smart_sales/Data/Models/group_model.dart';
import 'package:smart_sales/Provider/groups_state.dart';
import 'package:smart_sales/View/Screens/Cashier/cashier_controller.dart';

class GroupsColumn extends StatelessWidget {
  final CashierController cashierController;
  const GroupsColumn({
    Key? key,
    required this.cashierController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        border: Border.all(color: Colors.green, width: 2),
        borderRadius: const BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            child: Text(
              "groups".tr,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            color: Colors.green,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: context.read<GroupsState>().groups.length,
              itemBuilder: (BuildContext context, int index) {
                final GroupModel kindsModel =
                    context.read<GroupsState>().groups[index];
                return InkWell(
                  onTap: () {
                    // cashierController.setSelectedKind(input: kindsModel.kindId);
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      side: BorderSide(
                        color: kindsModel.groupId ==
                                cashierController.selectedKindId.value
                            ? Colors.green
                            : Colors.transparent,
                      ),
                    ),
                    child: ListTile(
                      title: Text(
                        kindsModel.groupName.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
