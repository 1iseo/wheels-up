import 'package:flutter/material.dart';
import 'package:flutter_application_3/components/input_decoration.dart';

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
    return TextField(
      controller: widget.controller,
      obscureText: _obscureText,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      onChanged: widget.onChanged,
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
      decoration: outlinedInputDecoration(
        hintText: widget.hintText,
        suffixText: "*",
        suffixIcon: widget.obscureText
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey,
                  size: 18,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null,
      ),
    );
  }
}
