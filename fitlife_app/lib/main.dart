import 'package:firebase_core/firebase_core.dart';
import 'package:fitlife_app/Onboarding%20Screens/fitlife_splash_screen.dart';
import 'package:fitlife_app/blogs_screen.dart';

import 'package:fitlife_app/create_new_password_screen.dart';
import 'package:fitlife_app/forgot_password_screen.dart';
import 'package:fitlife_app/login_screen.dart';
import 'package:fitlife_app/main_screen.dart';
import 'package:fitlife_app/privacy_policy_screen.dart';
import 'package:fitlife_app/sign_up.dart';
import 'package:fitlife_app/user_and_profile_screen.dart';
import 'package:flutter/material.dart';

import 'Onboarding Screens/SkipScreens.dart';

void main() async {
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyBNhPs9MnqFr_Ll-Uqg27_Hts01DvpOMPM",
      appId: "1:984332560461:android:7ce19e19d396bff4c01404",
      messagingSenderId: "984332560461",
      projectId: "fitlife-a042d",
      storageBucket: "fitlife-a042d.firebasestorage.app",
    ),
  );

  runApp(
    const MaterialApp(
      home: MainScreen(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "FitLife App",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 150),
        ),
      ),
    );
  }
}
