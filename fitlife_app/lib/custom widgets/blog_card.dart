import 'package:fitlife_app/Model%20Classes/blog_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BlogCard extends StatelessWidget {
  final BlogModel blog;

  const BlogCard({required this.blog});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
            tag: blog.id,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                blog.imagePath,
                width: double.infinity,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  blog.title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 4),
              Text(
                "3 min",
                style: TextStyle(color: Colors.black38, fontSize: 12),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      blog.author,
                      style: TextStyle(color: Colors.black87, fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      blog.date,
                      style: TextStyle(color: Colors.black38, fontSize: 10),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 4),
              Text(
                '${blog.views} Views',
                style: TextStyle(fontSize: 10),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(width: 4),
              SvgPicture.asset(
                'assets/images/blogsIconsbuttun.svg',
                width: 20,
                height: 20,
                fit: BoxFit.contain,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
