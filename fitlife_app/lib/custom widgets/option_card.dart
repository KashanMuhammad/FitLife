import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OptionCard extends StatelessWidget {
  final String title;
  final String svgAssetPath;
  final VoidCallback onTap;
  final Color backgroundColor;

  const OptionCard({
    super.key,
    required this.title,
    required this.svgAssetPath,
    required this.onTap,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          child: Column(
            children: [
              SvgPicture.asset(svgAssetPath, height: 26, width: 26),
              Spacer(),
              Row(
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  Expanded(
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
