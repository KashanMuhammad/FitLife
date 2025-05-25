import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomBarIconsContainer extends StatelessWidget {
  final int currentIndex;
  final int index;
  final String imagePath;

  const BottomBarIconsContainer({
    Key? key,
    required this.currentIndex,
    required this.index,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isSelected = currentIndex == index;
    return Container(
      height: 45,
      width: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        color: isSelected ? Color(0xFF00B712) : Colors.transparent,
      ),
      child: Center(
        child: SvgPicture.asset(
          imagePath,
          height: 24,
          width: 24,
          color: isSelected ? Colors.white : Colors.green.withOpacity(0.8),
        ),
      ),
    );
  }
}

