// blog_card.dart
import 'package:fitlife_app/Model%20Classes/blog_model.dart';
import 'package:flutter/material.dart';


class BlogCard extends StatelessWidget {
  final BlogModel blog;
  const BlogCard({required this.blog});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
            tag: blog.id,
            child: Material(
              color: Colors.transparent,
              child: Text(
                blog.title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
          SizedBox(height: 8),
          Text(blog.author, style: TextStyle(color: Colors.grey[700])),
          Text(blog.date, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${blog.views} Views', style: TextStyle(fontSize: 12)),
              Icon(Icons.verified, color: Colors.green, size: 18),
            ],
          )
        ],
      ),
    );
  }
}

