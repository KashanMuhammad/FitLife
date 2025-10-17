import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared/user_0nboarding_data_model_class.dart';

class BlogCard extends StatelessWidget {
  final FirebaseDataModelClass blog;

  const BlogCard({required this.blog, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
            tag: blog.blogTitle ?? '',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: blog.blogImageUrl != null && blog.blogImageUrl!.isNotEmpty
                  ? Image.network(
                blog.blogImageUrl!,
                width: double.infinity,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Image.asset(
                  'assets/images/default_blog.png',
                  width: double.infinity,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              )
                  : Image.asset(
                'assets/images/default_blog.png',
                width: double.infinity,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  blog.blogTitle ?? 'Untitled Blog',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
              const Text(
                "3 min",
                style: TextStyle(color: Colors.black38, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      blog.blogAuthorName ?? 'Unknown Author',
                      style: const TextStyle(color: Colors.black87, fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      blog.blogCategory ?? 'General',
                      style: const TextStyle(color: Colors.black38, fontSize: 10),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '${blog.createdAt ?? ''}',
                style: const TextStyle(fontSize: 10),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(width: 4),
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
