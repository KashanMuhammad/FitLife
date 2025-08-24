import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fitlife_app/Onboarding%20Screens/fitlife_splash_screen.dart';

import 'package:fitlife_app/add_meals_screen.dart';
import 'package:fitlife_app/login_screen.dart';
import 'package:fitlife_app/meals_history_screen.dart';



import 'package:flutter/material.dart';

import 'home_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyBNhPs9MnqFr_Ll-Uqg27_Hts01DvpOMPM",
      appId: "1:984332560461:android:7ce19e19d396bff4c01404",
      messagingSenderId: "984332560461",
      projectId: "fitlife-a042d",
      storageBucket: "fitlife-a042d.firebasestorage.app",
    ),
  );
 // await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
  runApp(
    MaterialApp(
      home:AddMealsScreen() ,
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
