import 'package:flutter/material.dart';

import '../custom widgets/skip_screens_template.dart';
import '../home_screen.dart';
class SkipThreeScreen extends StatefulWidget {
  const SkipThreeScreen({super.key});

  @override
  State<SkipThreeScreen> createState() => _SkipThreeScreenState();
}

class _SkipThreeScreenState extends State<SkipThreeScreen> {
  @override
  Widget build(BuildContext context) {
    return SkipScreensTemplate(
      imagePath: 'assets/images/interfacetesting.svg',
      title: "Motivate and Succeed",
      description:"Stay inspired with real success stories and expert advice that keeps you on track and fully committed.",
       buttonText: "Continue",
      onNext: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SkipThreeScreen()),
        );
      },
      onSkip: () {
        Navigator.pop(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      },
    );;
  }
}
