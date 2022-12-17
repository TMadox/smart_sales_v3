import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smart_sales/App/Resources/values_manager.dart';
import 'package:smart_sales/Data/Models/group_model.dart';
import 'package:smart_sales/Provider/groups_state.dart';
import 'package:smart_sales/View/Common/Widgets/Common/custom_textfield.dart';

class GroupsView extends StatefulWidget {
  const GroupsView({Key? key}) : super(key: key);

  @override
  State<GroupsView> createState() => _GroupsViewState();
}

class _GroupsViewState extends State<GroupsView> {
  String searchWord = "";
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      left: false,
      right: false,
      bottom: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: const SizedBox(),
          backgroundColor: Colors.white,
          flexibleSpace: Container(
            padding: const EdgeInsets.all(5),
            child: Row(
              children: [
                const BackButton(
                  color: Colors.green,
                ),
                Expanded(
                  child: CustomTextField(
                    name: "search",
                    hintText: 'search'.tr,
                    activated: true,
                    onChanged: (p0) {
                      setState(() {
                        searchWord = p0!;
                      });
                    },
                    prefixIcon: const Icon(Icons.search),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Container(
          foregroundDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(color: Colors.green, width: 4),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
          ),
          margin: const EdgeInsets.all(5),
          width: double.infinity,
          height: double.infinity,
          clipBehavior: Clip.hardEdge,
          child: SingleChildScrollView(
              child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: DataTable(
              headingRowColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                return Colors.green;
              }),
              dividerThickness: 1,
              headingRowHeight: 30,
              showBottomBorder: true,
              dataRowHeight: 30,
              columns: [
                "number".tr,
                "name".tr,
                "group_code".tr,
              ]
                  .map(
                    (e) => DataColumn(
                      label: Expanded(
                        child: Center(
                          child: Text(
                            e,
                            style: GoogleFonts.cairo(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
              rows: filterList(context: context, input: searchWord)
                  .mapIndexed((index, kind) {
                final cell = [kind.groupId, kind.groupName, kind.groupCode];
                return DataRow(
                    color: MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                      if ((index % 2) == 0) {
                        return Colors.grey[200];
                      }
                      return null;
                    }),
                    cells: cell
                        .map(
                          (e) => DataCell(
                            Center(
                              child: Text(
                                ValuesManager.doubleToString(e),
                              ),
                            ),
                          ),
                        )
                        .toList());
              }).toList(),
            ),
          )),
        ),
      ),
    );
  }

  List<GroupModel> filterList(
      {required String input, required BuildContext context}) {
    if (input != "") {
      return context.read<GroupsState>().groups.where((element) {
        return (element.groupName!.contains(input) ||
            element.groupId.toString().contains(input));
      }).toList();
    } else {
      return context.read<GroupsState>().groups;
    }
  }
}
