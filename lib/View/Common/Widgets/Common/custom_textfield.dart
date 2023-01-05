import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class CustomTextField extends StatefulWidget {
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
  final Color? borderColor;
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
    this.borderColor,
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
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      cursorColor: Colors.green,
      validator: widget.validators ?? FormBuilderValidators.required(context),
      enabled: widget.activated ?? false,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      onTap: widget.onTap,
      autofocus: widget.autoFocus,
      initialValue: widget.initialValue,
      controller: widget.editingController,
      inputFormatters: widget.inputFormatters,
      keyboardType: widget.inputType,
      readOnly: widget.readOnly,
      autovalidateMode: widget.validationMode ?? AutovalidateMode.disabled,
      textAlign: widget.textAlign ?? TextAlign.start,
      decoration: InputDecoration(
        errorStyle: TextStyle(
          fontSize: widget.errorFontSize,
          height: widget.errorFontSize,
        ),
        suffix: widget.suffixWidget,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        prefixIcon: widget.prefixIcon,
        hintText: widget.hintText,
        fillColor: widget.fillColor,
        isDense: widget.isDense,
        filled: true,
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: widget.borderColor ?? Colors.grey),
          borderRadius: const BorderRadius.all(
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
      name: widget.name,
    );
  }
}
