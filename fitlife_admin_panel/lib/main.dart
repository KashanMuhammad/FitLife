import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'admin_provider.dart';
import 'auth_gate.dart';
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
        appId: "1:984332560461:web:9b4f49a7427c9531c01404",
    )

  );
  await Supabase.initialize(
    url: "https://pmapautgzuzzdkrjjxzk.supabase.co",       // replace with your Supabase project URL
    anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBtYXBhdXRnenV6emRrcmpqeHprIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTgyMDAxMDcsImV4cCI6MjA3Mzc3NjEwN30.hmp9X9LWqsyeeFZeN8RpvBCmyc8ZsSZL_WHDctq6hr0",                         // replace with your Supabase anon key
  );

  // runApp(MaterialApp(
  //   home: AuthGate(),
  //   debugShowCheckedModeBanner: false,
  // ));
  runApp(
    ChangeNotifierProvider(
      create: (context) => AdminProvider(),
      child: const MaterialApp(
        home: AuthGate(),
        debugShowCheckedModeBanner: false,
      ),
    ),
  );
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

