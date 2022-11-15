import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smart_sales/Provider/user_state.dart';
import 'package:smart_sales/View/Widgets/Common/common_button.dart';
import 'package:smart_sales/View/Widgets/Common/custom_textfield.dart';
import 'package:provider/provider.dart';

void showForgotPassword({
  required BuildContext context,
}) {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  showAnimatedDialog(
    context: context,
    builder: (context) {
      return ListView(
        children: [
          AlertDialog(
            title: Text("forgot_password_dialog_alert_text".tr),
            content: FormBuilder(
              key: _formKey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: CustomTextField(
                      hintText: "forgot_password_dialog_first_hint_text".tr,
                      name: "ip_address",
                      activated: true,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: CustomTextField(
                      hintText: "forgot_password_dialog_second_hint_text".tr,
                      name: "user_id",
                      activated: true,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: CustomTextField(
                      hintText: "forgot_password_dialog_third_hint_text".tr,
                      name: "ip_password",
                      activated: true,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              CommonButton(
                  title: "enter".tr,
                  icon: const Icon(Icons.login),
                  color: Colors.green,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      context
                          .read<UserState>()
                          .setLoginInfo(input: _formKey.currentState!.value);
                      await GetStorage().write("ip_password",
                          _formKey.currentState!.value["ip_password"]);
                      Navigator.of(context).pop();
                    }
                  }),
              CommonButton(
                title: "back".tr,
                icon: const Icon(Icons.arrow_back_ios),
                color: Colors.red,
                onPressed: () async {
                  Get.back();
                },
              )
            ],
          ),
        ],
      );
    },
  );
}
