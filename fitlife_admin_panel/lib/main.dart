import 'package:fitlife_admin_panel/dashboard.dart';
import 'package:flutter/material.dart';
Map<String, Map<String, dynamic>> globalFoodMap = {};
void main() {
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

