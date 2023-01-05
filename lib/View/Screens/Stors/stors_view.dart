import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smart_sales/App/Resources/values_manager.dart';
import 'package:smart_sales/Data/Models/stor_model.dart';
import 'package:smart_sales/Provider/stor_state.dart';
import 'package:smart_sales/View/Screens/Receipts/receipts_controller.dart';
import 'package:smart_sales/View/Screens/Stors/stor_transfer.dart';
import 'package:smart_sales/View/Common/Widgets/Common/custom_textfield.dart';

class StorsView extends StatefulWidget {
  final bool canTap;
  final bool choosingSourceStor;
  final bool canPushReplace;
  const StorsView({
    Key? key,
    required this.canTap,
    required this.choosingSourceStor,
    required this.canPushReplace,
  }) : super(key: key);

  @override
  State<StorsView> createState() => _StorsViewState();
}

class _StorsViewState extends State<StorsView> {
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
              child: DataTable(
            headingRowColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
              return Colors.green;
            }),
            dividerThickness: 1,
            showBottomBorder: true,
            headingRowHeight: 30,
            dataRowHeight: 30,
            columns: [
              "number".tr,
              "name".tr,
              "stor_code".tr,
            ]
                .map(
                  (title) => DataColumn(
                    label: Expanded(
                      child: Center(
                        child: Text(
                          title,
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
                .mapIndexed((index, stor) {
              final cell = [stor.id, stor.name, stor.code];
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
                              ValuesManager.numToString(e),
                            ),
                          ),
                          onTap: () async {
                            if (widget.canTap) {
                              if (widget.choosingSourceStor) {
                                Get.find<ReceiptsController>()
                                    .changeReceiptValue(
                                  input: {
                                    "stor_id": stor.id,
                                    "selected_stor_id": stor.id,
                                  },
                                );
                                Get.back();
                              } else if (widget.canPushReplace) {
                                Get.find<ReceiptsController>().startReceipt(
                                    entity: stor,
                                    context: context,
                                    sectionTypeNo: 5,
                                    selectedStorId: stor.id,
                                    resetReceipt: true);
                                Get.back();
                              } else {
                                await Get.to(
                                  () => StorTransfer(
                                    sectionTypeNo: 5,
                                    stor: stor,
                                  ),
                                );
                              }
                            }
                          },
                        ),
                      )
                      .toList());
            }).toList(),
          )),
        ),
      ),
    );
  }

  List<StorModel> filterList(
      {required String input, required BuildContext context}) {
    List<StorModel> filteredStors = [];
    if (input != "") {
      filteredStors =
          List.from(context.read<StoreState>().stors.where((element) {
        return (element.name.contains(input) ||
            element.id.toString().contains(input));
      }).toList());
      // filteredStors.removeWhere((element) =>
      //     element.id == context.read<UserState>().user.defid);

      return filteredStors;
    } else {
      filteredStors = List.from(context.read<StoreState>().stors);
      // filteredStors.removeWhere((element) =>
      //     element.id == context.read<UserState>().user.defid);
      return filteredStors;
    }
  }
}
