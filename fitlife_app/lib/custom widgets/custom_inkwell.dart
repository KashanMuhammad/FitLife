import 'package:flutter/material.dart';

class CustomInkwell extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const CustomInkwell({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 50,
          width: 250,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: isSelected ? null : const Color(0xFFE9FDE3),
            gradient: isSelected
                ? const LinearGradient(
              colors: [Color(0xFF5AFF15), Color(0xFF00B712)],
            )
                : null,
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
