// build_textformfield.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BuildTextformfield extends StatelessWidget {
  final TextEditingController controller;
  final String svgIconPath;
  final bool readOnly;
  final String? labelText;

  const BuildTextformfield({
    required this.controller,
    required this.svgIconPath,
    this.readOnly = false, this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,

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
