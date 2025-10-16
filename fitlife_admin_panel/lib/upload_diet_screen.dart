import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitlife_admin_panel/custom_widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared/user_0nboarding_data_model_class.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dashboard.dart';


class UploadDietScreen extends StatefulWidget {
  final String? dietId;
  final Map<String, dynamic>? dietData;

  const UploadDietScreen({super.key, this.dietData, this.dietId});

  @override
  State<UploadDietScreen> createState() => _UploadDietScreenState();
}

class _UploadDietScreenState extends State<UploadDietScreen> {
  List<String> foodNames = [];
  List<Map<String, dynamic>> allFoods = [];
  List<String> selectedFoods = [];
  String? selectedMealType,
      selectedFood,
      selectedMealSuitability,
      selectedMealTags;
  List<String> mealType = ['BreakFast', 'Lunch', 'Dinner', 'Snack', 'Salad'];
  List<String> mealSuitability = ['Weight loss', 'Diabetes', 'PCOS'];
  List<String> mealTags = ['Low Carb', 'High Protein', 'Vegetarian'];
  final formKey = GlobalKey<FormState>();
  TextEditingController dietTitleController = TextEditingController();
  TextEditingController dietDescription = TextEditingController();
  TextEditingController dayController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController timeStampController = TextEditingController();
  XFile? _image;
  String? _imageUrl;

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
    loadFoodNames();

