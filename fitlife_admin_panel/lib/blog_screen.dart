import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitlife_admin_panel/upload_blog_screen.dart';
import 'package:flutter/material.dart';

class BlogScreen extends StatefulWidget {
  final VoidCallback? onUploadPressed;

  const BlogScreen({super.key, this.onUploadPressed});

  @override
  State<BlogScreen> createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  final blogsRef = FirebaseFirestore.instance.collection('blogs');
  Map<String, dynamic>? selectedBlog; // Selected blog details

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                const Text(
                  "Blogs",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                const Spacer(),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: const [
                        Text("Cody Fisher"),
                        Text("Dashboard Manager"),
                      ],
                    ),
                    const SizedBox(width: 10),
                    const CircleAvatar(
                      radius: 24,
                      backgroundImage: AssetImage("assets/male avatar.png"),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 20),

            // Create Blog Button
            Row(
              children: [
                const Spacer(),
                Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF5AFF15), Color(0xFF00B712)],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ElevatedButton.icon(
                    onPressed: widget.onUploadPressed,
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text(
                      "Create Blog",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 20),

            // Main Area (split view)
            Expanded(
              child: FutureBuilder<QuerySnapshot>(
                future: blogsRef.get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("No blogs found."));
                  }

                  final blogs = snapshot.data!.docs;

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left: Blog Grid
                      Expanded(flex: 2, child: _buildBlogGrid(blogs)),

                      // Right: Blog Details (scrollable)
                      if (selectedBlog != null)
                        Expanded(
                          flex: 1,
                          child: _buildBlogDetails(selectedBlog!),
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Blog Grid
  Widget _buildBlogGrid(List<QueryDocumentSnapshot> blogs) {
    return GridView.builder(
      itemCount: blogs.length,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 250,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.0,
      ),
      itemBuilder: (context, index) {
        final blog = blogs[index].data() as Map<String, dynamic>;
        final blogId = blogs[index].id;

        return GestureDetector(
          onTap: () {
            setState(() {
              selectedBlog = blog;
            });
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Blog Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: blog['featureImage'] != null &&
                        blog['featureImage'].toString().isNotEmpty
                        ? Image.network(
                      blog['featureImage'],
                      height: 100,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                        : Container(
                      height: 100,
                      width: double.infinity,
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.image,
                        size: 40,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),

                  // Title + Menu
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          blog['blogTitle'] ?? 'No Title',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == "blog form") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BlogFormScreen(
                                  blogId: blogId,
                                  blogData: blog,
                                ),
                              ),
                            );
                          }
                        },
                        itemBuilder: (context) => const [
                          PopupMenuItem(
                            value: "blog form",
                            child: Text("Blog Form"),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 2),

                  Text(
                    "Category: ${blog['blogCategory'] ?? 'No Category'}",
                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 8),

                  Text(
                    "Created By: ${blog['blogAuthorName'] ?? ''}",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Blog Details (right panel)
  Widget _buildBlogDetails(Map<String, dynamic> blog) {
    return Container(
      color: Colors.grey[100],
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Close button
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    selectedBlog = null;
                  });
                },
              ),
            ),

            // Blog Image
            if (blog['featureImage'] != null &&
                blog['featureImage'].toString().isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  blog['featureImage'],
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

            const SizedBox(height: 20),

            // Title
            Text(
              blog['blogTitle'] ?? "No Title",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            // Author + Category
            Row(
              children: [
                Text(
                  "By ${blog['blogAuthorName'] ?? "Unknown"}",
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
                const SizedBox(width: 20),
                Text(
                  "Category: ${blog['blogCategory'] ?? ''}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.green,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Short Description
            const Text(
              "Blog Short Description:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 6),
            Text(
              blog['blogShortDescription'] ??
                  "No short description available",
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),

            const SizedBox(height: 25),

            // Full Content
            const Text(
              "Blog Full Content:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 6),
            SelectableText(
              blog['blogFullContent'] ?? "No content available",
              style: const TextStyle(fontSize: 16, height: 1.6),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
