import 'package:auto_size_text/auto_size_text.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smart_sales/App/Util/date.dart';
import 'package:smart_sales/App/Util/device.dart';
import 'package:smart_sales/App/Util/locator.dart';
import 'package:smart_sales/App/Util/routing.dart';
import 'package:smart_sales/App/Resources/values_manager.dart';
import 'package:smart_sales/Data/Models/client_model.dart';
import 'package:smart_sales/Data/Models/mow_model.dart';
import 'package:smart_sales/Data/Models/user_model.dart';
import 'package:smart_sales/Provider/clients_state.dart';
import 'package:smart_sales/Provider/general_state.dart';
import 'package:smart_sales/Provider/mow_state.dart';
import 'package:smart_sales/Provider/options_state.dart';
import 'package:smart_sales/Provider/powers_state.dart';
import 'package:smart_sales/Provider/stor_state.dart';
import 'package:smart_sales/Provider/user_state.dart';
import 'package:smart_sales/View/Screens/Documents/document_viewmodel.dart';
import 'package:smart_sales/View/Widgets/Common/custom_textfield.dart';

class MowView extends StatefulWidget {
  final bool canTap;
  final int? sectionTypeNo;
  final bool canPushReplace;
  const MowView({
    Key? key,
    required this.canTap,
    this.sectionTypeNo,
    required this.canPushReplace,
  }) : super(key: key);

  @override
  State<MowView> createState() => _MowViewState();
}

