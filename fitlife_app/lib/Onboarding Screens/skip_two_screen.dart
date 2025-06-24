import 'package:fitlife_app/Onboarding%20Screens/skip_three_screen.dart';
import 'package:flutter/material.dart';

import '../custom widgets/skip_screens_template.dart';
import '../home_screen.dart';

class SkipTwoScreen extends StatefulWidget {
  const SkipTwoScreen({super.key});

  @override
  State<SkipTwoScreen> createState() => _SkipTwoScreenState();
}

class _SkipTwoScreenState extends State<SkipTwoScreen> {
  @override
  Widget build(BuildContext context) {
    return SkipScreensTemplate(
      imagePath: 'assets/images/workout-indoors.svg',
      title: "Tailored For You",
      description:
          "Your unique health and lifestyle matter Get a diet plan designed specifically to fit your goals and routine.",
      buttonText: "Next",
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
    );
    ;
  }
}
