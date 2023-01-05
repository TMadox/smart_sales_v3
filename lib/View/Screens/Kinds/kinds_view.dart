import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smart_sales/App/Resources/values_manager.dart';
import 'package:smart_sales/Data/Models/kinds_model.dart';
import 'package:smart_sales/Provider/kinds_state.dart';
import 'package:smart_sales/View/Common/Widgets/Common/custom_textfield.dart';

class KindsView extends StatefulWidget {
  const KindsView({Key? key}) : super(key: key);

  @override
  State<KindsView> createState() => _KindsViewState();
}

class _KindsViewState extends State<KindsView> {
  String searchWord = "";
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
            child: DataTable(
          headingRowColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
            return Colors.green;
          }),
          dividerThickness: 1,
          showBottomBorder: true,
          headingRowHeight: 30,
          dataRowHeight: 30,
          columns: [
            "number".tr,
            "name".tr,
            "kind_code".tr,
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
              .mapIndexed((index, kind) {
            final cell = [kind.kindId, kind.kindName, kind.kindCode];
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
                            ValuesManager.numToString(e),
                          ),
                        ),
                      ),
                    )
                    .toList());
          }).toList(),
        )),
      ),
    );
  }

  List<KindsModel> filterList(
      {required String input, required BuildContext context}) {
    if (input != "") {
      return context.read<KindsState>().kinds.where((element) {
        return (element.kindName.contains(input) ||
            element.kindId.toString().contains(input));
      }).toList();
    } else {
      return context.read<KindsState>().kinds;
    }
  }
}
