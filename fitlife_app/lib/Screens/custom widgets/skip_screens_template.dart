import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'custom_inkwell.dart';

class SkipScreensTemplate extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  final String buttonText;
  final VoidCallback onNext;
  final VoidCallback onSkip;

  const SkipScreensTemplate({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.onNext,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextButton(onPressed: onSkip, child: const Text("Skip")),
            const SizedBox(height: 20),
            Center(
              child: SvgPicture.asset(
                imagePath,
                height: 260,
                placeholderBuilder:
                    (context) => const CircularProgressIndicator(),
                semanticsLabel: 'Onboarding Illustration',
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              description,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.left,
            ),
            const Spacer(),
            Center(
              child: CustomInkwell(
                text: buttonText,
                isSelected: true, // shows gradient
                onTap: onNext,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