    if (widget.dietData != null) {
      final data = widget.dietData!;

      dietTitleController.text = data['dietTitle'] ?? '';
      dietDescription.text = data['dietDescription'] ?? '';
      dayController.text = data['day'] ?? '';
      timeController.text = data['timeToEat'] ?? '';
      durationController.text = data['duration'] ?? '';
      nameController.text = data['createdBy'] ?? '';
      timeStampController.text = data['createdAt'] ?? '';


      selectedMealType = data['selectedMealType'];
      selectedMealSuitability = data['suitableFor'];
      selectedMealTags = data['tag'];


      if (data['listOfFood'] != null) {
        selectedFoods = List<String>.from(data['listOfFood']);
      }


      if (data['image'] != null && data['image'].toString().isNotEmpty) {
        _image = XFile(data['image']);
      }

      if (widget.dietData?['dietImageUrl'] != null &&
          widget.dietData!['dietImageUrl'].toString().isNotEmpty) {
        _imageUrl = widget.dietData?['dietImageUrl'];
      }

    }
  }




  // Future<void> loadFoodNames() async {
  //   final names = await fetchFoodNames();
  //
  //   setState(() {
  //     foodNames = names;
  //
  //     // Fix: Ensure selectedFood is valid
  //     if (!foodNames.contains(selectedFood)) {
  //       selectedFood = null;
  //     }
  //   });
  // }

  Future<void> loadFoodNames() async {
    final snapshot = await FirebaseFirestore.instance.collection('food').get();
    final foodList =
    snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return data;
    }).toList();

    setState(() {
      allFoods = foodList;
    });
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

                CustomTextFormField(
                  controller: dietTitleController,
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

                // CustomDropdown(
                //   items: foodNames,
                //   hintText: 'List of Foods',
                //   value: selectedFood,
                //   onChanged: (value) {
                //     setState(() {
                //       selectedFood = value;
                //     });
                //   },
                // ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: allFoods.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      childAspectRatio: 3 / 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) {
                      final food = allFoods[index];
                      final foodName = food['foodName'] ?? 'Unnamed';
                      // final foodImage = food['imageUrl'];
                      // final foodDescription = food['foodDescription'] ?? '';
                      final caloriesPerServing = food['caloriesPerServing'];
                      final isSelected = selectedFoods.contains(foodName);

                      return Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              isSelected
                                  ? selectedFoods.remove(foodName)
                                  : selectedFoods.add(foodName);
                            });
                          },
                          child: Stack(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // if (foodImage != null && foodImage.toString().isNotEmpty)
                                  ClipRRect(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(12),
                                    ),
                                    child: Image.asset(
                                      'assets/male avatar.png',
                                      // <-- replace with your actual asset path
                                      height: 40,
                                      width: 40,
                                      // fit: BoxFit.cover,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Text(
                                        foodName,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: Text(
                                      'CaloriesPerServing: $caloriesPerServing kcal',
                                    ),
                                  ),
                                ],
                              ),
                              Positioned(
                                top: 4,
                                right: 4,
                                child: Checkbox(
                                  value: isSelected,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      value == true
                                          ? selectedFoods.add(foodName)
                                          : selectedFoods.remove(foodName);
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
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
                    // if (_image != null)
                    //   kIsWeb
                    //       ? Container(
                    //     decoration: BoxDecoration(
                    //       border: Border.all(color: Colors.black, width: 3),
                    //       borderRadius: BorderRadius.circular(15),
                    //     ),
                    //     child: Image.network(
                    //       _image!.path,
                    //       height: 300,
                    //       width: 500,
                    //     ),
                    //   )
                    //       : Image.file(File(_image!.path)),
                    if (_image != null)
                      kIsWeb
                          ? FutureBuilder<Uint8List>(
                        future: _image!.readAsBytes(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }
                          if (!snapshot.hasData) {
                            return const Text("Failed to load image");
                          }
                          return Image.memory(snapshot.data!, height: 300, width: 500, fit: BoxFit.cover);
                        },
                      )
                          : Image.file(File(_image!.path), height: 300, width: 500, fit: BoxFit.cover)
                    else if (_imageUrl != null)
                      Image.network(_imageUrl!, height: 300, width: 500, fit: BoxFit.cover)
                    else
                      const Text("No image selected"),


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

  // ElevatedButton buildCustomElevatedButton() {
  //   return ElevatedButton(
  //     style: ElevatedButton.styleFrom(
  //       backgroundColor: Colors.transparent,
  //       shadowColor: Colors.transparent,
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  //     ),
  //     onPressed: () {
  //       timeStampController.text = DateTime.now().toIso8601String();
  //       // if (diettitleController.text.trim().isEmpty) {
  //       //   return;
  //       // }
  //       //
  //       // String id = DateTime.now().millisecondsSinceEpoch.toString();
  //       //
  //       // Map<String, dynamic> dietData = {
  //       //   'dietTitle': diettitleController.text.trim(),
  //       //   'dietDescription': dietDescription.text.trim(),
  //       //   'mealType': selectedMealType ?? '',
  //       //   'day': dayController.text.trim(),
  //       //   'timeToEat': timeController.text.trim(),
  //       //   'foodList': selectedFood ?? '',
  //       //   'duration': durationController.text.trim(),
  //       //   'mealSuitability': selectedMealSuitability ?? '',
  //       //   'mealTag': selectedMealTags ?? '',
  //       //   'image': _image?.path ?? '',
  //       //   'createdBy': nameController.text.trim(),
  //       //   'createdTime': timeStampController.text.trim(),
  //       // };
  //       //
  //       // setState(() {
  //       //   globalDietMap[id] = dietData;
  //       // });
  //       //
  //       // // Clearing controllers
  //       // diettitleController.clear();
  //       // dayController.clear();
  //       // timeController.clear();
  //       // durationController.clear();
  //       // nameController.clear();
  //       // timeStampController.clear();
  //       //
  //       // // Reset dropdown selections here
  //       // selectedMealType = null;
  //       // selectedFood = null;
  //       // selectedMealSuitability = null;
  //       // selectedMealTags = null;
  //       //
  //       // _image = null;
  //       //
  //       // setState(() {});
  //
  //       final user = FirebaseDataModelClass(
  //         dietTitle: dietTitleController.text,
  //         dietDescription: dietDescription.text,
  //         selectedMealType: selectedMealType,
  //         timeToEat: timeController.text,
  //         listOfFood: selectedFoods,
  //         duration: durationController.text,
  //         suitableFor: selectedMealSuitability,
  //         tag: selectedMealTags,
  //         createdBy: nameController.text,
  //         createdAt: timeStampController.text,
  //       );
  //
  //       FirebaseFirestore.instance.collection('diet').doc().set(user.toJson());
  //     },
  //     child: Text("Submit"),
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
  //       timeStampController.text = DateTime.now().toIso8601String();
  //
  //       final user = FirebaseDataModelClass(
  //         dietTitle: dietTitleController.text.trim(),
  //         dietDescription: dietDescription.text.trim(),
  //         selectedMealType: selectedMealType,
  //         timeToEat: timeController.text.trim(),
  //         listOfFood: selectedFoods,
  //         duration: durationController.text.trim(),
  //         suitableFor: selectedMealSuitability,
  //         tag: selectedMealTags,
  //         createdBy: nameController.text.trim(),
  //         createdAt: timeStampController.text.trim(),
  //       );
  //
  //       // Convert to JSON
  //       final dietData = user.toJson();
  //
  //       // 🔹 Remove null or empty values
  //       dietData.removeWhere((key, value) => value == null || value == "");
  //
  //       FirebaseFirestore.instance.collection('diet').doc().set(dietData);
  //
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text("Diet uploaded ✅")),
  //       );
  //
  //       // Optionally clear the form
  //       dietTitleController.clear();
  //       dietDescription.clear();
  //       dayController.clear();
  //       timeController.clear();
  //       durationController.clear();
  //       nameController.clear();
  //       timeStampController.clear();
  //       selectedMealType = null;
  //       selectedMealSuitability = null;
  //       selectedMealTags = null;
  //       selectedFoods = [];
  //       _image = null;
  //
  //       setState(() {});
  //     },
  //     child: const Text("Submit"),
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
        timeStampController.text = DateTime.now().toIso8601String();

        // 🔹 Step 1: Upload image to Supabase (if picked)
        String? imageUrl;
        if (_image != null) {
          try {
            final fileBytes = await _image!.readAsBytes();
            final fileName =
                "diet_${DateTime.now().millisecondsSinceEpoch}_${_image!.name}";

            final response = await Supabase.instance.client.storage
                .from('diet_images')
                .uploadBinary(fileName, fileBytes);

            if (response.isEmpty) {
              throw Exception("Upload failed");
            }

            // ✅ get public URL
            imageUrl = Supabase.instance.client.storage
                .from('diet_images')
                .getPublicUrl(fileName);

          } catch (e) {
            print("❌ Supabase upload failed: $e");
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Image upload failed ❌")),
            );
            return; // stop if upload fails
          }
        }

        // 🔹 Step 2: Save text data + Supabase imageUrl to Firestore
        final user = FirebaseDataModelClass(
          dietTitle: dietTitleController.text.trim(),
          dietDescription: dietDescription.text.trim(),
          selectedMealType: selectedMealType,
          timeToEat: timeController.text.trim(),
          listOfFood: selectedFoods,
          duration: durationController.text.trim(),
          suitableFor: selectedMealSuitability,
          tag: selectedMealTags,
          createdBy: nameController.text.trim(),
          createdAt: timeStampController.text.trim(),
          dietImageUrl: imageUrl, // ✅ add Supabase image url here
        );

        final dietData = user.toJson();
        dietData.removeWhere((key, value) => value == null || value == "");

        await FirebaseFirestore.instance.collection('diet').doc().set(dietData);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Diet uploaded ✅")),
        );

        // 🔹 Step 3: Reset form
        dietTitleController.clear();
        dietDescription.clear();
        dayController.clear();
        timeController.clear();
        durationController.clear();
        nameController.clear();
        timeStampController.clear();
        selectedMealType = null;
        selectedMealSuitability = null;
        selectedMealTags = null;
        selectedFoods = [];
        _image = null;

        setState(() {});
      },
      child: const Text("Submit"),
    );
  }




}

Future<List<String>> fetchFoodNames() async {
  final snapshot = await FirebaseFirestore.instance.collection('food').get();

  return snapshot.docs
      .map((doc) => doc['foodName'] as String?)
      .where((name) => name != null && name.isNotEmpty)
      .cast<String>()
      .toList();
}
