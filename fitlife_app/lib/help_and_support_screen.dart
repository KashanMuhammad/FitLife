import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitlife_app/custom%20widgets/custom_inkwell.dart';
import 'package:fitlife_app/custom%20widgets/custom_textformfield.dart';
import 'package:flutter/material.dart';

class HelpAndSupportScreen extends StatefulWidget {
  const HelpAndSupportScreen({super.key});

  @override
  State<HelpAndSupportScreen> createState() => _HelpAndSupportScreenState();
}

class _HelpAndSupportScreenState extends State<HelpAndSupportScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
          child: Form(
            key: _formKey,
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
                      "Help & Support",
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
                  'Welcome to Fitlife Help & Support. Here you’ll find answers to frequently asked questions and get assistance on how to use our app effectively.',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.7,
                    color: Color(0xFF363538),
                  ),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Frequently Asked Questions (FAQs)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'How do I update my profile information?', style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black,),),
                Text(
                  '• Go to the "Profile" section. Tap "Edit" to update your personal details like name, email, age, weight, or dietary preferences.',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.7,
                    color: Colors.black,
                  ),
                ),
                Text('How do I get a personalized diet plan?',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black,)),
                Text(
                  '• After setting up your profile with your dietary preferences, health conditions, and fitness goals, the app will automatically generate a personalized diet plan for you.',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.7,
                    color: Colors.black,
                  ),
                ),
                Text('What do I do if I forgot my password?',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black,)),
                Text(
                  '• Tap "Forgot Password" on the login screen and follow the instructions to reset your password via email.',
                  style: TextStyle(
                      fontSize: 14,
                      height: 1.7,
                      color: Colors.black,
                  ),
                ),
                Text('How do I track my progress?',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black,)),
                Text(
                  '• Visit the "Progress" tab to view your weekly or monthly results. You can monitor your diet plan adherence, weight changes, and other metrics.',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.7,
                    color: Colors.black,
                  ),
                ),
                Text('Can I cancel my subscription?',style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black,),),
                Text(
                  '• Yes, you can cancel anytime. Go to the "Subscriptions" section, tap "Manage Subscription", and follow the instructions to cancel.',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.7,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 30),
                CustomTextFormField(
                  hintText: "Email",
                  controller: emailController,
                  suffixSvgAsset: "assets/images/mail.svg",
                  validator: (value) {
                    if (value == null || value
                        .trim()
                        .isEmpty) {
                      return 'Email is required';
                    }
                    if (!RegExp(
                      r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$",
                    ).hasMatch(value)) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: descriptionController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Description',
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value
                        .trim()
                        .isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                Center(
                  child: CustomInkwell(
                    text: "Submit",
                    isSelected: true,
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        final String email = emailController.text.trim();
                        final String description =
                        descriptionController.text.trim();
                        final userId = FirebaseAuth.instance.currentUser?.uid;

                        if (userId != null) {
                          await FirebaseFirestore.instance
                              .collection('Users')
                              .doc(userId)
                              .set({
                            'supportEmail': email,
                            'supportDescription': description,
                            'supportTimestamp':
                            FieldValue.serverTimestamp(),
                          }, SetOptions(merge: true));

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Support request submitted successfully',
                              ),
                            ),
                          );
                        }
                      }
                    },
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
