import 'package:fitlife_app/Onboarding%20Screens/height_input_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GenderScreen extends StatefulWidget {
  const GenderScreen({super.key});

  @override
  State<GenderScreen> createState() => _GenderScreenState();
}

class _GenderScreenState extends State<GenderScreen> {
  String? selectedGender;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

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
                              text: '2',
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
                            text: "What's Your ",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          TextSpan(
                            text: 'Gender?',
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
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GenderOption(
                        assetName: 'assets/images/males.svg',
                        label: "Male",
                        isSelected: selectedGender == "Male",
                        onTap: () {
                          setState(() {
                            selectedGender = "Male";
                          });
                        },
                      ),
                      GenderOption(
                        assetName: 'assets/images/Female.svg',
                        label: "Female",
                        isSelected: selectedGender == "Female",
                        onTap: () {
                          setState(() {
                            selectedGender = "Female";
                          });
                        },
                      ),
                    ],
                  ),
                  const Spacer(),
                  Center(
                    child: InkWell(
                      onTap: () {

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HeightInputScreen(),
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
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GenderOption extends StatelessWidget {
  final String assetName;
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;

  const GenderOption({
    required this.assetName,
    required this.label,
    this.isSelected = false,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = isSelected ? Colors.green : Colors.transparent;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: isSelected ? Colors.green.withOpacity(0.3) : Colors.green.withOpacity(0.2),
            child: SvgPicture.asset(
              assetName,
              width: 30,
              height: 30,
              color: isSelected ? Colors.green[800] : null,
            ),
          ),
          const SizedBox(height: 8),
          Text(label),
          if (isSelected)
            Container(
              margin: const EdgeInsets.only(top: 4),
              height: 2,
              width: 40,
              color: Colors.green,
            ),
        ],
      ),
    );
  }
}
