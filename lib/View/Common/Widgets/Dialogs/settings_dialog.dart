import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smart_sales/App/Resources/screen_size.dart';
import 'package:smart_sales/App/Util/routing.dart';
import 'package:smart_sales/View/Common/Widgets/Common/common_button.dart';
import 'package:smart_sales/View/Common/Widgets/Common/custom_textfield.dart';

void passwordDialog({
  required BuildContext context,
  required String title,
  required Function onCheck,
}) {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  AwesomeDialog(
    context: context,
    dialogType: DialogType.INFO_REVERSED,
    animType: AnimType.SCALE,
    width: screenWidth(context) * 0.7,
    body: FormBuilder(
      key: _formKey,
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          CustomTextField(
            hintText: "enter_api_password".tr,
            name: "ip_password",
            activated: true,
            validators: FormBuilderValidators.required(context),
          ),
        ],
      ),
    ),
    btnCancelText: "cancel".tr,
    btnOk: CommonButton(
      title: "enter".tr,
      icon: const Icon(Icons.login),
      color: Colors.blue,
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();
          if (_formKey.currentState!.value["ip_password"] ==
              GetStorage().read("ip_password")) {
            Get.back();
            onCheck();
          }
        }
      },
    ),
  ).show();
}