class _MowViewState extends State<MowView> {
  String searchWord = "";
  late int selectedStoreId;
  @override
  void initState() {
    if (context.read<GeneralState>().currentReceipt["selected_stor_id"] ==
        null) {
      selectedStoreId = context.read<UserState>().user.defStorId;
    } else {
      selectedStoreId =
          context.read<GeneralState>().currentReceipt["selected_stor_id"];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  hintText: "search".tr,
                  prefixIcon: const Icon(Icons.search),
                  activated: true,
                  onChanged: (p0) {
                    setState(() {
                      searchWord = p0!;
                    });
                  },
                ),
              ),
              Visibility(
                visible: widget.canTap,
                child: Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: FormBuilderDropdown<int>(
                      name: "stor",
                      iconEnabledColor: Colors.transparent,
                      initialValue: context
                              .read<GeneralState>()
                              .currentReceipt["selected_stor_id"] ??
                          selectedStoreId,
                      hint: Text("choose_stor".tr),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedStoreId = value;
                          });
                        }
                      },
                      validator: FormBuilderValidators.required(context),
                      items: context
                          .read<StoreState>()
                          .stors
                          .map(
                            (stor) => DropdownMenuItem<int>(
                              alignment: AlignmentDirectional.center,
                              child: AutoSizeText(
                                stor.storName.toString(),
                                style: GoogleFonts.cairo(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              value: stor.storId,
                            ),
                          )
                          .toList(),
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 5),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.green,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              10,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
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
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: width * 0.98,
                height: height * 0.95,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                      child: DataTable(
                    headingRowColor: MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                      return Colors.green;
                    }),
                    dividerThickness: 1,
                    headingRowHeight: height * 0.09,
                    dataRowHeight: height * 0.1,
                    border: TableBorder.all(
                        width: 0.5,
                        style: BorderStyle.none,
                        borderRadius: BorderRadius.circular(10)),
                    columns: [
                      "number".tr,
                      "name".tr,
                      "cst_code".tr,
                      "current_credit".tr,
                      "user_number".tr,
                    ]
                        .map((e) => DataColumn(
                                label: Text(
                              e,
                              style: GoogleFonts.cairo(
                                color: Colors.white,
                              ),
                            )))
                        .toList(),
                    rows: filterList(context: context, input: searchWord)
                        .mapIndexed((index, mow) {
                      final cell = [
                        mow.accId,
                        mow.mowName,
                        mow.mowCode,
                        mow.curBalance,
                        mow.accId
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
                                    textAlign: TextAlign.center,
                                  ),
                                  onTap: () async {
                                    if (widget.canTap) {
                                      await intializeReceipt(
                                        context: context,
                                        mow: mow,
                                      );
                                    }
                                  },
                                ),
                              )
                              .toList());
                    }).toList(),
                  )),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  List<MowModel> filterList(
      {required String input, required BuildContext context}) {
    if (input != "") {
      return context.read<MowState>().mows.where((element) {
        return (element.mowName.contains(input) ||
            element.accId.toString().contains(input));
      }).toList();
    } else {
      return context.read<MowState>().mows;
    }
  }

  getStartingId(BuildContext context) {
    int sectionNo = widget.sectionTypeNo!;
    if (context.read<GeneralState>().finalReceipts[sectionNo.toString()] ==
        null) {
      return 0;
    } else {
      return context.read<GeneralState>().finalReceipts[sectionNo.toString()]
              ["oper_id"] ??
          0;
    }
  }

  intializeReceipt({
    required BuildContext context,
    required MowModel mow,
  }) async {
    UserModel loggedUser = context.read<UserState>().user;
    context
        .read<ClientsState>()
        .setCurrentCustomer(customer: ClientsModel(priceId: 1));
    context.read<GeneralState>().setCurrentReceipt(input: {
      "oper_code": getStartingId(context) + 1,
      "basic_acc_id": mow.accId,
      "client_acc_id": loggedUser.defBoxAccId,
      "oper_id": getStartingId(context) + 1,
      "allow_sell_qty_less_zero":
          context.read<PowersState>().allowSellQtyLessThanZero,
      "items_count": 0.0,
      "credit_after": mow.curBalance,
      "credit_before": mow.curBalance,
      "extend_time": DateTime.now().toString(),
      "section_type_no": widget.sectionTypeNo,
      "oper_time": CurrentDate.getCurrentTime(),
      "employ_id": loggedUser.defEmployAccId,
      "cst_tax": mow.taxFileNo,
      "cash_value": 0.0,
      "created_user_id": loggedUser.userId,
      "created_user_ip": loggedUser.ipAddress,
      "user_name": mow.mowName,
      'created_date': CurrentDate.getCurrentDate(),
      'oper_date': CurrentDate.getCurrentDate(),
      "oper_due_date": CurrentDate.getCurrentDate(),
      "oper_value": 0.0,
      "oper_disc_per": 0.0,
      "oper_disc_value": 0.0,
      "oper_add_per": 0.0,
      "oper_add_value": 0.0,
      "oper_net_value": 0.0,
      "selected_stor_id": selectedStoreId,
      "reside_value": 0.0,
      "tax_per": 0.0,
      "tax_value": 0.0,
      "total_tax": 0.0,
      "oper_net_value_with_tax": 0.0,
      "oper_profit": 0.0,
      "pay_by_cash_only": 1,
      "force_cash": false,
      "is_form_for_fat": 1,
      "is_form_has_affect_on_stock": 1,
      "is_form_for_output_stock": 1,
      "stor_id": selectedStoreId,
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

    if (widget.canPushReplace) {
      int count = 0;
      Navigator.of(context).pushNamedAndRemoveUntil(
        "ReceiptCreation",
        (route) => count++ >= 2,
        arguments: ClientsModel(
          amName: mow.mowName,
          curBalance: mow.curBalance,
          taxFileNo: mow.taxFileNo,
          employAccId: mow.mowId,
          accId: mow.accId,
        ),
      );
    } else {
      context.read<DocumentsViewmodel>().setSelectedCustomer(
              input: ClientsModel(
            amName: mow.mowName,
            curBalance: mow.curBalance,
            taxFileNo: mow.taxFileNo,
            employAccId: mow.mowId,
            accId: mow.accId,
          ));
      if (widget.sectionTypeNo == 104 || widget.sectionTypeNo == 103) {
        await Navigator.of(context)
            .pushNamed(Routes.documentsRoute, arguments: widget.sectionTypeNo);
      } else {
        await Navigator.of(context).pushNamed(
          "ReceiptCreation",
          arguments: ClientsModel(
            amName: mow.mowName,
            curBalance: mow.curBalance,
            taxFileNo: mow.taxFileNo,
            employAccId: mow.mowId,
            accId: mow.accId,
          ),
        );
      }
    }
  }
}
