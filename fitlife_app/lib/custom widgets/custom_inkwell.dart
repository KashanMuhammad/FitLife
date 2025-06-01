import 'package:flutter/material.dart';

class CustomInkWellContainer extends StatelessWidget {
  final VoidCallback onTap;
  final String text;

  const CustomInkWellContainer({
    super.key,
    required this.onTap,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          SizedBox(width: 50,),
          InkWell(
            onTap: onTap,
            child: Container(
              height: 50,
              width: 350,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Color(0xFF00B712),
              ),
              child: Center(
                child: Text(
                  text,
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ),
          SizedBox(width: 20,),
        ],
      ),
    );
  }
}
