import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class CustomTextField extends StatelessWidget {
  final String? hintText;
  final String name;
  final Icon? prefixIcon;
  final Color? fillColor;
  final bool? activated;
  final TextAlign? textAlign;
  final Function(String?)? onChanged;
  final Function(String?)? onSubmitted;
  final String? initialValue;
  final bool? isDense;
  final TextInputType? inputType;
  final TextEditingController? editingController;
  final bool autoFocus;
  final String? Function(String?)? validators;
  final Function()? onTap;
  final Widget? suffixWidget;
  final List<TextInputFormatter> inputFormatters;
  final bool readOnly;
  final double? errorFontSize;
  final AutovalidateMode? validationMode;
  const CustomTextField({
    Key? key,
    this.hintText,
    this.isDense,
    required this.name,
    this.prefixIcon,
    this.fillColor,
    this.activated,
    this.onChanged,
    this.initialValue,
    this.onSubmitted,
    this.inputType,
    this.autoFocus = false,
    this.editingController,
    this.onTap,
    this.validators,
    this.suffixWidget,
    this.readOnly = false,
    this.inputFormatters = const [],
    this.validationMode,
    this.textAlign,
    this.errorFontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      cursorColor: Colors.green,
      validator: validators ?? FormBuilderValidators.required(context),
      enabled: activated ?? false,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      onTap: onTap,
      autofocus: autoFocus,
      initialValue: initialValue,
      controller: editingController,
      inputFormatters: inputFormatters,
      keyboardType: inputType,
      readOnly: readOnly,
      autovalidateMode: validationMode ?? AutovalidateMode.disabled,
      textAlign: textAlign ?? TextAlign.start,
      decoration: InputDecoration(
        errorStyle: TextStyle(
          fontSize: errorFontSize,
          height: errorFontSize,
        ),
        suffix: suffixWidget,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        prefixIcon: prefixIcon,
        hintText: hintText,
        fillColor: fillColor,
        isDense: isDense,
        filled: true,
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
      ),
      name: name,
    );
  }
}
