import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BuildTextformfield extends StatelessWidget {
  final TextEditingController controller;
  final String svgIconPath;
  final bool readOnly;
  final String? labelText;
  final String? Function(String?)? validator;

  const BuildTextformfield({
    required this.controller,
    required this.svgIconPath,
    this.readOnly = false,
    this.labelText,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        validator: validator,
        decoration: InputDecoration(
          labelText: labelText,
          suffixIcon: Padding(
            padding: const EdgeInsets.all(12.0),
            child: SvgPicture.asset(svgIconPath),
          ),
          filled: true,
          fillColor: Colors.grey.shade200,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}

// ---------- REGEX VALIDATORS BELOW ----------

// Email validator
String? emailValidator(String? value) {
  if (value == null || value.isEmpty) return 'Email is required';
  final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  if (!regex.hasMatch(value)) return 'Enter a valid email';
  return null;
}

// Username validator
String? usernameValidator(String? value) {
  if (value == null || value.isEmpty) return 'Username is required';
  final regex = RegExp(r'^[a-zA-Z0-9_]{3,20}$');
  if (!regex.hasMatch(value)) return 'Enter a valid username (3-20 chars)';
  return null;
}

// Weight, height, or number validator
String? numberValidator(String? value) {
  if (value == null || value.isEmpty) return 'This field is required';
  final regex = RegExp(r'^\d+(\.\d+)?$');
  if (!regex.hasMatch(value)) return 'Enter a valid number';
  return null;
}
