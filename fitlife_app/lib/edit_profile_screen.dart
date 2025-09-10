import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitlife_app/update_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared/user_0nboarding_data_model_class.dart';

import 'custom widgets/build_textformfield.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController dateofbirthController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController currentWeightController = TextEditingController();
  TextEditingController goalWeightController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  FirebaseDataModelClass? userModel;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    print("Fetching user data for UID: $uid");

    if (uid.isNotEmpty) {
      final docSnapshot =
          await FirebaseFirestore.instance.collection('Users').doc(uid).get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data()!;
        print("User data fetched: $data");
        userModel= FirebaseDataModelClass.fromJson(data);
        setState(() {
          usernameController.text = userModel!.username ?? '';
          emailController.text = userModel!.email ?? '';
          genderController.text = userModel!.gender ?? '';
          dateofbirthController.text =
          userModel!.dateOfBirth != null
              ? userModel!.dateOfBirth!.toIso8601String().split('T')[0]  // → 2004-07-21
              : '';
          heightController.text =
          (userModel!.height != null && userModel!.heightUnit != null)
              ? '${userModel!.height!.toStringAsFixed(0)} ${userModel!.heightUnit}'
              : '';

          currentWeightController.text =
          (userModel!.weight != null && userModel!.weightUnit != null)
              ? '${userModel!.weight!.toStringAsFixed(1)} ${userModel!.weightUnit}'
              : '';
          goalWeightController.text =
          (userModel!.weight != null && userModel!.weightUnit != null)
              ? '${userModel!.weight!.toStringAsFixed(1)} ${userModel!.weightUnit}'
              : '';

          isLoading = false;
        });
      } else {
        print("User document not found in Firestore.");
        setState(() {
          isLoading = false;
        });
      }
    } else {
      print("User is not logged in.");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : userModel == null
            ? const Center(child: Text("No user data found"))
            : SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Header
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

              // 🔹 Avatar
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

              // 🔹 Fields
              BuildTextformfield(
                controller: usernameController,
                svgIconPath: 'assets/images/person.svg',
                readOnly: true,
              ),
              BuildTextformfield(
                controller: emailController,
                svgIconPath: 'assets/images/mail.svg',
                readOnly: true,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "    Date of Birth",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          BuildTextformfield(
                            controller: dateofbirthController,
                            svgIconPath: 'assets/images/Calender.svg',
                            readOnly: true,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "     Gender",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          BuildTextformfield(
                            controller: genderController,
                            svgIconPath: 'assets/images/Gender.svg',
                            readOnly: true,
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
                          const Text(
                            "     Current Weight",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          BuildTextformfield(
                            controller: currentWeightController,
                            svgIconPath: 'assets/images/Weight.svg',
                            readOnly: true,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "     Goal Weight",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          BuildTextformfield(
                            controller: goalWeightController,
                            svgIconPath: 'assets/images/Weight.svg',
                            readOnly: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const Text(
                "      Height",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              BuildTextformfield(
                controller: heightController,
                svgIconPath: 'assets/images/Height.svg',
                readOnly: true,
              ),

              const SizedBox(height: 20),

              Center(child: buildNextButton(context)),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }


}

Widget buildNextButton(BuildContext context) {
  return InkWell(
    onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: (context)=> UpdateProfileScreen()));
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
          "Edit Profile",
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
