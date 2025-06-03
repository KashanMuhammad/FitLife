import 'dart:io';
import 'package:fitlife_admin_panel/custom_widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadDietScreen extends StatefulWidget {
  const UploadDietScreen({super.key});

  @override
  State<UploadDietScreen> createState() => _UploadDietScreenState();
}

class _UploadDietScreenState extends State<UploadDietScreen> {
  String? selectedMealType,
      selectedFood,
      selectedMealSuitability,
      selectedMealTags;
  List<String> mealType = ['BreakFast', 'Lunch', 'Dinner', 'Snack', 'Salad'];
  List<String> mealSuitability = ['Weight loss', 'Diabetes', 'PCOS'];
  List<String> mealTags = ['Low Carb', 'High Protein', 'Vegetarian'];
  final formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController foodDescription = TextEditingController();
  TextEditingController dayController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController timeStampController = TextEditingController();
  XFile? _image;

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: formKey,
            child: Column(
              spacing: 15,
              children: [
                CustomTextFormField(
                  controller: titleController,
                  label: "Title",
                ),

                CustomTextFormField(
                  controller: foodDescription,
                  label: "Description",
                ),

                CustomDropdown(
                  items: mealType,
                  hintText: 'Select Meal Type',
                  onChanged: (value) {
                    setState(() {
                      selectedMealType = value;
                    });
                  },
                ),

                CustomTextFormField(controller: dayController, label: 'Day'),

                CustomTextFormField(
                  controller: timeController,
                  label: 'Time to Eat',
                ),

                CustomDropdown(
                  items: [],
                  hintText: 'List of Foods',
                  onChanged: (value) {
                    setState(() {
                      selectedFood = value;
                    });
                  },
                ),

                CustomTextFormField(
                  controller: durationController,
                  label: 'Duration (Days)',
                ),

                CustomDropdown(
                  items: mealSuitability,
                  hintText: 'Suitable For',
                  onChanged: (value) {
                    setState(() {
                      selectedMealSuitability = value;
                    });
                  },
                ),

                CustomDropdown(
                  items: mealTags,
                  hintText: 'Tags',
                  onChanged: (value) {
                    setState(() {
                      selectedMealTags = value;
                    });
                  },
                ),

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
                              border: Border.all(color: Colors.black, width: 3),
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

                CustomTextFormField(
                  controller: nameController,
                  label: 'Created By',
                ),

                CustomTextFormField(
                  controller: timeStampController,
                  label: 'Created At',
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
                    onPressed: _pickImage,
                    child: Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
