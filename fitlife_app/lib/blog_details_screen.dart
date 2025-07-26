// blog_detail_screen.dart
import 'package:fitlife_app/Model%20Classes/blog_model.dart';
import 'package:flutter/material.dart';


class BlogDetailScreen extends StatelessWidget {
  final BlogModel blog;
  const BlogDetailScreen({required this.blog});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(blog.title), backgroundColor: Colors.green),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(blog.title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text("${blog.author} · ${blog.date} · ${blog.views} views · ${blog.time}",
                  style: TextStyle(color: Colors.grey[700])),
              SizedBox(height: 16),
              Text(
                "Unlock Your Health: Shed 10kg with a Personalized Diet Plan!\n\n"
                    "Fitlife is committed to protecting your privacy. This Privacy Policy explains how your personal "
                    "information is collected, used, and disclosed by Fitlife. By using our app, you agree to the collection and use "
                    "of your data in accordance with this policy.\n\n" * 2,
                style: TextStyle(fontSize: 15, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
