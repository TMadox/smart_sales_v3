import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smart_sales/App/Util/date.dart';
import 'package:smart_sales/App/Util/device.dart';
import 'package:smart_sales/App/Util/locator.dart';
import 'package:smart_sales/App/Resources/values_manager.dart';
import 'package:smart_sales/Data/Models/client_model.dart';
import 'package:smart_sales/Data/Models/expense_model.dart';
import 'package:smart_sales/Data/Models/user_model.dart';
import 'package:smart_sales/Provider/expenses_state.dart';
import 'package:smart_sales/Provider/general_state.dart';
import 'package:smart_sales/Provider/options_state.dart';
import 'package:smart_sales/Provider/powers_state.dart';
import 'package:smart_sales/Provider/user_state.dart';
import 'package:smart_sales/View/Screens/Documents/document_viewmodel.dart';
import 'package:smart_sales/View/Screens/Documents/documents.dart';
import 'package:smart_sales/View/Widgets/Common/custom_textfield.dart';
import 'package:smart_sales/View/Widgets/Dialogs/return_dialog.dart';

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
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
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
                                "current_credit".tr,
                                "user_number".tr,
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
                              rows: filterList(
                                      context: context, input: searchWord)
                                  .mapIndexed((index, expense) {
                                final cell = [
                                  expense.accId,
                                  expense.accName,
                                  expense.curBalance,
                                  expense.genAccId,
                                ];
                                return DataRow(
                                    color: MaterialStateProperty.resolveWith<
                                        Color?>((Set<MaterialState> states) {
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
                                            onTap: () async {
                                              if (widget.canTap) {
                                                intializeReceipt(
                                                  context: context,
                                                  expense: expense,
                                                );
                                                Get.to(
                                                  () => DocumentsScreen(
                                                    sectionNo:
                                                        widget.sectionTypeNo,
                                                  ),
                                                );
                                              }
                                            },
                                          ),
                                        )
                                        .toList());
                              }).toList(),
                            ),
                          )),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  List<ExpenseModel> filterList(
      {required String input, required BuildContext context}) {
    if (input != "") {
      return context.read<ExpenseState>().expenses.where((element) {
        return (element.accName.contains(input) ||
            element.accId.toString().contains(input));
      }).toList();
    } else {
      return context.read<ExpenseState>().expenses;
    }
  }

  intializeReceipt({
    required BuildContext context,
    required ExpenseModel expense,
  }) {
    UserModel loggedUser = context.read<UserState>().user;
    context.read<GeneralState>().setCurrentReceipt(input: {
      "oper_code": getStartingId(context, widget.sectionTypeNo) + 1,
      "basic_acc_id": expense.accId,
      "client_acc_id": loggedUser.defBoxAccId,
      "oper_id": getStartingId(context, widget.sectionTypeNo) + 1,
      "allow_sell_qty_less_zero":
          context.read<PowersState>().allowSellQtyLessThanZero,
      "items_count": 0.0,
      "credit_before": expense.curBalance,
      "extend_time": DateTime.now().toString(),
      "section_type_no": widget.sectionTypeNo,
      "oper_time": CurrentDate.getCurrentTime(),
      "employ_id": loggedUser.defEmployAccId,
      "cst_tax": "",
      "cash_value": 0.0,
      "created_user_id": loggedUser.userId,
      "created_user_ip": loggedUser.ipAddress,
      "user_name": expense.accName,
      'created_date': CurrentDate.getCurrentDate(),
      'oper_date': CurrentDate.getCurrentDate(),
      "oper_due_date": CurrentDate.getCurrentDate(),
      "oper_value": 0.0,
      "oper_disc_per": 0.0,
      "oper_disc_value": 0.0,
      "oper_add_per": 0.0,
      "oper_add_value": 0.0,
      "oper_net_value": 0.0,
      "reside_value": 0.0,
      "tax_per": 0.0,
      "tax_value": 0.0,
      "total_tax": 0.0,
      "oper_net_value_with_tax": 0.0,
      "oper_profit": 0.0,
      "is_form_for_fat": 1,
      "is_form_has_affect_on_stock": 1,
      "is_form_for_output_stock": 1,
      "credit_after": expense.curBalance,
      "stor_id": loggedUser.defStorId,
      "comp_id": loggedUser.compId,
      "branch_id": loggedUser.branchId,
      "is_saved_in_server": 1,
      "refrence_id": locator.get<DeviceParam>().deviceId,
      "save_eror_mes": "0",
      "sender_oper_id": context.read<GeneralState>().receiptsList.length,
      "is_review_from_sender": 0,
      "is_sender_complete_status": 0,
      "employee_name": loggedUser.userName,
      "saved": 0,
      "oper_disc_value_with_tax": 0.0,
      "oper_add_value_with_tax": 0.0,
      "use_tax_system":
          context.read<OptionsState>().options[0].optionValue ?? 0.0,
      "use_price_with_tax":
          context.read<OptionsState>().options[1].optionValue ?? 0.0,
      "is_for_price_with_tax":
          context.read<OptionsState>().options[1].optionValue,
      "notes": ""
    });
    context.read<DocumentsViewmodel>().setSelectedCustomer(
          input: ClientsModel(
            amName: expense.accName,
            curBalance: expense.curBalance,
            taxFileNo: "",
            employAccId: expense.genAccId,
            accId: expense.accId,
          ),
        );
  }
}
