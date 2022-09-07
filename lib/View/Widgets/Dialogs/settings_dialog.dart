import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_sales/App/Resources/screen_size.dart';
import 'package:smart_sales/App/Util/routing.dart';
import 'package:smart_sales/View/Widgets/Common/common_button.dart';
import 'package:smart_sales/View/Widgets/Common/custom_textfield.dart';

void settingsDialog({
  required BuildContext context,
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
            "settings".tr,
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
          SharedPreferences prefs = await SharedPreferences.getInstance();
          if (_formKey.currentState!.value["ip_password"] ==
              prefs.getString("ip_password")) {
            Get.back();
            Navigator.of(context).pushNamed(Routes.settingsRoute);
          }
        }
      },
    ),
  ).show();
}
