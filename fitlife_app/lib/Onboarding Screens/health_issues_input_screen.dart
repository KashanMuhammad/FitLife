import 'package:flutter/material.dart';

import '../custom widgets/custom_inkwell.dart';

class HealthIssuesInputScreen extends StatefulWidget {
  @override
  State<HealthIssuesInputScreen> createState() => _HealtIssuesInputScreenState();
}

class _HealtIssuesInputScreenState extends State<HealthIssuesInputScreen> {
  int selectedIndex = 0;

  final List<String> options = [
    "None",
    "High Blood Pressure",
    "Diabetes",
    "Gluten-free",
    "High Cholestrole",
    "Others?",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),

                    // Step Indicator
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text.rich(
                          const TextSpan(
                            children: [
                              TextSpan(
                                text: '7',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              TextSpan(
                                text: ' / 7',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Title
                    Center(
                      child: Text.rich(
                        const TextSpan(
                          children: [
                            TextSpan(
                              text: 'Whats Your ',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            TextSpan(
                              text: 'Health Issue?',
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text("      Provide details about your health, dietary    "),
                    const Text(
                      "habit and goals to receive a personalized diet",
                      style: TextStyle(fontStyle: FontStyle.normal),
                    ),
                    const Text("         recommendation from your doctor         "),
                    const SizedBox(height: 20),

                    // Options
                    ...List.generate(options.length, (index) {
                      return CustomInkwell(
                        text: options[index],
                        isSelected: selectedIndex == index,
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                      );
                    }),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Fixed "Next" Button
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: buildNextButton(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildNextButton() {
    return InkWell(
      onTap: () {
        // TODO: Add your next screen navigation or action here
      },
      child: Container(
        height: 50,
        width: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
            colors: [Color(0xFF5AFF15), Color(0xFF00B712)],
          ),
        ),
        child: const Center(
          child: Text(
            "Next",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}
