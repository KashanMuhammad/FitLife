import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
  bool isLoading=true;
  @override
  void initState(){
    super.initState();
    fetchUserData();
  }
  Future<void> fetchUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    print("Fetching user data for UID: $uid");
    if (uid != null) {
      final docSnapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data()!;
        print("User data fetched: $data");
        setState(() {
          usernameController.text = data['username'] ?? '';
          emailController.text = data['email'] ?? '';
          genderController.text = data['gender'] ?? '';
          dateofbirthController.text = data['dateOfBirth'] != null
              ? DateTime.parse(data['dateOfBirth']).toLocal().toString().split(' ')[0]
              : '';
          currentWeightController.text = data['weight']?.toString() ?? '';
          goalWeightController.text = data['goalWeight']?.toString() ?? '';
          heightController.text = data['height']?.toString() ?? '';
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
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back_ios),
                  ),
                  SizedBox(width: 160),
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Text(
                      "Profile",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 11),
              CircleAvatar(
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
              SizedBox(height: 20),
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
                      child: BuildTextformfield(
                        controller: dateofbirthController,
                        svgIconPath: 'assets/images/Calender.svg',
                        readOnly: true,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: BuildTextformfield(
                        controller: genderController,
                        svgIconPath: 'assets/images/Gender.svg',
                        readOnly: true,
                      ),
                    ),
                  ],
                ),
              ),
             Row(
               children: [
                 Expanded(
                   child: BuildTextformfield(
                     controller: currentWeightController,
                     svgIconPath: 'assets/images/Weight.svg',
                     readOnly: true,
                   ),
                 ),
                 SizedBox(width: 10,),
                 Expanded(
                   child: BuildTextformfield(
                     controller: goalWeightController,
                     svgIconPath: 'assets/images/Weight.svg',
                     readOnly: true,
                   ),
                 ),
               ],
             ),
              BuildTextformfield(
                controller: heightController,
                svgIconPath: 'assets/images/Height.svg',
                readOnly: true,
              ),
              SizedBox(
                height: 20,
              ),
              buildNextButton(context),
              SizedBox(height: 23,),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildNextButton(BuildContext context) {
  return InkWell(
    onTap: (){

    },

    child: Container(
    height: 50,
    width: 300,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      gradient: const LinearGradient(
          colors: [Color(0xFF5AFF15), Color(0xFF00B712)]),
    ),

    child: Center(
      child: Text(
        "Edit Profile",
        style: TextStyle(
            fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
      ),
    ),
  ),);
}