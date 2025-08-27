import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared/user_0nboarding_data_model_class.dart';

class BlogFormScreen extends StatefulWidget {
  final String? blogId;
  final Map<String, dynamic>? blogData;

  const BlogFormScreen({super.key, this.blogData, this.blogId});

  @override
  State<BlogFormScreen> createState() => _BlogFormScreenState();
}

class _BlogFormScreenState extends State<BlogFormScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController blogTitleController = TextEditingController();
  TextEditingController blogShortDescriptionController = TextEditingController();
  TextEditingController blogFullContentController = TextEditingController();
  TextEditingController blogAuthorNameController = TextEditingController();
  XFile? _image;
  String? category;

  final List<String> categories = [
    "Fitness Tips",
    "Nutrition",
    "Workout",
    "Mindfulness",
    "Wellness",
  ];

  @override
  void initState() {
    super.initState();
    if (widget.blogData != null) {
      blogTitleController.text = widget.blogData!['blogTitle'] ?? '';
      blogShortDescriptionController.text =
          widget.blogData!['blogShortDescription'] ?? '';
      blogFullContentController.text =
          widget.blogData!['blogFullContent'] ?? '';
      blogAuthorNameController.text =
          widget.blogData!['blogAuthorName'] ?? '';
      category = widget.blogData!['blogCategory'];
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create Blog")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Title
              TextFormField(
                controller: blogTitleController,
                decoration: InputDecoration(labelText: 'Blog Title'),
                validator: (value) =>
                value!.isEmpty ? 'Enter a blog title' : null,
              ),
              SizedBox(height: 12),

              // Short description
              TextFormField(
                controller: blogShortDescriptionController,
                decoration: InputDecoration(labelText: 'Short Description'),
              ),
              SizedBox(height: 12),

              // Content
              TextFormField(
                controller: blogFullContentController,
                decoration: InputDecoration(labelText: 'Full Content'),
                maxLines: 5,
              ),
              SizedBox(height: 12),

              // Author
              TextFormField(
                controller: blogAuthorNameController,
                decoration: InputDecoration(labelText: 'Author Name'),
              ),
              SizedBox(height: 12),

              // Category
              DropdownButtonFormField<String>(
                value: category,
                decoration: InputDecoration(labelText: 'Category'),
                items: categories
                    .map((cat) =>
                    DropdownMenuItem(value: cat, child: Text(cat)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    category = value;
                  });
                },
                validator: (value) =>
                value == null ? 'Please select a category' : null,
              ),
              SizedBox(height: 12),

              // Image picker
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: Text('Pick Image'),
                  ),
                  SizedBox(width: 20),
                  if (_image != null)
                    kIsWeb
                        ? Image.network(_image!.path,
                        height: 150, width: 150, fit: BoxFit.cover)
                        : Image.file(File(_image!.path),
                        height: 150, width: 150, fit: BoxFit.cover),
                ],
              ),

              SizedBox(height: 20),

              ElevatedButton(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;

                  final blog = FirebaseDataModelClass(
                    blogTitle: blogTitleController.text,
                    blogShortDescription: blogShortDescriptionController.text,
                    blogFullContent: blogFullContentController.text,
                    blogAuthorName: blogAuthorNameController.text,
                    blogCategory: category,
                  );

                  final blogData = blog.toJson();

                  if (widget.blogId == null) {
                    // Create new blog
                    await FirebaseFirestore.instance
                        .collection('blogs')
                        .add(blogData);
                  } else {
                    // Update existing blog
                    await FirebaseFirestore.instance
                        .collection('blogs')
                        .doc(widget.blogId)
                        .update(blogData);
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Blog Saved Successfully")),
                  );

                  // Navigator.pop(context);
                },
                child: Text(widget.blogId == null ? "ADD BLOG" : "UPDATE BLOG"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
