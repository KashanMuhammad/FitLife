import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared/user_0nboarding_data_model_class.dart';

class BlogFormScreen extends StatefulWidget {
  final Map<String, dynamic>? blogData;

  const BlogFormScreen({super.key, this.blogData});

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
                validator:
                    (value) => value!.isEmpty ? 'Enter a blog title' : null,
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

              // Category
              SizedBox(height: 12),

              // Author
              TextFormField(
                controller: blogAuthorNameController,
                decoration: InputDecoration(labelText: 'Author Name'),
              ),
              SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: category,
                decoration: InputDecoration(labelText: 'Category'),
                items:
                    categories
                        .map(
                          (cat) =>
                              DropdownMenuItem(value: cat, child: Text(cat)),
                        )
                        .toList(),
                onChanged: (value) {
                  setState(() {
                    category = value;
                  });
                },
                validator:
                    (value) =>
                        value == null ? 'Please select a category' : null,
              ),
              SizedBox(height: 12),
              // Image picker
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF5AFF15), Color(0xFF00B712)],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: _pickImage,
                      child: Text('Pick Image'),
                    ),
                  ),
                  SizedBox(width: 45),
                  if (_image != null)
                    kIsWeb
                        ? Container(
                          decoration: BoxDecoration(
                            border: Border.all(width: 3),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Image.network(
                            _image!.path,
                            height: 300,
                            width: 500,
                          ),
                        )
                        : Image.file(File(_image!.path)),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF5AFF15), Color(0xFF00B712)],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    final blog = FirebaseDataModelClass(
                      blogTitle: blogTitleController.text,
                      blogShortDescription: blogShortDescriptionController.text,
                      blogFullContent: blogFullContentController.text,
                      blogAuthorName: blogAuthorNameController.text,
                      blogCategory: category,
                    );
                    FirebaseFirestore.instance.collection('blogs').doc().set(blog.toJson());
                  },
                  child: Text("ADD BLOG"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
