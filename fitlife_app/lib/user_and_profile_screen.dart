import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitlife_app/custom%20widgets/option_card.dart';
import 'package:fitlife_app/delete_account_setting.dart';
import 'package:fitlife_app/edit_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared/user_0nboarding_data_model_class.dart';

class UserAndProfileScreen extends StatefulWidget {
  const UserAndProfileScreen({super.key});

  @override
  State<UserAndProfileScreen> createState() => _UserAndProfileScreenState();
}

class _UserAndProfileScreenState extends State<UserAndProfileScreen> {

  final String _label = "Healthy";
  FirebaseDataModelClass? userModel;
  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser!.uid;
      if (currentUser.isNotEmpty) {
        final doc = await FirebaseFirestore.instance
            .collection('Users')
            .doc(currentUser)
            .get();
        print("Document exists: ${doc.exists}");
        print("Document data: ${doc.data()}");
        if (doc.exists) {
          setState(() {
            userModel = FirebaseDataModelClass.fromJson(doc.data()!);
          });
        }
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
final userName= userModel?.username?? "Loading___";
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(19.0),
                    child: Text(
                      "User",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ),
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
                  SizedBox(height: 10),

                  Text(
                    userName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(_label),
                  SizedBox(height: 35),

                  // 🔹 GridView for Options
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 15,
                    childAspectRatio: 1.2,
                    children: [
                      OptionCard(
                        title: "Subscription",
                        imageAssetPath: 'assets/images/Subscription.png',
                        onTap: () {},
                        backgroundColor: Color(0xFFFFF9E5),
                      ),
                      OptionCard(
                        title: "Profile",
                        imageAssetPath: 'assets/images/Group.png',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProfileScreen(),
                            ),
                          );
                        },
                        backgroundColor: Color(0xFFEAFBEA),
                      ),
                      OptionCard(
                        title: "Settings",
                        imageAssetPath: 'assets/images/Setting.png',
                        onTap: () {},
                        backgroundColor: Color(0xFFE9F0F9),
                      ),
                      OptionCard(
                        title: "Privacy Policy",
                        imageAssetPath: 'assets/images/PrivacyPolicy.png',
                        onTap: () {},
                        backgroundColor: Color(0xFFE6FAFA),
                      ),
                      OptionCard(
                        title: "Help",
                        imageAssetPath: 'assets/images/Help.png',
                        onTap: () {},
                        backgroundColor: Color(0xFFE4F0FF),
                      ),
                      OptionCard(
                        title: "Privacy Policy",
                        imageAssetPath: 'assets/images/PrivacyPolicy.png',
                        onTap: () {},
                        backgroundColor: Color(0xFFE6FAFA),
                      ),
                    ],
                  ),

                  SizedBox(height: 35),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DeleteAccountSetting(),
                        ),
                      );
                    },
                    child: Container(
                      height: 45,
                      width: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Color(0x88FF6B6B),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Log out  "),
                          SvgPicture.asset(
                            'assets/images/icon.svg',
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
