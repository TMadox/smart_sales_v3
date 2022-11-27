import 'dart:developer';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_sales/App/Resources/screen_size.dart';
import 'package:smart_sales/App/Resources/values_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smart_sales/Provider/general_state.dart';
import 'package:smart_sales/Provider/user_state.dart';
import 'package:smart_sales/View/Screens/Documents/Widgets/first_row.dart';
import 'package:smart_sales/View/Screens/Documents/Widgets/second_row.dart';
import 'package:smart_sales/View/Screens/Documents/Widgets/third_row.dart';
import 'package:smart_sales/View/Screens/Documents/document_viewmodel.dart';
import 'package:smart_sales/View/Widgets/Common/common_button.dart';
import 'package:smart_sales/View/Widgets/Common/custom_textfield.dart';
import 'package:provider/provider.dart';
import 'package:smart_sales/View/Widgets/Dialogs/save_dialog.dart';

class DocumentsScreen extends StatefulWidget {
  final int sectionNo;
  const DocumentsScreen({Key? key, required this.sectionNo}) : super(key: key);
  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  double newCredit = 0.0;
  final TextEditingController _controller =
      TextEditingController(text: 0.0.toString());
  final storage = GetStorage();
  late Map data = {};
  @override
  void initState() {
    data.addAll({
      "extend_time": DateTime.now().toString(),
      "section_type_no": 9999,
      "user_name": "not selected",
      "credit_before": 0.0,
      "cst_tax": ".....",
      "employ_id": context.read<UserState>().user.defEmployAccId,
      "basic_acc_id": 0,
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    log(widget.sectionNo.toString());
    double width = screenWidth(context);
    double height = screenHeight(context);
    final documentsState = context.read<DocumentsViewmodel>();
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: WillPopScope(
        onWillPop: () async {
          return documentsState.onExit(
            context: context,
            data: data,
          );
        },
        child: SafeArea(
          left: false,
          right: false,
          bottom: false,
          child: Scaffold(
            body: Center(
              child: SizedBox(
                width: width * 0.9,
                height: height * 0.95,
                child: FormBuilder(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: height * 0.03,
                        ),
                        Visibility(
                          visible: widget.sectionNo != 108 &&
                              widget.sectionNo != 107 &&
                              widget.sectionNo != 103 &&
                              widget.sectionNo != 104,
                          child: FirstRow(
                            sectionNo: widget.sectionNo,
                            width: width,
                            height: height,
                            controller: _controller,
                          ),
                        ),
                        SizedBox(
                          height: height * 0.03,
                        ),
                        SecondRow(
                          width: width,
                          sectionNo: widget.sectionNo,
                          controller: _controller,
                        ),
                        SizedBox(
                          height: height * 0.03,
                        ),
                        ThirdRow(
                          width: width,
                          sectionNo: widget.sectionNo,
                        ),
                        SizedBox(
                          height: height * 0.03,
                        ),
                        Row(
                          children: [
                            AutoSizeText("notes".tr),
                            SizedBox(
                              width: width * 0.01,
                            ),
                            Expanded(
                              child: CustomTextField(
                                hintText: "enter_notes".tr,
                                validators: (p0) {
                                  return null;
                                },
                                name: "notes",
                                activated: true,
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: height * 0.03,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              children: [
                                AutoSizeText(
                                  "credit_before".tr + ": ",
                                  style: GoogleFonts.cairo(
                                    fontSize: 20,
                                  ),
                                ),
                                SizedBox(
                                  width: width * 0.01,
                                ),
                                Consumer<DocumentsViewmodel>(
                                  builder: (BuildContext context, state,
                                      Widget? child) {
                                    return SizedBox(
                                      width: width * 0.2,
                                      child: AutoSizeText(
                                        (state.selectedCustomer.curBalance ??
                                                0.0)
                                            .toStringAsFixed(3),
                                        style: GoogleFonts.cairo(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                AutoSizeText(
                                  "credit_after".tr + ": ",
                                  style: GoogleFonts.cairo(fontSize: 20),
                                ),
                                SizedBox(
                                  width: width * 0.01,
                                ),
                                Consumer<GeneralState>(
                                  builder: (
                                    BuildContext context,
                                    GeneralState state,
                                    Widget? child,
                                  ) {
                                    return SizedBox(
                                      width: width * 0.2,
                                      child: AutoSizeText(
                                        ValuesManager.doubleToString(
                                          state.currentReceipt["credit_after"],
                                        ),
                                        maxLines: 1,
                                        style: GoogleFonts.cairo(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height * 0.03,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CommonButton(
                              title: "new_document".tr,
                              icon: const Icon(Icons.save),
                              color: Colors.green,
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();

                                  Map inputs =
                                      Map.from(_formKey.currentState!.value);
                                  saveDialog(
                                    context: context,
                                    onCancel: () {
                                      Navigator.of(context).pop();
                                    },
                                    onPrint: () async {
                                      await documentsState.onFinishDocument(
                                        context: context,
                                        inputs: inputs,
                                        sectionNo: widget.sectionNo,
                                        savePdf: true,
                                      );
                                    },
                                    onSave: () async {
                                      await documentsState.onFinishDocument(
                                        context: context,
                                        inputs: inputs,
                                        sectionNo: widget.sectionNo,
                                      );
                                    },
                                    onShare: () async {
                                      await documentsState.onFinishDocument(
                                        context: context,
                                        inputs: inputs,
                                        sectionNo: widget.sectionNo,
                                        share: true,
                                      );
                                    },
                                  );
                                }
                              },
                            ),
                            CommonButton(
                                onPressed: () {
                                  documentsState.onExit(
                                    context: context,
                                    data: data,
                                  );
                                },
                                title: "exit".tr,
                                icon: const Icon(Icons.arrow_back_ios),
                                color: Colors.red)
                          ],
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
