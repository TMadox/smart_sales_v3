import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_sales/App/Resources/values_manager.dart';
import 'package:smart_sales/Data/Models/entity.dart';
import 'package:smart_sales/Provider/user_state.dart';
import 'package:smart_sales/View/Common/Features/exit.dart';
import 'package:smart_sales/View/Screens/Documents/Widgets/first_row.dart';
import 'package:smart_sales/View/Screens/Documents/Widgets/second_row.dart';
import 'package:smart_sales/View/Screens/Documents/Widgets/third_row.dart';
import 'package:smart_sales/View/Screens/Documents/document_controller.dart';
import 'package:smart_sales/View/Common/Widgets/Common/common_button.dart';
import 'package:smart_sales/View/Common/Widgets/Common/custom_textfield.dart';
import 'package:provider/provider.dart';
import 'package:smart_sales/View/Common/Widgets/Dialogs/save_dialog.dart';

class DocumentsScreen extends StatefulWidget {
  final int sectionTypeNo;
  final Entity entity;
  final List<Entity> entitiesList;
  const DocumentsScreen({
    Key? key,
    required this.sectionTypeNo,
    required this.entity,
    required this.entitiesList,
  }) : super(key: key);
  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final DocumentsController documentsController =
      Get.find<DocumentsController>();
  final TextEditingController textEditingController = TextEditingController();
  late Map data = {};
  @override
  void dispose() {
    documentsController.onDelete();
    super.dispose();
  }

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
    documentsController.startDocument(
      entity: widget.entity,
      context: context,
      sectionTypeNo: widget.sectionTypeNo,
      selectedStorId: null,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: WillPopScope(
        onWillPop: () async {
          return Exit().commit(context: context, data: data, warnExit: true);
        },
        child: SafeArea(
          left: false,
          right: false,
          bottom: false,
          child: Scaffold(
            body: Container(
              padding: const EdgeInsets.all(5),
              alignment: Alignment.center,
              child: FormBuilder(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      FirstRow(
                        sectionNo: widget.sectionTypeNo,
                        formKey: _formKey,
                        entity: widget.entity,
                        entites: widget.entitiesList,
                        documentsController: documentsController,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SecondRow(
                        sectionNo: widget.sectionTypeNo,
                        textController: textEditingController,
                        documentsController: documentsController,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ThirdRow(
                        sectionNo: widget.sectionTypeNo,
                        documentsController: documentsController,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          AutoSizeText("notes".tr),
                          const SizedBox(
                            width: 5,
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
                      const SizedBox(
                        height: 10,
                      ),
                      Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              width: 250,
                              child: Row(
                                children: [
                                  AutoSizeText(
                                    "credit_before".tr + ": ",
                                    style: GoogleFonts.cairo(
                                      fontSize: 20,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    child: AutoSizeText(
                                      widget.entity.curBalance
                                          .toStringAsFixed(3),
                                      maxLines: 1,
                                      style: GoogleFonts.cairo(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 250,
                              child: Row(
                                children: [
                                  AutoSizeText(
                                    "credit_after".tr + ": ",
                                    style: GoogleFonts.cairo(fontSize: 20),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    child: AutoSizeText(
                                      ValuesManager.numToString(
                                        documentsController
                                            .document.value["credit_after"],
                                      ),
                                      maxLines: 1,
                                      style: GoogleFonts.cairo(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 5,
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
                                    documentsController.finishDocument(
                                      context: context,
                                      inputs: inputs,
                                      savePdf: true,
                                    );
                                  },
                                  onSave: () async {
                                    await documentsController.finishDocument(
                                      context: context,
                                      inputs: inputs,
                                    );
                                  },
                                  onShare: () async {
                                    await documentsController.finishDocument(
                                      context: context,
                                      inputs: inputs,
                                      share: true,
                                    );
                                  },
                                  sectionTypeNo: widget.sectionTypeNo,
                                  operation: documentsController.document.value,
                                );
                              }
                            },
                          ),
                          CommonButton(
                            onPressed: () async {
                              Exit().commit(
                                  context: context, data: data, warnExit: true);
                            },
                            title: "exit".tr,
                            icon: const Icon(Icons.arrow_back_ios),
                            color: Colors.red,
                          )
                        ],
                      ),
                    ],
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
