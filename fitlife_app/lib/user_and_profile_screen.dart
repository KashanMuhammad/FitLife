import 'package:flutter/material.dart';
class UserAndProfileScreen extends StatefulWidget {
  const UserAndProfileScreen({super.key});

  @override
  State<UserAndProfileScreen> createState() => _UserAndProfileScreenState();
}

class _UserAndProfileScreenState extends State<UserAndProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 100,
        width: 100,
        color: Colors.red,
      ),
    );
  }
}
