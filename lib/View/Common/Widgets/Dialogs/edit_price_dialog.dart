import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_sales/App/Resources/values_manager.dart';
import 'package:smart_sales/View/Common/Controllers/general_controller.dart';
import 'package:smart_sales/View/Common/Widgets/Common/custom_textfield.dart';
import 'package:smart_sales/View/Common/Widgets/Dialogs/general_dialog.dart';

void showEditPriceDialog({
  required BuildContext context,
  required String leastSellingPrice,
  required Map item,
  required String originalPrice,
  required GeneralController generalController,
  required String itemPrice,
}) {
  final TextEditingController _controller = TextEditingController(
      text: ValuesManager.doubleToString(double.parse(itemPrice)));
  showAnimatedDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return ListView(
        children: [
          AlertDialog(
            title: Text(
              "edit_price_dialog_title".tr,
              style: GoogleFonts.cairo(
                  color: Colors.black, fontWeight: FontWeight.bold),
            ),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      "edit_price_dialog_first_text".tr +
                          ": " +
                          ValuesManager.doubleToString(
                              double.parse(leastSellingPrice)),
                      style: GoogleFonts.cairo(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "edit_price_dialog_second_text".tr +
                          ": " +
                          ValuesManager.doubleToString(
                              double.parse(originalPrice)),
                      style: GoogleFonts.cairo(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "edit_price_dialog_third_text".tr + ": ",
                      style: GoogleFonts.cairo(),
                    ),
                    Expanded(
                      child: CustomTextField(
                        hintText: "edit_price_dialog_title".tr,
                        activated: true,
                        name: "original_price",
                        onTap: () {
                          _controller.selection = TextSelection(
                              baseOffset: 0,
                              extentOffset: _controller.value.text.length);
                        },
                        editingController: _controller,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    try {
                      generalController.editItem(
                        item: item,
                        input: {
                          "original_price": double.parse(_controller.value.text)
                        },
                      );
                      Navigator.of(context).pop();
                    } catch (e) {
                      generalController.editItem(
                        item: item,
                        input: {
                          "original_price": double.parse(itemPrice),
                        },
                      );
                      generalDialog(
                        context: context,
                        dialogType: DialogType.ERROR,
                        title: "error".tr,
                        onOkColor: Colors.green,
                        message: e.toString(),
                        onOkIcon: const Icon(Icons.check_circle),
                        onOkText: 'ok'.tr,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text("ok".tr),
                ),
              )
            ],
          ),
        ],
      );
    },
  );
}
