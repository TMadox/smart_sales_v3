import 'package:auto_size_text/auto_size_text.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:smart_sales/App/Resources/values_manager.dart';
import 'package:smart_sales/Data/Models/employee.dart';
import 'package:smart_sales/Data/Models/entity.dart';

class EmployeesSource extends DataTableSource {
  final List<Employee> employees;
  final Function(Entity entity) onTap;
  EmployeesSource({
    required this.employees,
    required this.onTap,
  });
  List prepareCells(Employee client) {
    return [client.id, client.name, client.accId];
  }

  @override
  DataRow? getRow(int index) {
    Employee entity = employees[index];
    List cells = prepareCells(entity);
    return DataRow(
        color: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
          if ((index % 2) == 0) {
            return Colors.grey[200];
          }
          return null;
        }),
        cells: cells
            .mapIndexed((index, item) => DataCell(
                  Center(
                    child: SizedBox(
                      width: 100,
                      child: AutoSizeText(
                        ValuesManager.numToString(item),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.visible,
                        maxLines: 1,
                      ),
                    ),
                  ),
                  onTap: () {
                    onTap(entity);
                  },
                ))
            .toList());
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => employees.length;

  @override
  int get selectedRowCount => 0;
}
