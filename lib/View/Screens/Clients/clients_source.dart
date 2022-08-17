import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:smart_sales/App/Resources/screen_size.dart';
import 'package:smart_sales/App/Resources/values_manager.dart';
import 'package:smart_sales/Data/Models/client_model.dart';
import 'package:smart_sales/View/Screens/Clients/clients_viewmodel.dart';

class ClientsSource extends DataTableSource {
  final List<ClientModel> clients;
  final BuildContext context;
  final bool canTap;
  final int sectionTypeNo;
  final bool canPushReplacement;
  final int selectedStorId;
  ClientsSource({
    required this.selectedStorId,
    required this.clients,
    required this.context,
    required this.canTap,
    required this.sectionTypeNo,
    required this.canPushReplacement,
  });
  List prepareCells(ClientModel client) {
    return [
      client.amId,
      client.amName,
      client.amCode,
      client.curBalance,
      client.maxCredit,
      client.employAccId,
      client.accId
    ];
  }

  @override
  DataRow? getRow(int index) {
    ClientModel client = clients[index];
    List cells = prepareCells(client);
    return DataRow(
        color: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
          if ((index % 2) == 0) {
            return Colors.grey[200];
          }
          return null;
        }),
        cells: cells
            .mapIndexed(
              (index, e) => DataCell(
                  index != 1
                      ? SizedBox(
                          width: screenWidth(context) * 0.2,
                          child: Center(
                            child: AutoSizeText(
                              ValuesManager.doubleToString(e),
                              overflow: TextOverflow.visible,
                              maxLines: 1,
                            ),
                          ),
                        )
                      : Center(
                          child: Text(
                            ValuesManager.doubleToString(e),
                          ),
                        ), onTap: () async {
                if (canTap) {
                  log(selectedStorId.toString());
                  await ClientsViewmodel().intializeReceipt(
                    context: context,
                    client: client,
                    sectionTypeNo: sectionTypeNo,
                    canPushReplacement: canPushReplacement,
                    selectedStorId: selectedStorId,
                  );
                }
              }),
            )
            .toList());
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => clients.length;

  @override
  int get selectedRowCount => 0;
}
