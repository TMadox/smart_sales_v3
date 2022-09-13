import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:smart_sales/App/Resources/screen_size.dart';
import 'package:smart_sales/Provider/user_state.dart';
import 'package:smart_sales/View/Screens/Login/login_viewmodel.dart';
import 'package:smart_sales/View/Widgets/Common/common_button.dart';
import 'package:smart_sales/View/Widgets/Common/custom_textfield.dart';
import 'package:provider/provider.dart';
import 'package:smart_sales/View/Widgets/Dialogs/forgot_password_dialog.dart';
import 'package:smart_sales/View/Widgets/Dialogs/settings_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key})
      : super(
          key: key,
        );

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(onPressed: () async {
      //   final Dio _dio = Dio();
      //   final response = await _dio.get("https://reqbin.com/echo");
      //   log(response.statusCode.toString());
      //   log(response.data.toString());
      // }),
      body: Center(
              child: FormBuilder(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              showForgotPassword(context: context);
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            icon: const Icon(Icons.password),
                            label: Text("forgot_password".tr),
                          ),
                          SizedBox(
                            width: screenWidth(context) * 0.05,
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              settingsDialog(context: context);
                            },
                            style: ElevatedButton.styleFrom(
                                primary: Colors.blue,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            icon: const Icon(Icons.settings),
                            label: Text("settings".tr),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: screenHeight(context) * 0.065,
                      ),
                      Consumer<UserState>(
                        builder: (BuildContext context, value, Widget? child) =>
                            SizedBox(
                          width: screenWidth(context) * 0.9,
                          child: Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  hintText: 'enter_username'.tr,
                                  name: 'username',
                                  activated: value.loginInfo.isNotEmpty,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: CustomTextField(
                                  hintText: 'enter_password'.tr,
                                  name: 'password',
                                  activated: value.loginInfo.isNotEmpty,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: screenHeight(context) * 0.065,
                      ),
                      SizedBox(
                        // width: ,
                        child: CommonButton(
                          title: "enter".tr,
                          icon: const Icon(Icons.login),
                          color: Colors.green,
                          onPressed: () async {
                            await context
                                .read<LoginViewmodel>()
                                .validateAndLogin(
                                  context: context,
                                  formKey: _formKey,
                                );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
