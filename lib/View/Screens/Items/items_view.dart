import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_sales/App/Resources/enums_manager.dart';
import 'package:smart_sales/App/Util/colors.dart';
import 'package:smart_sales/View/Screens/Items/items_source.dart';
import 'package:smart_sales/App/Resources/values_manager.dart';
import 'package:smart_sales/View/Screens/Items/items_viewmodel.dart';
import 'package:smart_sales/Provider/powers_state.dart';
import 'package:smart_sales/View/Common/Widgets/Common/custom_textfield.dart';
import 'package:provider/provider.dart';

class ItemsView extends StatefulWidget {
  final bool canTap;
  const ItemsView({Key? key, required this.canTap}) : super(key: key);
  @override
  State<ItemsView> createState() => _ItemsViewState();
}

class _ItemsViewState extends State<ItemsView> {
  String searchWord = "";
  final TextEditingController _controller =
      TextEditingController(text: 0.toString());
  late ItemsViewmodel itemsState;

  @override
  void initState() {
    context.read<ItemsViewmodel>().reset();
    itemsState = context.read<ItemsViewmodel>();
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
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        floatingActionButton:
            Consumer<ItemsViewmodel>(builder: (context, state, widget) {
          if (state.selectedItems.isNotEmpty) {
            return FloatingActionButton(
              onPressed: () {
                state.muliAddToReceipt(context: context);
                Get.back();
              },
              child: const Icon(Icons.add),
            );
          } else {
            return const SizedBox();
          }
        }),
        appBar: AppBar(
          leading: const SizedBox(),
          backgroundColor: Colors.white,
          flexibleSpace: Row(
            children: [
              const BackButton(
                color: Colors.green,
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(
                    5,
                  ),
                  child: CustomTextField(
                    name: "search",
                    hintText: "search".tr,
                    activated: true,
                    onChanged: (value) {
                      itemsState.setSearchWord(value.toString());
                    },
                    prefixIcon: const Icon(
                      Icons.search,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(
                    5,
                  ),
                  child: FormBuilderDropdown<FilterType>(
                    initialValue: itemsState.filterType,
                    name: "filter",
                    iconEnabledColor: Colors.transparent,
                    onChanged: (value) {
                      itemsState.setFilterType(
                        value!,
                      );
                    },
                    items: [
                      DropdownMenuItem(
                        alignment: AlignmentDirectional.center,
                        child: AutoSizeText(
                          "all".tr,
                          style: GoogleFonts.cairo(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                        value: FilterType.all,
                      ),
                      DropdownMenuItem(
                        alignment: AlignmentDirectional.center,
                        child: AutoSizeText(
                          "amount_more_than".tr,
                          maxLines: 1,
                          style: GoogleFonts.cairo(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                        value: FilterType.more,
                      ),
                      DropdownMenuItem(
                        alignment: AlignmentDirectional.center,
                        child: AutoSizeText(
                          "amount_less_than".tr,
                          maxLines: 1,
                          style: GoogleFonts.cairo(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                        value: FilterType.less,
                      ),
                    ],
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 5),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.green,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: CustomTextField(
                    editingController: _controller,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}')),
                      FilteringTextInputFormatter.deny("")
                    ],
                    activated: true,
                    hintText: "???????? ??????????",
                    name: "price",
                    onTap: () {
                      _controller.selection = TextSelection(
                        baseOffset: 0,
                        extentOffset: _controller.value.text.length,
                      );
                    },
                    onChanged: (value) {
                      if (value != "") {
                        itemsState.setCompareValue(
                          int.parse(
                            value.toString(),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
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
                  alignment: AlignmentDirectional.center,
                  child: SingleChildScrollView(
                    child: Consumer<ItemsViewmodel>(
                      builder: (BuildContext context, state, Widget? child) {
                        if (state
                            .filterStor(
                              context: context,
                              canTap: widget.canTap,
                            )
                            .isEmpty) {
                          return Text(
                            "no_items_found".tr,
                            style: GoogleFonts.cairo(
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }
                        return PaginatedDataTable(
                          sortAscending: true,
                          headingRowHeight: 30,
                          dataRowHeight: 30,
                          horizontalMargin: 0,
                          arrowHeadColor: Colors.green,
                          columnSpacing: 0,
                          columns: showAvPrice(context)
                              .map(
                                (e) => DataColumn(
                                  label: Expanded(
                                    child: Container(
                                      alignment: AlignmentDirectional.center,
                                      color: Colors.green,
                                      width: double.infinity,
                                      height: double.infinity,
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
                          source: ItemsSource(
                            items: state.filterStor(
                              context: context,
                              canTap: widget.canTap,
                            ),
                            context: context,
                            canTap: widget.canTap,
                            state: state,
                          ),
                          rowsPerPage: 8,
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: DataTable(
                  headingRowColor: MaterialStateProperty.resolveWith<Color?>(
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
                  columns: ["total_items".tr, 'total_items_quantity'.tr]
                      .map(
                        (txt) => DataColumn(
                          label: Expanded(
                            child: Center(
                              child: Text(
                                txt,
                                style: GoogleFonts.cairo(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                  rows: [
                    DataRow(
                      cells: [
                        DataCell(
                          Center(
                            child: Text(
                              context
                                  .read<ItemsViewmodel>()
                                  .items
                                  .where((element) => element.unitConvert == 1)
                                  .length
                                  .toString(),
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.cairo(),
                            ),
                          ),
                        ),
                        DataCell(
                          Center(
                            child: Text(
                              ValuesManager.numToString(
                                context
                                    .read<ItemsViewmodel>()
                                    .items
                                    .where(
                                        (element) => element.unitConvert == 1)
                                    .fold<double>(
                                        0,
                                        (double sum, item) =>
                                            sum + item.curQty),
                              ),
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.cairo(),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  List showAvPrice(BuildContext context) {
    List<String> tableHeaders = List.from(
      [
        "number".tr,
        "name".tr,
        "unit".tr,
        "qty".tr,
        "normal_price".tr,
        "sectoral_price".tr,
        "avg_selling_price".tr,
        "last_selling_price".tr,
        "barcode".tr,
        "stor id".tr,
      ],
    );
    if (context.read<PowersState>().showPurchasePrices) {
      return tableHeaders;
    } else {
      tableHeaders.remove("avg_selling_price".tr);
      tableHeaders.remove("last_selling_price".tr);
      return tableHeaders;
    }
  }
}
