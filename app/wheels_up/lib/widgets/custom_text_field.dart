import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

InputDecoration outlinedInputDecoration({
  required String hintText,
  String? suffixText,
  Widget? suffixIcon,
  Color hintColor = Colors.grey,
  Color fillColor = Colors.grey,
  Color borderColor = Colors.blue,
  double borderRadius = 15.0,
}) {
  return InputDecoration(
    hintStyle: TextStyle(color: Colors.grey.shade600),
    filled: true,
    fillColor: Colors.grey.shade200,
    hintText: hintText,
    suffix: suffixText != null
        ? Text(
            suffixText,
            style: const TextStyle(color: Colors.red, fontSize: 14, height: 2),
          )
        : null,
    suffixIcon: suffixIcon,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius), // Rounded corners
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: BorderSide(color: borderColor),
    ),
    contentPadding:
        const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
  );
}

class CustomTextField extends StatefulWidget {
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
  final String? prefixText;
  final bool readOnly;
  final String? errorText;
  final List<TextInputFormatter>? inputFormatters;

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
    this.inputFormatters,
    this.autofocus = false,
    this.prefixText,
    this.readOnly = false,
    this.errorText,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscureText,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      onChanged: widget.onChanged,
      validator: widget.validator,
      onTap: widget.onTap,
      enabled: widget.enabled,
      maxLines: widget.maxLines,
      maxLength: widget.maxLength,
      textCapitalization: widget.textCapitalization,
      focusNode: widget.focusNode,
      textAlign: widget.textAlign,
      style: widget.style,
      autofocus: widget.autofocus,
      readOnly: widget.readOnly,
      inputFormatters: widget.inputFormatters,
      decoration: outlinedInputDecoration(
        hintText: widget.hintText,
        suffixIcon: widget.obscureText
            ? IconButton( 
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null,
      ).copyWith(
        errorText: widget.errorText,
        prefixText: widget.prefixText,
        errorStyle: const TextStyle(color: Colors.red),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }
}
