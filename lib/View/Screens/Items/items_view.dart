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
import 'package:smart_sales/View/Screens/Items/Items_viewmodel.dart';
import 'package:smart_sales/Provider/powers_state.dart';
import 'package:smart_sales/View/Widgets/Common/custom_textfield.dart';
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
  @override
  Widget build(BuildContext context) {
    final itemsState = context.read<ItemsViewmodel>();
    return SafeArea(
      left: false,
      right: false,
      bottom: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
                    initialValue: FilterType.more,
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
                    inputType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      FilteringTextInputFormatter.deny("")
                    ],
                    activated: true,
                    hintText: "ادخل السعر",
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
        body: WillPopScope(
          onWillPop: () async {
            itemsState.reset();
            return true;
          },
          child: LayoutBuilder(
            builder: (BuildContext lContext, BoxConstraints constraints) {
              double width = constraints.maxWidth;
              double height = constraints.maxHeight;
              return Center(
                child: SizedBox(
                  width: width * 0.98,
                  height: height * 0.95,
                  child: Column(
                    children: [
                      Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            "last_items_update".tr +
                                ": " +
                                context.read<ItemsViewmodel>().lastFetchDate,
                            style:
                                GoogleFonts.cairo(fontWeight: FontWeight.bold),
                          )),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: SingleChildScrollView(
                            child: Consumer<ItemsViewmodel>(
                              builder:
                                  (BuildContext context, state, Widget? child) {
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
                                  headingRowHeight: height * 0.09,
                                  dataRowHeight: height * 0.1,
                                  horizontalMargin: 0,
                                  arrowHeadColor: Colors.green,
                                  columnSpacing: 0,
                                  columns: showAvPrice(context)
                                      .map(
                                        (e) => DataColumn(
                                          label: Expanded(
                                            child: Container(
                                              alignment:
                                                  AlignmentDirectional.center,
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
                                  ),
                                  rowsPerPage: 8,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: DataTable(
                            headingRowColor:
                                MaterialStateProperty.resolveWith<Color?>(
                                    (Set<MaterialState> states) {
                              return smaltBlue;
                            }),
                            border: TableBorder.all(
                                width: 0.5,
                                style: BorderStyle.none,
                                borderRadius: BorderRadius.circular(15)),
                            headingRowHeight: height * 0.07,
                            dataRowHeight: height * 0.07,
                            columns:
                                ["total_items".tr, 'total_items_quantity'.tr]
                                    .map((e) => DataColumn(
                                            label: Expanded(
                                          child: Center(
                                            child: Text(
                                              e,
                                              style: GoogleFonts.cairo(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        )))
                                    .toList(),
                            rows: [
                              DataRow(cells: [
                                DataCell(
                                  Center(
                                    child: Text(
                                      context
                                          .read<ItemsViewmodel>()
                                          .items
                                          .where((element) =>
                                              element.unitConvert == 1)
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
                                      ValuesManager.doubleToString(context
                                          .read<ItemsViewmodel>()
                                          .items
                                          .where((element) =>
                                              element.unitConvert == 1)
                                          .fold<double>(
                                              0,
                                              (double sum, item) =>
                                                  sum + item.curQty)),
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.cairo(),
                                    ),
                                  ),
                                )
                              ])
                            ]),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  List showAvPrice(BuildContext context) {
    List<String> tableHeaders = List.from([
      "number".tr,
      "name".tr,
      "unit".tr,
      "qty".tr,
      "normal_price".tr,
      "sectoral_price".tr,
      "avg_selling_price".tr,
      "last_selling_price".tr,
      "barcode".tr,
      "stor_id".tr,
    ]);
    if (context.read<PowersState>().showPurchasePrices) {
      return tableHeaders;
    } else {
      tableHeaders.remove("avg_selling_price".tr);
      tableHeaders.remove("last_selling_price".tr);
      return tableHeaders;
    }
  }
}
