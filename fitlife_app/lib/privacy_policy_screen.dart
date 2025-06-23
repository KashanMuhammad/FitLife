import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitlife_app/help_and_support_screen.dart';
import 'package:flutter/material.dart';
import 'custom widgets/custom_inkwell.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Color(0xFF363538),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    "Privacy Policy",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Color(0xFF363538),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Fitlife ("we," "our," or "us") is committed to protecting your privacy. This Privacy Policy explains how your personal information is collected, used, and disclosed by Fitlife. By using our app, you agree to the collection and use of information in accordance with this policy.',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.7,
                  color: Color(0xFF363538),
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 24),
              const Text(
                '1. Information We Collect',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF363538),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'We may collect different types of personal data from you, including:\n\n'
                '• Personal Information: Name, email address, age, gender, height, weight, and dietary preferences.\n'
                '• Health Information: Medical conditions, allergies, fitness goals, and other health-related data.\n'
                '• Usage Data: How you interact with the app, including features used, time spent on the app, and crash reports.',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.7,
                  color: Color(0xFF363538),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                '2. How We Use Your Information',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF363538),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'We use the collected data to:\n'
                '• Personalize your diet plan recommendations.\n'
                '• Improve app performance and user experience.\n'
                '• Send you notifications about your diet plan, updates, or motivational messages.\n'
                '• Monitor usage, detect issues, and ensure the security of our app.\n'
                '• Comply with any legal obligations.',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.7,
                  color: Color(0xFF363538),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                '3. Sharing Your Information',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF363538),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'We do not share your personal information with third parties, except in the following circumstances:',
              ),
              Text(
                '• With Healthcare Providers: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                ' If you consent, we may share your diet-related data with a healthcare provider, such as a dietitian.',
              ),
              Text(
                '• Service Providers:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                ' We may share your information with trusted third-party service providers (e.g., cloud storage or analytics) to assist in operating the app.',
              ),
              Text(
                '• Legal Requirements:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                ' We may disclose your information to comply with applicable laws, regulations, or legal processes.',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.7,
                  color: Color(0xFF363538),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                '4. Data Security',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF363538),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                ' We take reasonable precautions to protect your personal data. However, no method of transmission over the internet is 100% secure. While we strive to protect your personal information, we cannot guarantee its absolute security.',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.7,
                  color: Color(0xFF363538),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                '5. Your Rights',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF363538),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'You have the following rights concerning your data:\n\n'
                '• Access: You can request access to your personal information.\n'
                '• Update: You can update or correct your personal data.\n'
                '• Delete: You can request the deletion of your data, subject to certain legal obligations.',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.7,
                  color: Color(0xFF363538),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                '6. Children Privacy',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF363538),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Our app is not intended for use by children under 13 years of age. If we discover that a child under 13 has provided us with personal data, we will delete such information from our systems.',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.7,
                  color: Color(0xFF363538),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                '7. Changes to This Privacy Policy',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF363538),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'We may update this Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page and updating the "Last updated" date.',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.7,
                  color: Color(0xFF363538),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Checkbox(
                    value: _isChecked,
                    onChanged: (value) {
                      setState(() {
                        _isChecked = value!;
                      });
                    },
                    activeColor: const Color(0xFF363538),
                  ),
                  const Expanded(
                    child: Text(
                      'I accept the Privacy Policy',
                      style: TextStyle(fontSize: 14, color: Color(0xFF363538)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Center(
                child: CustomInkwell(
                  text: "Accept",
                  isSelected: _isChecked,
                  onTap: () async {
                    final userId = FirebaseAuth.instance.currentUser?.uid;
                    if (userId != null) {
                      await FirebaseFirestore.instance
                          .collection('Users')
                          .doc(userId)
                          .set({
                            'privacyPolicyAccepted': true,
                          }, SetOptions(merge: true));
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HelpAndSupportScreen(),
                        ),
                      );
                    }
                    ;
                  },
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
