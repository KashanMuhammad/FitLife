import 'package:firebase_core/firebase_core.dart';
import 'package:fitlife_admin_panel/dashboard.dart';
import 'package:flutter/material.dart';
Map<String, Map<String, dynamic>> globalFoodMap = {};
Map<String, Map<String, dynamic>> globalDietMap = {};
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: "AIzaSyATekogZr4ONXOpYn912sc5_QCEVLk10BU",
        authDomain: "fitlife-a042d.firebaseapp.com",
        projectId: "fitlife-a042d",
        storageBucket: "fitlife-a042d.firebasestorage.app",
        messagingSenderId: "984332560461",
        appId: "1:984332560461:web:9b4f49a7427c9531c01404"
    )

  );
  runApp(MaterialApp(
    home: Dashboard(),
    debugShowCheckedModeBanner: false,
  ));
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("FitLife Admin Panel",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 80,
        ),
        ),
      ),
    );
  }
}

