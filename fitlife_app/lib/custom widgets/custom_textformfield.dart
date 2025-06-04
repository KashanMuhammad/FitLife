import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomTextFormField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final bool readOnly;
  final VoidCallback? onTap;

  // SVG suffix icon support
  final String? suffixSvgAsset;
  final VoidCallback? suffixOnPressed;

  const CustomTextFormField({
    super.key,
    required this.hintText,
    required this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.prefixIcon,
    this.readOnly = false,
    this.onTap,
    this.suffixSvgAsset,
    this.suffixOnPressed,
  });

  @override
  Widget build(BuildContext context) {
    Color softBlack = Colors.black38;
    Color softBorder = Colors.black38;

    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: validator,
        readOnly: readOnly,
        onTap: onTap,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: softBlack),
          prefixIcon: prefixIcon != null
              ? IconTheme(
            data: IconThemeData(color: softBlack),
            child: prefixIcon!,
          )
              : null,
          suffixIcon: suffixSvgAsset != null
              ? IconButton(
            onPressed: suffixOnPressed,
            icon: SvgPicture.asset(
              suffixSvgAsset!,
              width: 22,
              height: 22,
              color: softBlack,
            ),
          )
              : null,
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: softBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: softBorder, width: 1.5),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
