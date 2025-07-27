import 'package:fitlife_app/custom%20widgets/option_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UserAndProfileScreen extends StatefulWidget {
  const UserAndProfileScreen({super.key});

  @override
  State<UserAndProfileScreen> createState() => _UserAndProfileScreenState();
}

class _UserAndProfileScreenState extends State<UserAndProfileScreen> {
  final String userName = "Fawad Ali Shan";
  final String _label = "Healthy";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
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
                Row(
                  children: [
                    Expanded(
                      child: OptionCard(
                        title: "Subscription",
                        imageAssetPath: 'assets/images/Subscription.png',
                        onTap: () {},
                        backgroundColor: Color(0xFFFFF9E5),
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: OptionCard(
                        title: "Profile",
                        imageAssetPath: 'assets/images/Group.png',
                        onTap: () {},
                        backgroundColor: Color(0xFFEAFBEA),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: OptionCard(
                        title: "Settings",
                        imageAssetPath: 'assets/images/Setting.png',
                        onTap: () {},
                        backgroundColor: Color(0xFFE9F0F9),
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: OptionCard(
                        title: "Privacy Policy",
                        imageAssetPath:
                            'assets/images/PrivacyPolicy.png',
                        onTap: () {},
                        backgroundColor: Color(0xFFE6FAFA),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: OptionCard(
                        title: "Help",
                        imageAssetPath: 'assets/images/Help.png',
                        onTap: () {},
                        backgroundColor: Color(0xFFE4F0FF),
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: OptionCard(
                        title: "Privacy Policy",
                        imageAssetPath:
                            'assets/images/PrivacyPolicy.png',
                        onTap: () {},
                        backgroundColor: Color(0xFFE6FAFA),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 35),
                InkWell(
                  onTap: (){},
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
                          Text("Log out  ",),
                          SvgPicture.asset('assets/images/icon.svg',),
                        ],
                      ),

                  ),
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
