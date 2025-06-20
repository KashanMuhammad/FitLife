import 'package:firebase_core/firebase_core.dart';
import 'package:fitlife_app/login_screen.dart';
//import 'package:fitlife_app/home_screen.dart';
import 'package:flutter/material.dart';

kashan/admin-panel/dashboard
import 'Onboarding Screens/user_name_screen.dart';
import 'firebase_options.dart';
import 'main_screen.dart';



 main
void main() async {
  await Firebase.initializeApp(
 kashan/admin-panel/dashboard
    options: DefaultFirebaseOptions.currentPlatform,

    options: FirebaseOptions(
      apiKey: "AIzaSyBNhPs9MnqFr_Ll-Uqg27_Hts01DvpOMPM",
      appId: "1:984332560461:android:7ce19e19d396bff4c01404",
      messagingSenderId: "984332560461",
      projectId: "fitlife-a042d",
      storageBucket: "fitlife-a042d.firebasestorage.app",
    ),
   main
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
