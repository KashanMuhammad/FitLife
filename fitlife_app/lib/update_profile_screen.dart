import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'custom widgets/build_textformfield.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController dateofbirthController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController currentWeightController = TextEditingController();
  TextEditingController goalWeightController = TextEditingController();
  TextEditingController heightController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> updateUserData() async {
    if (!_formKey.currentState!.validate()) return;

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final dataToUpdate = <String, dynamic>{};

      if (usernameController.text.trim().isNotEmpty) {
        dataToUpdate['username'] = usernameController.text.trim();
      }
      if (emailController.text.trim().isNotEmpty) {
        dataToUpdate['email'] = emailController.text.trim();
      }
      if (genderController.text.trim().isNotEmpty) {
        dataToUpdate['gender'] = genderController.text.trim();
      }
      if (dateofbirthController.text.trim().isNotEmpty) {
        dataToUpdate['dateOfBirth'] = dateofbirthController.text.trim();
      }
      if (currentWeightController.text.trim().isNotEmpty) {
        dataToUpdate['weight'] =
            double.tryParse(currentWeightController.text.trim()) ?? 0.0;
      }
      if (goalWeightController.text.trim().isNotEmpty) {
        dataToUpdate['goalWeight'] =
            double.tryParse(goalWeightController.text.trim()) ?? 0.0;
      }
      if (heightController.text.trim().isNotEmpty) {
        dataToUpdate['height'] =
            double.tryParse(heightController.text.trim()) ?? 0.0;
      }

      if (dataToUpdate.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .update(dataToUpdate);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No changes to update')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios),
                    ),
                    const SizedBox(width: 77),
                    const Padding(
                      padding: EdgeInsets.all(25.0),
                      child: Center(
                        child: Text(
                          "Profile",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 11),
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/Male.png',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "     Full Name",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                BuildTextformfield(
                  controller: usernameController,
                  svgIconPath: 'assets/images/person.svg',
                  readOnly: false,
                  validator: usernameValidator,
                ),
                Text(
                  "     Email",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                BuildTextformfield(
                  controller: emailController,
                  svgIconPath: 'assets/images/mail.svg',
                  readOnly: false,
                  validator: emailValidator,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "      Date of Birth",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            BuildTextformfield(
                              controller: dateofbirthController,
                              svgIconPath: 'assets/images/Calender.svg',
                              readOnly: false,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "     Gender",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            BuildTextformfield(
                              controller: genderController,
                              svgIconPath: 'assets/images/Gender.svg',
                              readOnly: false,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "      Current Weight",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            BuildTextformfield(
                              controller: currentWeightController,
                              svgIconPath: 'assets/images/Weight.svg',
                              readOnly: false,
                              validator: numberValidator,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "     Goal Weight",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            BuildTextformfield(
                              controller: goalWeightController,
                              svgIconPath: 'assets/images/Weight.svg',
                              readOnly: false,
                              validator: numberValidator,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  "       Height",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                BuildTextformfield(
                  controller: heightController,
                  svgIconPath: 'assets/images/Height.svg',
                  readOnly: false,
                  validator: numberValidator,
                ),
                const SizedBox(height: 20),
                Center(child: buildUpdateButton(context)),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildUpdateButton(BuildContext context) {
    return InkWell(
      onTap: updateUserData,
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
            "Update Profile",
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
