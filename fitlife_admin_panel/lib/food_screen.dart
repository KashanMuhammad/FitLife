import 'dart:io';
import 'package:fitlife_admin_panel/custom_widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FoodScreen extends StatefulWidget {
  const FoodScreen({super.key});

  @override
  State<FoodScreen> createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {
  String dropdownValue = "grams";
  TextEditingController foodName = TextEditingController();
  TextEditingController foodDescription = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController caloriesPerServing = TextEditingController();
  TextEditingController proteinController = TextEditingController();
  TextEditingController carbohydratesController = TextEditingController();
  TextEditingController fatsController = TextEditingController();
  TextEditingController tagController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  List<String> quantityOptions = ['grams', 'pieces', 'cups'];
  List<String> tagsOptions = ['Vegan', 'Low Carb', 'High Fiber'];
  String? selectedQuantity, selectedTag;
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
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                SizedBox(height: 30),
                CustomTextFormField(
                  controller: foodName,
                  label: "Food Name",
                  hint: "Enter Food Name",
                ),
                SizedBox(height: 15),
                CustomTextFormField(
                  controller: foodDescription,
                  label: "Food Description",
                  hint: "Enter Food Description",
                  maxLines: 3,
                ),
                SizedBox(height: 15),
                CustomTextFormField(
                  controller: quantityController,
                  label: "Quantity",
                  hint: "Enter Quantity",
                ),
                SizedBox(height: 15),
                CustomDropdown(
                  items: quantityOptions,
                  hintText: "Select Units",
                  onChanged: (value) {
                    setState(() {
                      selectedQuantity = value;
                    });
                  },
                ),
                SizedBox(height: 15),
                CustomTextFormField(
                  controller: caloriesPerServing,
                  label: "Calories Per Serving",
                ),
                SizedBox(height: 15),
                CustomTextFormField(
                  controller: proteinController,
                  label: "Protein (grams)",
                ),
                SizedBox(height: 15),
                CustomTextFormField(
                  controller: caloriesPerServing,
                  label: "Carbohydrates (grams)",
                ),
                SizedBox(height: 15),
                CustomTextFormField(
                  controller: fatsController,
                  label: "Fats (grams)",
                ),
                SizedBox(height: 15),
                CustomDropdown(
                  items: tagsOptions,
                  hintText: "Select Tag",
                  onChanged: (value) {
                    setState(() {
                      selectedTag = value;
                    });
                  },
                ),
                SizedBox(height: 15),
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
                SizedBox(height: 15),
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
