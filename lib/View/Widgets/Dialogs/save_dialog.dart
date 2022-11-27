import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smart_sales/App/Resources/values_manager.dart';
import 'package:smart_sales/Provider/general_state.dart';
import 'package:smart_sales/View/Widgets/Common/common_button.dart';
import 'package:universal_io/io.dart';

saveDialog({
  required BuildContext context,
  void Function()? onShare,
  void Function()? onSave,
  void Function()? onPrint,
  void Function()? onCancel,
}) =>
    AwesomeDialog(
      context: context,
      dialogType: DialogType.QUESTION,
      animType: AnimType.BOTTOMSLIDE,
      body: Column(
        children: [
          Text(
            'save_dialog_title'.tr,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 23,
            ),
          ),
          Text(
            'save_dialog_desc'.tr,
            style: const TextStyle(
              fontSize: 19,
            ),
          ),
          Visibility(
            visible:
                context.read<GeneralState>().currentReceipt["section_type_no"] <
                    100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.cairo(color: Colors.black, fontSize: 17),
                    children: [
                      TextSpan(
                        text: "receipt_total".tr + ": ",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: ValuesManager.doubleToString(
                          context
                              .read<GeneralState>()
                              .currentReceipt['oper_net_value_with_tax'],
                        ),
                      ),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.cairo(color: Colors.black, fontSize: 17),
                    children: [
                      TextSpan(
                        text: "cash".tr + ": ",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: ValuesManager.doubleToString(
                          context
                              .read<GeneralState>()
                              .currentReceipt['cash_value'],
                        ),
                      ),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.cairo(color: Colors.black, fontSize: 17),
                    children: [
                      TextSpan(
                        text: "remaining".tr + ": ",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: ValuesManager.doubleToString(
                          context
                              .read<GeneralState>()
                              .currentReceipt['reside_value'],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      btnOk: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CommonButton(
            title: "save_dialog_first_common_button".tr,
            icon: const Icon(Icons.save),
            color: Colors.orange,
            onPressed: onSave,
          ),
          if (!kIsWeb && !Platform.isWindows)
            CommonButton(
              title: "save_dialog_second_common_button".tr,
              icon: const Icon(Icons.share),
              color: Colors.green,
              onPressed: onShare,
            ),
          CommonButton(
            title: "save_dialog_third_common_button".tr,
            icon: const Icon(Icons.print),
            color: Colors.purple,
            onPressed: onPrint,
          ),
          CommonButton(
            title: "save_dialog_fourth_common_button".tr,
            icon: const Icon(Icons.cancel),
            color: Colors.red,
            onPressed: onCancel,
          ),
        ],
      ),
    ).show();
