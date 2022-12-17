import 'package:auto_size_text/auto_size_text.dart';
// ignore: implementation_imports
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_sales/App/Resources/values_manager.dart';
import 'package:smart_sales/App/Util/colors.dart';
import 'package:smart_sales/Data/Models/client.dart';
import 'package:smart_sales/Provider/clients_state.dart';
import 'package:smart_sales/Provider/options_state.dart';
import 'package:smart_sales/Provider/stor_state.dart';
import 'package:smart_sales/Provider/user_state.dart';
import 'package:smart_sales/View/Screens/Clients/clients_source.dart';
import 'package:smart_sales/View/Common/Widgets/Common/custom_textfield.dart';
import 'package:provider/provider.dart';
import 'package:smart_sales/View/Screens/Items/items_viewmodel.dart';

class ClientsScreen extends StatefulWidget {
  final bool canPushReplace;
  final int sectionType;
  final bool canTap;
  final int? storeId;
  const ClientsScreen({
    Key? key,
    required this.canPushReplace,
    required this.sectionType,
    required this.canTap,
    this.storeId,
  }) : super(key: key);
  @override
  State<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
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
                        initialValue: selectedStoreId,
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
        body: Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  foregroundDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(color: Colors.green, width: 4),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: SingleChildScrollView(
                    child: PaginatedDataTable(
                      sortAscending: true,
                      headingRowHeight: 30,
                      dataRowHeight: 30,
                      horizontalMargin: 0,
                      arrowHeadColor: Colors.green,
                      columnSpacing: 0,
                      columns: [
                        "number",
                        "name",
                        "cst_code",
                        "current_credit",
                        "max_debt",
                        "employee_number",
                        "user_number",
                      ]
                          .map(
                            (title) => DataColumn(
                              label: Expanded(
                                child: Container(
                                  alignment: AlignmentDirectional.center,
                                  color: Colors.green,
                                  width: double.infinity,
                                  child: Text(
                                    title.tr,
                                    textAlign: TextAlign.center,
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
              const SizedBox(
                height: 5,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                clipBehavior: Clip.antiAlias,
                width: 200,
                child: Consumer<ClientsState>(
                  builder: (BuildContext context, value, Widget? child) {
                    double totalCredit = 0;
                    for (var clients in value.clients) {
                      totalCredit += clients.curBalance;
                    }
                    return DataTable(
                      headingRowColor:
                          MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                          return smaltBlue;
                        },
                      ),
                      border: TableBorder.all(
                        width: 0.5,
                        style: BorderStyle.none,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      headingRowHeight: 30,
                      dataRowHeight: 30,
                      horizontalMargin: 0,
                      columnSpacing: 0,
                      columns: [
                        DataColumn(
                          label: Expanded(
                            child: Center(
                              child: Text(
                                "total_credit".tr,
                                style: GoogleFonts.cairo(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                      rows: [
                        DataRow(
                          cells: [
                            DataCell(
                              Center(
                                child: Text(
                                  totalCredit.toString(),
                                  maxLines: 1,
                                  style: GoogleFonts.cairo(),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Client> filterList(
      {required String input, required BuildContext context}) {
    if (input != "") {
      return context.read<ClientsState>().clients.where((element) {
        return (element.name.contains(input) ||
            element.accId.toString().contains(input));
      }).toList();
    } else {
      return context.read<ClientsState>().clients;
    }
  }
}
