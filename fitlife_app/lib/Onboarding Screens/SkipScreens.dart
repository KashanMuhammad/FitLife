import 'package:fitlife_app/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:fitlife_app/home_screen.dart';
import 'package:fitlife_app/custom widgets/skip_screens_template.dart';

class SkipScreens extends StatefulWidget {
  const SkipScreens({super.key});

  @override
  State<SkipScreens> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<SkipScreens> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> pages = [
    {
      'image': 'assets/images/climbing-stairs.svg',
      'title': 'Transform Your Life',
      'desc':
      'Unlock a healthier version of yourself with personalized diet plans, hormone balance, and sustainable nutrition.',
      'button': 'Next',
    },
    {
      'image': 'assets/images/workout-indoors.svg',
      'title': 'Tailored For You',
      'desc':
      'Your unique health and lifestyle matter Get a diet plan designed specifically to fit your goals and routine.',
      'button': 'Next',
    },
    {
      'image': 'assets/images/interfacetesting.svg',
      'title': 'Motivate and Succeed',
      'desc':
      'Stay inspired with real success stories and expert advice that keeps you on track and fully committed.',
      'button': 'Continue',
    },
  ];

  void _onNext() {
    if (_currentPage < pages.length - 1) {
      _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainScreen()));
    }
  }

  void _onSkip() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _controller,
      onPageChanged: (index) {
        setState(() => _currentPage = index);
      },
      itemCount: pages.length,
      itemBuilder: (context, index) {
        final data = pages[index];
        return SkipScreensTemplate(
          imagePath: data['image']!,
          title: data['title']!,
          description: data['desc']!,
          buttonText: data['button']!,
          onNext: _onNext,
          onSkip: _onSkip,
        );
      },
    );
  }
}
