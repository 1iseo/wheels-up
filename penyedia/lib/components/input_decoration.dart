import 'package:flutter/material.dart';

InputDecoration outlinedInputDecoration({
  required String hintText,
  String suffixText = '*',
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
    suffix: Text(
      suffixText,
      style: const TextStyle(color: Colors.red, fontSize: 14, height: 2),
    ),
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
