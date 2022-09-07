import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_sales/App/Util/locator.dart';
import 'package:smart_sales/Data/Database/Shared/shared_storage.dart';
import 'package:smart_sales/Provider/general_state.dart';
import 'package:smart_sales/View/Widgets/Common/custom_textfield.dart';
import 'package:smart_sales/View/Widgets/Dialogs/exit_dialog.dart';
import 'package:smart_sales/View/Widgets/Dialogs/warning_dialog.dart';

class SearchBar extends StatelessWidget {
  final Map data;
  final GeneralState generalState;
  final Function(String?)? onChanged;
  final SharedPreferences storage;
  final Function() onTap;
  const SearchBar({
    Key? key,
    required this.data,
    this.onChanged,
    required this.storage,
    required this.generalState,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        FloatingActionButton(
          onPressed: () {
            if (context.read<GeneralState>().receiptItems.isNotEmpty) {
              warningDialog(
                context: context,
                warningText: 'receipt_still_inprogress'.tr,
                btnCancelText: 'exit'.tr,
                btnOkText: 'stay'.tr,
                onCancel: () {
                  if ((locator
                          .get<SharedStorage>()
                          .prefs
                          .getBool("request_visit") ??
                      true)) {
                    exitDialog(
                      context: context,
                      data: data,
                    );
                    return false;
                  } else {
                    Get.back();
                  }
                },
              );
            } else {
              if ((locator
                      .get<SharedStorage>()
                      .prefs
                      .getBool("request_visit") ??
                  true)) {
                exitDialog(
                  context: context,
                  data: data,
                );
              } else {
                Get.back();
              }
            }
          },
          child: const Icon(Icons.arrow_back_ios),
          backgroundColor: Colors.red,
          mini: true,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 5,
            ),
            child: CustomTextField(
              name: "search",
              hintText: "search".tr,
              activated: true,
              onChanged: onChanged,
              prefixIcon: const Icon(
                Icons.search,
              ),
            ),
          ),
        ),
        FloatingActionButton(
          onPressed: onTap,
          child: const Icon(Icons.minimize),
          mini: true,
        ),
      ],
    );
  }
}
