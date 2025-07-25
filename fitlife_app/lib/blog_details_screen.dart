import 'package:fitlife_app/Model%20Classes/blog_model.dart';
import 'package:flutter/material.dart';

class BlogDetailScreen extends StatelessWidget {
  final BlogModel blog;

  const BlogDetailScreen({required this.blog});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Blog"), backgroundColor: Colors.green),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: blog.id,
                child: Material(
                  color: Colors.transparent,
                  child: Text(
                    blog.title,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: 8),
              Text(
                "${blog.author} · ${blog.date} · ${blog.views} views · ${blog.time}",
                style: TextStyle(color: Colors.grey[700]),
              ),
              SizedBox(height: 16),
              Text(
                "Unlock Your Health: Shed 10kg with a Personalized Diet Plan!\n\n" *
                    3,
                style: TextStyle(fontSize: 15, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
