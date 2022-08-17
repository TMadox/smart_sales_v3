import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smart_sales/App/Resources/values_manager.dart';
import 'package:smart_sales/Data/Models/group_model.dart';
import 'package:smart_sales/Provider/groups_state.dart';
import 'package:smart_sales/View/Widgets/Common/custom_textfield.dart';

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
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            double width = constraints.maxWidth;
            double height = constraints.maxHeight;
            return Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: SizedBox(
                  width: width * 0.98,
                  height: height * 0.95,
                  child: SingleChildScrollView(
                      child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: DataTable(
                      headingRowColor:
                          MaterialStateProperty.resolveWith<Color?>(
                              (Set<MaterialState> states) {
                        return Colors.green;
                      }),
                      dividerThickness: 1,
                      headingRowHeight: height * 0.09,
                      dataRowHeight: height * 0.1,
                      border: TableBorder.all(
                          width: 0.5,
                          style: BorderStyle.none,
                          borderRadius: BorderRadius.circular(15)),
                      columns: [
                        "number".tr,
                        "name".tr,
                        "group_code".tr,
                      ]
                          .map(
                            (e) => DataColumn(
                              label: Center(
                                child: Text(
                                  e,
                                  style: GoogleFonts.cairo(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                      rows: filterList(context: context, input: searchWord)
                          .mapIndexed((index, kind) {
                        final cell = [
                          kind.groupId,
                          kind.groupName,
                          kind.groupCode
                        ];
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
                                    Text(
                                      ValuesManager.doubleToString(e),
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
          },
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
