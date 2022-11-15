import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:smart_sales/App/Util/colors.dart';
import 'package:smart_sales/Data/Models/group_model.dart';
import 'package:smart_sales/Provider/groups_state.dart';
import 'package:smart_sales/View/Screens/Cashier/cashier_controller.dart';

class GroupsRow extends StatelessWidget {
  final CashierController cashierController;
  final GetStorage storage;
  const GroupsRow(
      {Key? key, required this.cashierController, required this.storage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !(storage.read("show_cashier_details") ?? true),
      child: SizedBox(
        height: 80,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: context.read<GroupsState>().groups.length,
          itemBuilder: (BuildContext context, int index) {
            final GroupModel groupsModel =
                context.read<GroupsState>().groups[index];
            return Obx(
              () => NeumorphicButton(
                // padding:
                //     const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                margin: const EdgeInsets.symmetric(horizontal: 5),
                child: Text(
                  groupsModel.groupName.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: cashierController.selectedGroupId.value ==
                            groupsModel.groupId
                        ? Colors.amber
                        : Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: NeumorphicStyle(
                  color: darkBlue,
                  depth: cashierController.selectedGroupId.value ==
                          groupsModel.groupId
                      ? 0
                      : null,
                  shape: NeumorphicShape.concave,
                  surfaceIntensity: 90,
                  shadowDarkColor: Colors.black,
                ),
                onPressed: () {
                  cashierController.setGroupId(groupsModel.groupId!);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
