import 'package:auto_size_text/auto_size_text.dart';
// ignore: implementation_imports
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_sales/App/Util/colors.dart';
import 'package:smart_sales/Data/Models/client_model.dart';
import 'package:smart_sales/Provider/clients_state.dart';
import 'package:smart_sales/Provider/general_state.dart';
import 'package:smart_sales/Provider/options_state.dart';
import 'package:smart_sales/Provider/stor_state.dart';
import 'package:smart_sales/Provider/user_state.dart';
import 'package:smart_sales/View/Screens/Clients/clients_source.dart';
import 'package:smart_sales/View/Widgets/Common/custom_textfield.dart';
import 'package:provider/provider.dart';

class ClientsScreen extends StatefulWidget {
  final bool canPushReplace;
  final int sectionType;
  final bool canTap;
  const ClientsScreen({
    Key? key,
    required this.canPushReplace,
    required this.sectionType,
    required this.canTap,
  }) : super(key: key);
  @override
  State<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
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
                        searchWord = p0 ?? "";
                      });
                    },
                    prefixIcon: const Icon(Icons.search),
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
                        enabled: context
                                .read<OptionsState>()
                                .options
                                .firstWhere((element) => element.optionId == 6)
                                .optionValue ==
                            1,
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
                borderRadius: BorderRadius.circular(15),
                child: SizedBox(
                  width: width * 0.98,
                  height: height * 0.95,
                  child: Column(
                    children: [
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Text(
                          "last_clients_update".tr +
                              ": " +
                              context
                                  .read<ClientsState>()
                                  .lastCustomerFetchDate,
                          style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: PaginatedDataTable(
                              sortAscending: true,
                              headingRowHeight: height * 0.09,
                              dataRowHeight: height * 0.1,
                              horizontalMargin: 0,
                              arrowHeadColor: Colors.green,
                              columnSpacing: 0,
                              columns: [
                                "number".tr,
                                "name".tr,
                                "cst_code".tr,
                                "current_credit".tr,
                                "max_debt".tr,
                                "employee_number".tr,
                                "user_number".tr,
                              ]
                                  .map(
                                    (e) => DataColumn(
                                      label: Expanded(
                                        child: Container(
                                          alignment:
                                              AlignmentDirectional.center,
                                          color: Colors.green,
                                          width: double.infinity,
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
                              source: ClientsSource(
                                clients: filterList(
                                  context: context,
                                  input: searchWord,
                                ),
                                context: context,
                                canTap: widget.canTap,
                                canPushReplacement: widget.canPushReplace,
                                sectionTypeNo: widget.sectionType,
                                selectedStorId: selectedStoreId,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Consumer<ClientsState>(
                          builder:
                              (BuildContext context, value, Widget? child) {
                            double totalCredit = 0;
                            for (var clients in value.clients) {
                              totalCredit += clients.curBalance!;
                            }
                            return Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.02,
                                  ),
                                  color: smaltBlue,
                                  child: Text(
                                    "total_credit".tr,
                                    style: GoogleFonts.cairo(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.02,
                                  ),
                                  child: AutoSizeText(
                                    totalCredit.toString(),
                                    style: GoogleFonts.cairo(),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      )
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

  List<ClientsModel> filterList(
      {required String input, required BuildContext context}) {
    if (input != "") {
      return context.read<ClientsState>().clients.where((element) {
        return (element.amName!.contains(input) ||
            element.accId.toString().contains(input));
      }).toList();
    } else {
      return context.read<ClientsState>().clients;
    }
  }
}
