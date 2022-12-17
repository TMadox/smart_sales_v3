import 'package:auto_size_text/auto_size_text.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smart_sales/App/Resources/values_manager.dart';
import 'package:smart_sales/Data/Models/mow_model.dart';
import 'package:smart_sales/Provider/mow_state.dart';
import 'package:smart_sales/Provider/stor_state.dart';
import 'package:smart_sales/Provider/user_state.dart';
import 'package:smart_sales/View/Screens/Documents/documents_view.dart';
import 'package:smart_sales/View/Screens/Receipts/receipt_view.dart';
import 'package:smart_sales/View/Common/Widgets/Common/custom_textfield.dart';
import 'package:smart_sales/View/Screens/Receipts/receipts_controller.dart';

class MowView extends StatefulWidget {
  final bool canTap;
  final int sectionTypeNo;
  final bool canPushReplace;
  final int? storeId;
  const MowView({
    Key? key,
    required this.canTap,
    required this.sectionTypeNo,
    required this.canPushReplace,
    this.storeId,
  }) : super(key: key);

  @override
  State<MowView> createState() => _MowViewState();
}

class _MowViewState extends State<MowView> {
  String searchWord = "";
  late int selectedStoreId;
  @override
  void initState() {
    selectedStoreId =
        widget.storeId ?? context.read<UserState>().user.defStorId;
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
                      initialValue: selectedStoreId,
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
                                stor.name.toString(),
                                style: GoogleFonts.cairo(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              value: stor.id,
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
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
              child: DataTable(
            headingRowColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
              return Colors.green;
            }),
            dividerThickness: 1,
            headingRowHeight: 30,
            dataRowHeight: 30,
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
                .mapIndexed((index, mow) {
              final cell = [
                mow.accId,
                mow.name,
                mow.code,
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
                          Center(
                            child: Text(
                              ValuesManager.doubleToString(e),
                              textAlign: TextAlign.center,
                            ),
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
    );
  }

  List<MowModel> filterList(
      {required String input, required BuildContext context}) {
    if (input != "") {
      return context.read<MowState>().mows.where((element) {
        return (element.name.contains(input) ||
            element.accId.toString().contains(input));
      }).toList();
    } else {
      return context.read<MowState>().mows;
    }
  }

  Future<void> intializeReceipt({
    required BuildContext context,
    required MowModel mow,
  }) async {
    if (widget.canPushReplace) {
      Get.find<ReceiptsController>().startReceipt(
        entity: mow,
        context: context,
        sectionTypeNo: widget.sectionTypeNo,
        selectedStorId: widget.storeId,
        resetReceipt: true,
      );
      Get.back();
    } else {
      if (widget.sectionTypeNo == 104 || widget.sectionTypeNo == 103) {
        Get.to(
          () => DocumentsScreen(
            sectionTypeNo: widget.sectionTypeNo,
            entity: mow,
            entitiesList: context.read<MowState>().mows,
          ),
        );
      } else {
        Get.to(
          () => ReceiptView(
            entity: mow,
            sectionTypeNo: widget.sectionTypeNo,
            resetReceipt: true,
          ),
        );
      }
    }
  }
}
