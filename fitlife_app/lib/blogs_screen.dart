// blogs_screen.dart
import 'package:flutter/material.dart';


import 'Model Classes/blog_model.dart';
import 'blog_details_screen.dart';
import 'custom widgets/blog_card.dart';

class BlogsScreen extends StatelessWidget {
  const BlogsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           Row(
             children: [
               Image.asset("assets/images/Male.png"),
               SizedBox(
                 width: 200,
               ),
               Text("Blogs",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,color: Colors.black),)
             ],
           ),
            SizedBox(
              height: 62,
            ),
            Text("Success Stories", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                itemCount: blogs.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 0.8, crossAxisSpacing: 12, mainAxisSpacing: 12,
                ),
                itemBuilder: (context, index) {
                  final blog = blogs[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (_) => BlogDetailScreen(blog: blog),
                      ));
                    },
                    child: BlogCard(blog: blog),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
