import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitlife_admin_panel/custom_widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared/user_0nboarding_data_model_class.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dashboard.dart';

class UploadFoodScreen extends StatefulWidget {
  final Map<String, dynamic>? foodData;

  const UploadFoodScreen({super.key, this.foodData});

  @override
  State<UploadFoodScreen> createState() => _FoodScreenState();
}

class _FoodScreenState extends State<UploadFoodScreen> {
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
  String? selectedUnit, selectedTag;
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
  void initState() {
    super.initState();
    if (widget.foodData != null) {
      final data = widget.foodData!;
      foodName.text = data['foodName'] ?? '';
      foodDescription.text = data['foodDescription'] ?? '';
      quantityController.text = data['quantity'] ?? '';
      selectedUnit = data['unit'];
      caloriesPerServing.text = data['calories'] ?? '';
      proteinController.text = data['protein'] ?? '';
      carbohydratesController.text = data['carbohydrates'] ?? '';
      fatsController.text = data['fats'] ?? '';
      selectedTag = data['tag'];
      if (data['image'] != null && data['image'] != '') {
        _image = XFile(data['image']);
      }
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

              spacing: 15,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Dashboard()),
                        );
                      },
                      icon: Icon(Icons.arrow_back_rounded),
                    ),
                  ],
                ),

                CustomTextFormField(controller: foodName, label: "Food Name"),
                // SizedBox(height: 15),
                CustomTextFormField(
                  controller: foodDescription,
                  label: "Food Description",
                  maxLines: 3,
                ),
                // SizedBox(height: 15),
                CustomTextFormField(
                  controller: quantityController,
                  label: "Quantity",
                ),
                // SizedBox(height: 15),
                CustomDropdown(
                  items: quantityOptions,
                  hintText: "Select Units",
                  value: selectedUnit,
                  onChanged: (value) {
                    setState(() {
                      selectedUnit = value;
                    });
                  },
                ),
                // SizedBox(height: 15),
                CustomTextFormField(
                  controller: caloriesPerServing,
                  label: "Calories Per Serving",
                ),
                // SizedBox(height: 15),
                CustomTextFormField(
                  controller: proteinController,
                  label: "Protein (grams)",
                ),
                // SizedBox(height: 15),
                CustomTextFormField(
                  controller: carbohydratesController,
                  label: "Carbohydrates (grams)",
                ),
                // SizedBox(height: 15),
                CustomTextFormField(
                  controller: fatsController,
                  label: "Fats (grams)",
                ),
                // SizedBox(height: 15),
                CustomDropdown(
                  items: tagsOptions,
                  hintText: "Select Tag",
                  value: selectedTag,
                  onChanged: (value) {
                    setState(() {
                      selectedTag = value;
                    });
                  },
                ),
                // SizedBox(height: 15),
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
                // SizedBox(height: 15),

                // SizedBox(height: 15),
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

  // ElevatedButton buildCustomElevatedButton() {
  //   return ElevatedButton(
  //     style: ElevatedButton.styleFrom(
  //       backgroundColor: Colors.transparent,
  //       shadowColor: Colors.transparent,
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  //     ),
  //     onPressed: () {
  //       // if (foodName.text.trim().isEmpty) {
  //       //   return;
  //       // }
  //       //
  //       // String id = DateTime.now().millisecondsSinceEpoch.toString();
  //       //
  //       // Map<String, dynamic> foodData = {
  //       //   'foodName': foodName.text.trim(),
  //       //   'foodDescription': foodDescription.text.trim(),
  //       //   'quantity': quantityController.text.trim(),
  //       //   'unit': selectedUnit ?? '',
  //       //   'calories': caloriesPerServing.text.trim(),
  //       //   'protein': proteinController.text.trim(),
  //       //   'carbohydrates': carbohydratesController.text.trim(),
  //       //   'fats': fatsController.text.trim(),
  //       //   'tag': selectedTag ?? '',
  //       //   'image': _image?.path ?? '',
  //       // };
  //       //
  //       // setState(() {
  //       //   globalFoodMap[id] = foodData;
  //       // });
  //       //
  //       // foodName.clear();
  //       // foodDescription.clear();
  //       // quantityController.clear();
  //       // caloriesPerServing.clear();
  //       // proteinController.clear();
  //       // carbohydratesController.clear();
  //       // fatsController.clear();
  //       // selectedUnit = null;
  //       // selectedTag = null;
  //       // _image = null;
  //
  //       final user = FirebaseDataModelClass(
  //         foodName: foodName.text,
  //         foodDescription: foodDescription.text,
  //         quantity: quantityController.text,
  //         caloriesPerServing: caloriesPerServing.text,
  //         protein: proteinController.text,
  //         carbohydrates: carbohydratesController.text,
  //         fats: fatsController.text,
  //         selectedTag: selectedTag,
  //         selectedUnits: selectedUnit,
  //       );
  //
  //     FirebaseFirestore.instance.collection('food').doc().set(user.toJson());
  //
  //     },
  //     child: Text("ADD FOOD"),
  //   );
  // }


  // ElevatedButton buildCustomElevatedButton() {
  //   return ElevatedButton(
  //     style: ElevatedButton.styleFrom(
  //       backgroundColor: Colors.transparent,
  //       shadowColor: Colors.transparent,
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  //     ),
  //     onPressed: () {
  //       final user = FirebaseDataModelClass(
  //         foodName: foodName.text.trim(),
  //         foodDescription: foodDescription.text.trim(),
  //         quantity: quantityController.text.trim(),
  //         caloriesPerServing: caloriesPerServing.text.trim(),
  //         protein: proteinController.text.trim(),
  //         carbohydrates: carbohydratesController.text.trim(),
  //         fats: fatsController.text.trim(),
  //         selectedTag: selectedTag,
  //         selectedUnits: selectedUnit,
  //         // 🔹 add image later once you connect Supabase
  //       );
  //
  //       // Convert to JSON
  //       final foodData = user.toJson();
  //
  //       // 🔹 Remove null or empty values
  //       foodData.removeWhere((key, value) => value == null || value == "");
  //
  //       FirebaseFirestore.instance.collection('food').doc().set(foodData);
  //
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text("Food uploaded ✅")),
  //       );
  //
  //       // 🔹 Clear fields after upload
  //       foodName.clear();
  //       foodDescription.clear();
  //       quantityController.clear();
  //       caloriesPerServing.clear();
  //       proteinController.clear();
  //       carbohydratesController.clear();
  //       fatsController.clear();
  //       selectedUnit = null;
  //       selectedTag = null;
  //       _image = null;
  //       setState(() {});
  //     },
  //     child: const Text("ADD FOOD"),
  //   );
  // }

  ElevatedButton buildCustomElevatedButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: () async {
        // 🔹 Step 1: Upload image to Supabase (if picked)
        String? imageUrl;
        if (_image != null) {
          try {
            final fileBytes = await _image!.readAsBytes();
            final fileName =
                "food_${DateTime.now().millisecondsSinceEpoch}_${_image!.name}";

            // upload to Supabase storage (bucket: food_images)
            final response = await Supabase.instance.client.storage
                .from('food_images')
                .uploadBinary(fileName, fileBytes);

            if (response.isEmpty) {
              throw Exception("Upload failed");
            }

            // ✅ Get public URL of uploaded image
            imageUrl = Supabase.instance.client.storage
                .from('food_images')
                .getPublicUrl(fileName);

          } catch (e) {
            print("❌ Supabase upload failed: $e");
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Image upload failed ❌")),
            );
            return; // stop if upload fails
          }
        }

        // 🔹 Step 2: Create Firestore model including imageUrl
        final user = FirebaseDataModelClass(
          foodName: foodName.text.trim(),
          foodDescription: foodDescription.text.trim(),
          quantity: quantityController.text.trim(),
          caloriesPerServing: caloriesPerServing.text.trim(),
          protein: proteinController.text.trim(),
          carbohydrates: carbohydratesController.text.trim(),
          fats: fatsController.text.trim(),
          selectedTag: selectedTag,
          selectedUnits: selectedUnit,
          foodImageUrl: imageUrl, // ✅ Add Supabase image URL here
        );

        // Convert to JSON
        final foodData = user.toJson();

        // 🔹 Remove null or empty values
        foodData.removeWhere((key, value) => value == null || value == "");

        // Save in Firestore (food collection)
        await FirebaseFirestore.instance.collection('food').doc().set(foodData);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Food uploaded ✅")),
        );

        // 🔹 Clear fields after upload
        foodName.clear();
        foodDescription.clear();
        quantityController.clear();
        caloriesPerServing.clear();
        proteinController.clear();
        carbohydratesController.clear();
        fatsController.clear();
        selectedUnit = null;
        selectedTag = null;
        _image = null;

        setState(() {});
      },
      child: const Text("ADD FOOD"),
    );
  }



}
