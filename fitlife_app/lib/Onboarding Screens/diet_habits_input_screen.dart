import 'package:flutter/material.dart';

import '../custom widgets/custom_inkwell.dart';
import 'healt_issues_input_screen.dart';

class DietHabitsInputScreen extends StatefulWidget {
  @override
  State<DietHabitsInputScreen> createState() => _DietHabitsInputScreenState();
}

class _DietHabitsInputScreenState extends State<DietHabitsInputScreen> {
  int selectedIndex = 0;
 // First button selected by default
  final List<String> options = [
    "None",
    "Lightly Vagetarian",
    "Vegan",
    "Gluten-free",
    "Religious Restrictions",
    "Other's",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(15.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
            ),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text.rich(
                        const TextSpan(
                          children: [
                            TextSpan(
                              text: '6',
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
                            text: 'Diet Habit?',
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

                  // Render each CustomInkwell using List.generate
                  ...List.generate(options.length, (index) {
                    return CustomInkwell(
                      text: options[index],
                      isSelected: selectedIndex == index,
                       onTap: () { setState(() {
                         selectedIndex = index;
                       });  },
                    );
                  }),

                  SizedBox(
                    height: 80,
                  ),
                  buildNextButton(context),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Center buildNextButton(BuildContext context) {
    return Center(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>  HealtIssuesInputScreen(),
                        ),
                      );
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
                  ),
                );
  }
}
