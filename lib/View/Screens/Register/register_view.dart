import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:smart_sales/App/Util/device.dart';
import 'package:smart_sales/App/Util/locator.dart';
import 'package:smart_sales/Provider/user_state.dart';
import 'package:smart_sales/View/Screens/Register/register_viewmodel.dart';
import 'package:smart_sales/View/Widgets/Common/common_button.dart';
import 'package:smart_sales/View/Widgets/Common/custom_textfield.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("سجل جديد"),
      ),
      body: FormBuilder(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            activated: true,
                            name: "am_name",
                            hintText: "الاسم",
                            validators: FormBuilderValidators.required(context),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: CustomTextField(
                            validators: (v) {
                              return null;
                            },
                            activated: true,
                            name: "street",
                            hintText: "العنوان",
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            validators: (v) {
                              return null;
                            },
                            activated: true,
                            inputType: TextInputType.number,
                            name: "tel1",
                            hintText: "الهاتف",
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: CustomTextField(
                            validators: (v) {
                              return null;
                            },
                            activated: true,
                            name: "note",
                            hintText: "الملحوظات",
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            validators: FormBuilderValidators.required(context),
                            name: "mandoub_acc_id",
                            initialValue: context
                                .read<UserState>()
                                .user
                                .defEmployAccId
                                .toString(),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: CustomTextField(
                            validators: FormBuilderValidators.required(context),
                            name: "branch_id",
                            initialValue: context
                                .read<UserState>()
                                .user
                                .branchId
                                .toString(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomTextField(
                      validators: FormBuilderValidators.required(context),
                      name: "refrence_id",
                      initialValue: locator.get<DeviceParam>().deviceId,
                    ),
                  )
                ],
              ),
            ),
            CommonButton(
              title: "تسجيل",
              icon: const Icon(Icons.save),
              color: Colors.green,
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  await RegisterViewmodel().addRecord(
                    data: _formKey.currentState!.value,
                    context: context,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
