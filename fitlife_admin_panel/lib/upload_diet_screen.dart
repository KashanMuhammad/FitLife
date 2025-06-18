import 'dart:io';
import 'package:fitlife_admin_panel/custom_widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'main.dart';

class UploadDietScreen extends StatefulWidget {
  final Map<String, dynamic>? dietData;
  const UploadDietScreen({super.key , this.dietData});

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
  TextEditingController diettitleController = TextEditingController();
  TextEditingController dietDescription = TextEditingController();
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
  void initState(){
    super.initState();
    if (widget.dietData != null) {
      final data = widget.dietData!;
      diettitleController.text = data['dietTitle'] ?? '';
      dietDescription.text = data['dietDescription'] ?? '';
      selectedMealType = data['mealType'] ?? '';
      dayController.text = data['day'] ?? '';
      timeController.text = data['timeToEat'] ?? '';
      selectedFood = data['foodList'] ?? '';
      durationController.text = data['duration'] ?? '';
      selectedMealSuitability = data['mealSuitability'] ?? '';
      selectedMealTags = data['mealTag'] ?? '';
      if (data['image'] != null && data['image'] != '') {
        _image = XFile(data['image']);
      };
      nameController.text = data['createdBy'] ?? '';
      timeStampController.text = data['createdTime'] ?? '';
      if (mealType.contains(data['mealType'])) {
        selectedMealType = data['mealType'];
      }
      if (mealSuitability.contains(data['mealSuitability'])) {
        selectedMealSuitability = data['mealSuitability'];
      }
      if (mealTags.contains(data['mealTag'])) {
        selectedMealTags = data['mealTag'];
      }

    }
  }
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    
                  ],
                ),
                // SizedBox(height: 8),
                CustomTextFormField(
                  controller: diettitleController,
                  label: "Title",
                ),

                CustomTextFormField(
                  controller: dietDescription,
                  label: "Description",
                ),

                CustomDropdown(
                  items: mealType,
                  hintText: 'Select Meal Type',
                  value: selectedMealType,
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
                  items: globalFoodMap.values
                      .map<String>((food) => food['foodName'].toString())
                      .toList(),
                  hintText: 'List of Foods',
                  value: selectedFood,
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
                  value: selectedMealSuitability,
                  onChanged: (value) {
                    setState(() {
                      selectedMealSuitability = value;
                    });
                  },
                ),

                CustomDropdown(
                  items: mealTags,
                  hintText: 'Tags',
                  value: selectedMealTags,
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
                  child: buildCustomElevatedButton(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ElevatedButton buildCustomElevatedButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: () {
        if (diettitleController.text.trim().isEmpty) {
          return;
        }

        String id = DateTime.now().millisecondsSinceEpoch.toString();

        Map<String, dynamic> dietData = {
          'dietTitle': diettitleController.text.trim(),
          'dietDescription': dietDescription.text.trim(),
          'mealType': selectedMealType ?? '',
          'day': dayController.text.trim(),
          'timeToEat': timeController.text.trim(),
          'foodList': selectedFood ?? '',
          'duration': durationController.text.trim(),
          'mealSuitability': selectedMealSuitability ?? '',
          'mealTag': selectedMealTags ?? '',
          'image': _image?.path ?? '',
          'createdBy': nameController.text.trim(),
          'createdTime': timeStampController.text.trim(),
        };

        setState(() {
          globalDietMap[id] = dietData;
        });

        // Clearing controllers
        diettitleController.clear();
        dayController.clear();
        timeController.clear();
        durationController.clear();
        nameController.clear();
        timeStampController.clear();

        // Reset dropdown selections here
        selectedMealType = null;
        selectedFood = null;
        selectedMealSuitability = null;
        selectedMealTags = null;

        _image = null;

        setState(() {});

      },
      child: Text("Submit"),
    );
  }
}




