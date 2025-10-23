import 'package:flutter/material.dart';
import 'package:shared/user_0nboarding_data_model_class.dart';


class BlogDetailScreen extends StatelessWidget {
  final FirebaseDataModelClass blog;

  const BlogDetailScreen({super.key, required this.blog});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF363538)),
                  ),
                  const Spacer(),
                  const Text(
                    "Blogs",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: 10),

              // Blog image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: blog.blogImageUrl != null && blog.blogImageUrl!.isNotEmpty
                    ? Image.network(
                  blog.blogImageUrl!,
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                )
                    : Image.asset(
                  'assets/images/blogsPicture.png',
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),

              Text(
                blog.blogTitle ?? 'Untitled Blog',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                blog.blogAuthorName ?? 'Unknown Author',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                blog.blogCategory ?? '',
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),

              Text(
                blog.blogFullContent ?? '',
                style: const TextStyle(fontSize: 15, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
