import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smart_sales/App/Resources/values_manager.dart';
import 'package:smart_sales/Data/Models/expense_model.dart';
import 'package:smart_sales/Provider/expenses_state.dart';
import 'package:smart_sales/View/Screens/Documents/documents_view.dart';
import 'package:smart_sales/View/Common/Widgets/Common/custom_textfield.dart';

class ExpensesView extends StatefulWidget {
  final int sectionTypeNo;
  final bool canTap;
  const ExpensesView({
    Key? key,
    required this.sectionTypeNo,
    required this.canTap,
  }) : super(key: key);

  @override
  State<ExpensesView> createState() => _ExpensesViewState();
}

class _ExpensesViewState extends State<ExpensesView> {
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
              headingRowHeight: 30,
              dataRowHeight: 30,
              showBottomBorder: true,
              columns: [
                "number".tr,
                "name".tr,
                "current_credit".tr,
                "user_number".tr,
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
              rows: filterList(context: context, input: searchWord).mapIndexed(
                (index, expense) {
                  final cell = [
                    expense.accId,
                    expense.name,
                    expense.curBalance,
                    expense.employAccId,
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
                              Center(
                                child: Text(
                                  ValuesManager.doubleToString(e),
                                ),
                              ),
                              onTap: () async {
                                if (widget.canTap) {
                                  Get.to(
                                    () => DocumentsScreen(
                                      sectionTypeNo: widget.sectionTypeNo,
                                      entity: expense,
                                      entitiesList:
                                          context.read<ExpenseState>().expenses,
                                    ),
                                  );
                                }
                              },
                            ),
                          )
                          .toList());
                },
              ).toList(),
            ),
          ),
        ),
      ),
    );
  }

  List<ExpenseModel> filterList(
      {required String input, required BuildContext context}) {
    if (input != "") {
      return context.read<ExpenseState>().expenses.where((element) {
        return (element.name.contains(input) ||
            element.accId.toString().contains(input));
      }).toList();
    } else {
      return context.read<ExpenseState>().expenses;
    }
  }
}
