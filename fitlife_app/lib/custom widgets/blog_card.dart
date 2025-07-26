// blog_card.dart
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
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.asset(
                blog.imagePath,
                width: double.infinity,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 15,),
          Row(
            children: [
              Text(
                blog.title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Spacer(),
              Text("3 min",style: TextStyle(color: Colors.black26),)
            ],
          ),
          SizedBox(height: 35),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Column(children: [
              Text(blog.author, style: TextStyle(color: Colors.black87)),
              Text(
                blog.date,
                style: TextStyle(color: Colors.black38, fontSize: 12),
              ),
              ],
              ),
              Text('${blog.views} Views', style: TextStyle(fontSize: 12)),
              SvgPicture.asset('assets/images/blogsIconsbuttun.svg',),
            ],
          ),
        ],
      ),
    );
  }
}
