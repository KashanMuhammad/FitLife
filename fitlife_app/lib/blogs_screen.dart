import 'package:flutter/material.dart';
class BlogsScreen extends StatefulWidget {
  const BlogsScreen({super.key});

  @override
  State<BlogsScreen> createState() => _BlogsScreenState();
}

class _BlogsScreenState extends State<BlogsScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
        child: SafeArea(
        child: Padding(
        padding: const EdgeInsets.all(20),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
    CircleAvatar(
    radius: 16,
    backgroundImage: AssetImage("assets/images/Male.png"),
    ),
    SizedBox(width: 135),
    Text(
    "Blogs",
    style: TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
    ),
    ),
    ],
    ),

          ]
    ),
    ),
    ),
    )
    );
  }
}
