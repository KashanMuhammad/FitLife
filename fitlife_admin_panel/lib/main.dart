import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: MainScreen(),
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

