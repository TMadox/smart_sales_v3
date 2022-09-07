import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:smart_sales/View/Screens/Receipts/receipt_viewmodel.dart';
import 'package:smart_sales/View/Widgets/Common/common_button.dart';
import 'package:smart_sales/View/Widgets/Common/custom_textfield.dart';
import 'package:provider/provider.dart';

exitDialog({
  required BuildContext context,
  required Map data,
}) {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  return AwesomeDialog(
    context: context,
    dialogType: DialogType.INFO_REVERSED,
    animType: AnimType.SCALE,
    title: 'confirm'.tr,
    body: FormBuilder(
      key: _formKey,
      child: Column(
        children: [
          Text("exit_message".tr),
          CustomTextField(
            activated: true,
            hintText: "leaving_reason".tr,
            name: "notes",
            validators: FormBuilderValidators.required(context),
          ),
        ],
      ),
    ),
    btnCancelText: "cancel".tr,
    btnOk: CommonButton(
      title: "finish".tr,
      icon: const Icon(Icons.thumb_up),
      color: Colors.blue,
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();
          Get.back();
          EasyLoading.show();
          data.addAll(_formKey.currentState!.value);
          await context.read<ReceiptViewmodel>().saveVisit(
                data: data,
                context: context,
              );
          EasyLoading.dismiss();
          Get.back();
        }
      },
    ),
  )..show();
}
