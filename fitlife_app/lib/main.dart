import 'package:firebase_core/firebase_core.dart';
import 'package:fitlife_app/home_screen.dart';
import 'package:fitlife_app/login_screen.dart';
import 'package:fitlife_app/progress_screen.dart';
import 'package:fitlife_app/sign_up.dart';
//import 'package:fitlife_app/home_screen.dart';
import 'package:flutter/material.dart';

import 'Onboarding Screens/user_name_screen.dart';
import 'firebase_options.dart';
import 'main_screen.dart';


void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const MaterialApp(home: LoginScreen(), debugShowCheckedModeBanner: false),
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
