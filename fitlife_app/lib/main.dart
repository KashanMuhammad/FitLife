import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fitlife_app/Onboarding%20Screens/fitlife_splash_screen.dart';



import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
  // 2️⃣ Initialize Supabase
  await Supabase.initialize(
    url: "https://pmapautgzuzzdkrjjxzk.supabase.co",
    // 🔸 from your Supabase dashboard
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBtYXBhdXRnenV6emRrcmpqeHprIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTgyMDAxMDcsImV4cCI6MjA3Mzc3NjEwN30.hmp9X9LWqsyeeFZeN8RpvBCmyc8ZsSZL_WHDctq6hr0", // 🔸 from Supabase → Settings → API
  );

  runApp(
    MaterialApp(home: FitlifeSplashScreen(), debugShowCheckedModeBanner: false),
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
