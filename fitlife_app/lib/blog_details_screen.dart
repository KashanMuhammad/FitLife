// blog_detail_screen.dart
import 'package:fitlife_app/Model%20Classes/blog_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BlogDetailScreen extends StatelessWidget {
  final BlogModel blog;

  const BlogDetailScreen({required this.blog});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Color(0xFF363538),
                      ),
                    ),
                    SizedBox(width: 200),
                    Text(
                      "Blogs",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 250,
                  width: MediaQuery.of(context).size.width,

                  child: Image.asset(
                    'assets/images/blogsPicture.png',
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Text(
                      blog.title,
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    Text("3 min",style: TextStyle(color: Colors.black26),),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  "${blog.author} ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  " ${blog.date} · ${blog.views} views · ${blog.time}",
                  style: TextStyle(color: Colors.grey[700]),
                ),
                SizedBox(height: 16),
                Text(
                  "Unlock Your Health: Shed 10kg with a Personalized Diet Plan!\n",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  "Fitlife is committed to protecting your privacy. This Privacy Policy explains how your personal "
                          "information is collected, used, and disclosed by Fitlife. By using our app, you agree to the collection and use "
                          "of your data in accordance with this policy.\n\n" *
                      2,
                  style: TextStyle(fontSize: 15, height: 1.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
