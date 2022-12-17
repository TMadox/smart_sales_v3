import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_sales/View/Screens/Documents/documents_view.dart';
import 'package:smart_sales/View/Screens/Employees/employees_controller.dart';
import 'package:smart_sales/View/Screens/Employees/employees_source.dart';
import 'package:smart_sales/View/Common/Widgets/Common/custom_textfield.dart';

class EmployeeView extends GetView<EmployeesController> {
  final bool canTap;
  final bool canPushReplace;
  final int sectionTypeNo;
  const EmployeeView({
    Key? key,
    required this.canTap,
    required this.canPushReplace,
    required this.sectionTypeNo,
  }) : super(key: key);

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
                      controller.search = p0 ?? "";
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
            child: PaginatedDataTable(
              headingRowHeight: 30,
              dataRowHeight: 30,
              horizontalMargin: 0,
              arrowHeadColor: Colors.green,
              columnSpacing: 0,
              columns: [
                "number".tr,
                "name".tr,
                "employee id".tr,
              ]
                  .map(
                    (name) => DataColumn(
                      label: Expanded(
                        child: Container(
                          alignment: AlignmentDirectional.center,
                          color: Colors.green,
                          width: double.infinity,
                          child: Text(
                            name,
                            style: GoogleFonts.cairo(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
              source: EmployeesSource(
                employees: controller.filterList(),
                onTap: (entity) {
                  if (canTap) {
                    Get.to(
                      () => DocumentsScreen(
                        sectionTypeNo: sectionTypeNo,
                        entity: entity,
                        entitiesList: controller.employees.value,
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
