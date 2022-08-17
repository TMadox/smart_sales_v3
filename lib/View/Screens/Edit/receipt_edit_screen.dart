import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smart_sales/App/Resources/screen_size.dart';
import 'package:smart_sales/App/Util/colors.dart';
import 'package:smart_sales/App/Util/date.dart';
import 'package:smart_sales/Data/Models/client_model.dart';
import 'package:smart_sales/Provider/general_state.dart';
import 'package:smart_sales/View/Screens/Receipts/Widgets/bottom_table.dart';
import 'package:smart_sales/View/Widgets/Common/custom_textfield.dart';
import 'package:smart_sales/View/Widgets/Dialogs/exit_dialog.dart';
import 'package:smart_sales/View/Widgets/Dialogs/warning_dialog.dart';
import 'package:smart_sales/View/Screens/Edit/Widgets/receipt_edit_items.dart';

class ReceiptEditScreen extends StatefulWidget {
  final ClientModel customer;
  const ReceiptEditScreen({Key? key, required this.customer}) : super(key: key);

  @override
  State<ReceiptEditScreen> createState() => _ReceiptEditScreenState();
}

class _ReceiptEditScreenState extends State<ReceiptEditScreen> {
  final List<TextEditingController> controllers =
      List.generate(4, (i) => TextEditingController(text: 0.0.toString()));
  TextEditingController searchController = TextEditingController();
  late Map data = {};
  @override
  void initState() {
    data.addAll({
      "extend_time": DateTime.now().toString(),
      "section_type_no": 9999,
      "user_name": widget.customer.amName,
      "credit_before": widget.customer.curBalance ?? 0.0,
      "cst_tax": widget.customer.taxFileNo ?? ".....",
      "employ_id": widget.customer.employAccId,
      "basic_acc_id": widget.customer.accId,
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = screenWidth(context);
    double height = screenHeight(context);
    final generalState = context.read<GeneralState>();
    return ProgressHUD(
      child: Builder(builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            if (generalState.receiptItems.isNotEmpty) {
              warningDialog(
                  context: context,
                  warningText:
                      'هناك فاتورة قيد الانشاء ستمسح ان تراجعت, هل تود الخروج؟',
                  btnCancelText: "exit".tr,
                  btnOkText: 'بقاء',
                  onCancel: () {
                    exitDialog(
                      context: context,
                      data: data,
                    );
                  });
              return false;
            } else {
              exitDialog(
                context: context,
                data: data,
              );
              return false;
            }
          },
          child: SafeArea(
            left: false,
            child: Scaffold(
                body: Center(
              child: SizedBox(
                width: width * 0.98,
                child: ListView(
                  primary: true,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
                            height: height * 0.09,
                            padding: EdgeInsets.symmetric(
                              horizontal: width * 0.01,
                            ),
                            decoration: const BoxDecoration(
                              color: whiteHaze,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(15),
                              ),
                            ),
                            child: AutoSizeText(
                              widget.customer.amName.toString(),
                              maxLines: 1,
                              style: GoogleFonts.cairo(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                            height: height * 0.09,
                            decoration: const BoxDecoration(
                              color: smaltBlue,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                AutoSizeText.rich(
                                  TextSpan(children: [
                                    TextSpan(
                                      text: "date".tr,
                                      style: GoogleFonts.cairo(color: atlantis),
                                    ),
                                    TextSpan(
                                      text: ": " + CurrentDate.getCurrentDate(),
                                      style: GoogleFonts.cairo(
                                          color: Colors.white),
                                    )
                                  ]),
                                ),
                                AutoSizeText.rich(
                                  TextSpan(children: [
                                    TextSpan(
                                      text: "time".tr,
                                      style: GoogleFonts.cairo(color: atlantis),
                                    ),
                                    TextSpan(
                                      text: ": " + CurrentDate.getCurrentTime(),
                                      style: GoogleFonts.cairo(
                                          color: Colors.white),
                                    )
                                  ]),
                                ),
                                AutoSizeText(
                                  "فاتورة مردود",
                                  style: GoogleFonts.cairo(
                                    color: atlantis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: width * 0.01, vertical: height * 0.008),
                      height: height * 0.09,
                      decoration: const BoxDecoration(
                        color: smaltBlue,
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Selector<GeneralState, double>(
                              builder: (context, state, widget) {
                                return AutoSizeText.rich(
                                  TextSpan(children: [
                                    TextSpan(
                                      text: "total_quantity".tr,
                                      style: GoogleFonts.cairo(color: atlantis),
                                    ),
                                    TextSpan(
                                      text: ": " + state.toString(),
                                      style: GoogleFonts.cairo(
                                          color: Colors.white),
                                    )
                                  ]),
                                );
                              },
                              selector: (context, state) =>
                                  state.currentReceipt["items_count"]),
                          Consumer<GeneralState>(
                            builder: (context, state, widget) {
                              int quantity = 0;
                              for (var element in state.receiptItems) {
                                int temp = element["free_qty"];
                                quantity += temp;
                              }
                              return AutoSizeText.rich(
                                TextSpan(children: [
                                  TextSpan(
                                    text: "total_free_qty".tr,
                                    style: GoogleFonts.cairo(color: atlantis),
                                  ),
                                  TextSpan(
                                    text: ": " + quantity.toString(),
                                    style: GoogleFonts.cairo(
                                      color: Colors.white,
                                    ),
                                  )
                                ]),
                              );
                            },
                          ),
                          SizedBox(
                            width: width * 0.3,
                            child: CustomTextField(
                                fillColor: Colors.white,
                                activated: true,
                                hintText: "الملاحظات",
                                onChanged: (value) {
                                  context
                                      .read<GeneralState>()
                                      .addNotes(value.toString());
                                },
                                name: 'notes'),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    SizedBox(
                      height: height * 0.54,
                      child: ReceiptEditItems(
                        width: width,
                        height: height,
                        context: context,
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    SizedBox(
                      width: width * 0.98,
                      child: BottomTable(
                        controllers: controllers,
                        customer: widget.customer,
                        height: height,
                        width: width,
                      ),
                    ),
                  ],
                ),
              ),
            )),
          ),
        );
      }),
    );
  }
}
