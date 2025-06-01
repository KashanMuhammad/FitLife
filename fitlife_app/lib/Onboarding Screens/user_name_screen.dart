import 'package:flutter/material.dart';

import 'gender_screen.dart';

class UserNameScreen extends StatefulWidget {
  const UserNameScreen({super.key});

  @override
  State<UserNameScreen> createState() => _UserNameScreenState();
}

class _UserNameScreenState extends State<UserNameScreen> {
  TextEditingController userNameController = TextEditingController();

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
                              text: '1',
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
                            text: 'Name?',
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 60),
                    child: TextFormField(
                      controller: userNameController,
                      decoration: InputDecoration(
                        hintText: "User Name",
                        suffixIcon: const Icon(
                          Icons.person_outline,
                          color: Colors.green,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                          const BorderSide(width: 1, color: Colors.green),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                          const BorderSide(width: 2, color: Colors.green),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                          const BorderSide(width: 1, color: Colors.green),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Center(
                    child: InkWell(
                      onTap: () {

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const GenderScreen(),
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
