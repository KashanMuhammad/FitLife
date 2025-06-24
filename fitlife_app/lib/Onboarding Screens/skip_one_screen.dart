import 'package:fitlife_app/Onboarding%20Screens/skip_two_screen.dart';
import 'package:fitlife_app/custom%20widgets/skip_screens_template.dart';
import 'package:fitlife_app/home_screen.dart';
import 'package:flutter/material.dart';

class SkipOneScreen extends StatefulWidget {
  const SkipOneScreen({super.key});

  @override
  State<SkipOneScreen> createState() => _SkipOneScreenState();
}

class _SkipOneScreenState extends State<SkipOneScreen> {
  @override
  Widget build(BuildContext context) {
    return SkipScreensTemplate(
      imagePath: 'assets/images/climbing-stairs.svg',
      title: "Transform Your Life",
      description:
          "Unlock a healthier version of yourself with personalized diet plans, hormone balance, and sustainable nutrition.",
      buttonText: "Next",
      onNext: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> SkipTwoScreen()));
      },
      onSkip: (){
        Navigator.pop(context, MaterialPageRoute(builder: (context)=> HomeScreen()));
      },
    );
  }
}
