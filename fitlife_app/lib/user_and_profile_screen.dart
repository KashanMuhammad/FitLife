import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UserAndProfileScreen extends StatefulWidget {
  const UserAndProfileScreen({super.key});

  @override
  State<UserAndProfileScreen> createState() => _UserAndProfileScreenState();
}

class _UserAndProfileScreenState extends State<UserAndProfileScreen> {
  final String userName = "Fawad Ali Shan";
  final String _label="Healthy";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(19.0),
                child: Text(
                  "User",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
              CircleAvatar(
                radius: 50,
                child: Image.asset(
                  'assets/images/Male.png',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(userName, style: TextStyle(fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),),
              SizedBox(
                height: 5,
              ),
              Text(_label),
              SizedBox(
                height:35,
              ),

            ],
          ),
        ),
      ),
    );
  }
}
