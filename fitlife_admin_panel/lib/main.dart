import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: 'AIzaSyCm3joJRPYeSFqumpgAOodv5fh3UJLxXt0',
      appId: '1:172805082300:android:38ef75bed1a237cc5e14b9',
      messagingSenderId: '172805082300',
      projectId: 'fitlife-admin-panel',
      storageBucket: 'fitlife-admin-panel.firebasestorage.app',
    ),
  );
  runApp(MaterialApp(home: MainScreen(), debugShowCheckedModeBanner: false));
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
        child: Text(
          "FitLife Admin Panel",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 80),
        ),
      ),
    );
  }
}
