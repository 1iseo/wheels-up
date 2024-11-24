import 'package:flutter/material.dart';
import 'package:flutter_application_3/components/input_decoration.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final VoidCallback? onTap;
  final bool? enabled;
  final int? maxLines;
  final int? maxLength;
  final TextCapitalization textCapitalization;
  final FocusNode? focusNode;
  final TextAlign textAlign;
  final TextStyle? style;
  final bool autofocus;
  final bool readOnly;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.validator,
    this.onTap,
    this.enabled,
    this.maxLines = 1,
    this.maxLength,
    this.textCapitalization = TextCapitalization.none,
    this.focusNode,
    this.textAlign = TextAlign.start,
    this.style,
    this.autofocus = false,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onChanged: onChanged,
      onTap: onTap,
      enabled: enabled,
      maxLines: maxLines,
      maxLength: maxLength,
      textCapitalization: textCapitalization,
      focusNode: focusNode,
      textAlign: textAlign,
      style: style,
      autofocus: autofocus,
      readOnly: readOnly,
      decoration: outlinedInputDecoration(hintText: hintText),
    );
  }
}
