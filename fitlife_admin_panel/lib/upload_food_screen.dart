// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:fitlife_admin_panel/custom_widgets.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:shared/user_0nboarding_data_model_class.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'dashboard.dart';
//
// class UploadFoodScreen extends StatefulWidget {
//   final Map<String, dynamic>? foodData;
//   final String? foodId;
//
//   const UploadFoodScreen({super.key, this.foodData, this.foodId});
//
//   @override
//   State<UploadFoodScreen> createState() => _UploadFoodScreenState();
// }
//
// class _UploadFoodScreenState extends State<UploadFoodScreen> {
//   TextEditingController foodName = TextEditingController();
//   TextEditingController foodDescription = TextEditingController();
//   TextEditingController quantityController = TextEditingController();
//   TextEditingController caloriesPerServing = TextEditingController();
//   TextEditingController proteinController = TextEditingController();
//   TextEditingController carbohydratesController = TextEditingController();
//   TextEditingController fatsController = TextEditingController();
//
//   List<String> quantityOptions = ['grams', 'pieces', 'cups'];
//
//   /// IMPORTANT:
//   /// Foods to Avoid is NOT a category anymore
//   List<String> tagsOptions = [
//     'Fat',
//     'Protein',
//     // 'Nuts & Seeds',
//     'Fish',
//     // 'SeaFood',
//     'Vegetables',
//     // 'Berries & Fruits',
//     //  'Additional',
//     // 'Vegan Protein',
//     // 'Herbs',
//     'Liquids',
//     'Fruits'
//   ];
//
//   String? selectedUnit;
//   String? selectedTag;
//
//   /// Toggle for Eat / Avoid
//   bool isFoodToAvoid = false;
//
//   XFile? _image;
//   String? imageUrl;
//
//   final formKey = GlobalKey<FormState>();
//
//   @override
//   void initState() {
//     super.initState();
//
//     if (widget.foodData != null) {
//       final data = widget.foodData!;
//       foodName.text = data['foodName'] ?? '';
//       foodDescription.text = data['foodDescription'] ?? '';
//       quantityController.text = data['quantity'] ?? '';
//       selectedUnit = data['unit'];
//       caloriesPerServing.text = data['caloriesPerServing'] ?? '';
//       proteinController.text = data['protein'] ?? '';
//       carbohydratesController.text = data['carbohydrates'] ?? '';
//       fatsController.text = data['fats'] ?? '';
//       selectedTag = data['selectedTag'];
//       imageUrl = data['foodImageUrl'];
//     }
//   }
//
//   Future<void> _pickImage() async {
//     final picker = ImagePicker();
//     final image = await picker.pickImage(source: ImageSource.gallery);
//     if (image != null) setState(() => _image = image);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(12),
//         child: SingleChildScrollView(
//           child: Form(
//             key: formKey,
//             child: Column(
//               spacing: 15,
//               children: [
//                 Row(
//                   children: [
//                     IconButton(
//                       icon: const Icon(Icons.arrow_back_rounded),
//                       onPressed:
//                           () => Navigator.push(
//                             context,
//                             MaterialPageRoute(builder: (_) => Dashboard()),
//                           ),
//                     ),
//                   ],
//                 ),
//
//                 CustomTextFormField(controller: foodName, label: "Food Name"),
//                 CustomTextFormField(
//                   controller: foodDescription,
//                   label: "Food Description",
//                   maxLines: 3,
//                 ),
//
//                 CustomTextFormField(
//                   controller: quantityController,
//                   label: "Quantity",
//                 ),
//
//                 CustomDropdown(
//                   items: quantityOptions,
//                   hintText: "Select Units",
//                   value: selectedUnit,
//                   onChanged: (value) => setState(() => selectedUnit = value),
//                 ),
//
//                 CustomTextFormField(
//                   controller: caloriesPerServing,
//                   label: "Calories Per Serving",
//                 ),
//                 CustomTextFormField(
//                   controller: proteinController,
//                   label: "Protein (grams)",
//                 ),
//                 CustomTextFormField(
//                   controller: carbohydratesController,
//                   label: "Carbohydrates (grams)",
//                 ),
//                 CustomTextFormField(
//                   controller: fatsController,
//                   label: "Fats (grams)",
//                 ),
//
//                 CustomDropdown(
//                   items: tagsOptions,
//                   hintText: "Select Category",
//                   value: selectedTag,
//                   onChanged: (value) => setState(() => selectedTag = value),
//                 ),
//
//                 /// Eat / Avoid Toggle (logic only, UI minimal)
//                 SwitchListTile(
//                   title: const Text("Mark as Food to Avoid"),
//                   value: isFoodToAvoid,
//                   onChanged: (v) => setState(() => isFoodToAvoid = v),
//                 ),
//
//                 Row(
//                   children: [
//                     ElevatedButton(
//                       onPressed: _pickImage,
//                       child: const Text("Pick Image"),
//                     ),
//                     const SizedBox(width: 20),
//                     if (_image != null)
//                       kIsWeb
//                           ? Image.network(_image!.path, height: 120, width: 120)
//                           : Image.file(
//                             File(_image!.path),
//                             height: 120,
//                             width: 120,
//                           )
//                     else if (imageUrl != null)
//                       Image.network(imageUrl!, height: 120, width: 120)
//                     else
//                       const Text("No Image Selected"),
//                   ],
//                 ),
//
//                 Container(
//                   decoration: BoxDecoration(
//                     gradient: const LinearGradient(
//                       colors: [Color(0xFF5AFF15), Color(0xFF00B712)],
//                     ),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: buildAddFoodButton(),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   ElevatedButton buildAddFoodButton() {
//     return ElevatedButton(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.transparent,
//         shadowColor: Colors.transparent,
//       ),
//       onPressed: () async {
//         if (selectedTag == null) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text("Please select category")),
//           );
//           return;
//         }
//
//         String? uploadedImageUrl;
//
//         if (_image != null) {
//           final bytes = await _image!.readAsBytes();
//           final fileName =
//               "food_${DateTime.now().millisecondsSinceEpoch}_${_image!.name}";
//
//           await Supabase.instance.client.storage
//               .from('food_images')
//               .uploadBinary(fileName, bytes);
//
//           uploadedImageUrl = Supabase.instance.client.storage
//               .from('food_images')
//               .getPublicUrl(fileName);
//         }
//
//         final food = FirebaseDataModelClass(
//           foodName: foodName.text.trim(),
//           foodDescription: foodDescription.text.trim(),
//           quantity: quantityController.text.trim(),
//           caloriesPerServing: caloriesPerServing.text.trim(),
//           protein: proteinController.text.trim(),
//           carbohydrates: carbohydratesController.text.trim(),
//           fats: fatsController.text.trim(),
//           selectedUnits: selectedUnit,
//           selectedTag: selectedTag,
//           foodImageUrl: uploadedImageUrl,
//         );
//
//         final foodData = food.toJson()
//           ..removeWhere((k, v) => v == null || v == "")
//           ..addAll({
//             "createdAt": DateTime.now().toIso8601String(),
//           });
//
//
//
//
//         final docRef = FirebaseFirestore.instance
//             .collection('Foods')
//             .doc(selectedTag);
//
//         final field = isFoodToAvoid ? 'foods_to_avoid' : 'foods_to_eat';
//
//         await docRef.set({
//           field: FieldValue.arrayUnion([foodData]),
//         }, SetOptions(merge: true));
//
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Food saved successfully ✔")),
//         );
//
//         foodName.clear();
//         foodDescription.clear();
//         quantityController.clear();
//         caloriesPerServing.clear();
//         proteinController.clear();
//         carbohydratesController.clear();
//         fatsController.clear();
//         selectedUnit = null;
//         selectedTag = null;
//         isFoodToAvoid = false;
//         _image = null;
//
//         setState(() {});
//       },
//       child: const Text("ADD FOOD"),
//     );
//   }
// }



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
  final String? foodId;

  const UploadFoodScreen({super.key, this.foodData, this.foodId});

  @override
  State<UploadFoodScreen> createState() => _UploadFoodScreenState();
}

class _UploadFoodScreenState extends State<UploadFoodScreen> {
  final TextEditingController foodName = TextEditingController();
  final TextEditingController foodDescription = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController caloriesPerServing = TextEditingController();
  final TextEditingController proteinController = TextEditingController();
  final TextEditingController carbohydratesController = TextEditingController();
  final TextEditingController fatsController = TextEditingController();

  List<String> quantityOptions = ['grams', 'pieces', 'cups'];
  List<String> tagsOptions = [
    'Fat',
    'Protein',
    'Fish',
    'Vegetables',
    'Liquids',
    'Fruits'
  ];

  String? selectedUnit;
  String? selectedTag;

  /// 🔹 Eat / Avoid Toggle
  bool isFoodToAvoid = false;

  XFile? _image;
  String? imageUrl;

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    /// 🔹 EDIT MODE
    if (widget.foodData != null) {
      final data = widget.foodData!;

      foodName.text = data['foodName'] ?? '';
      foodDescription.text = data['foodDescription'] ?? '';
      quantityController.text = data['quantity'] ?? '';
      caloriesPerServing.text = data['caloriesPerServing'] ?? '';
      proteinController.text = data['protein'] ?? '';
      carbohydratesController.text = data['carbohydrates'] ?? '';
      fatsController.text = data['fats'] ?? '';

      /// ✅ FIXED FIELD NAMES
      selectedUnit = data['selectedUnits'];
      selectedTag = data['selectedTag'];

      /// ✅ DETECT EAT / AVOID
      isFoodToAvoid = data['foodType'] == 'avoid';

      imageUrl = data['foodImageUrl'];
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) setState(() => _image = image);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              spacing: 15,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_rounded),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => Dashboard()),
                      ),
                    ),
                  ],
                ),

                CustomTextFormField(controller: foodName, label: "Food Name"),
                CustomTextFormField(
                  controller: foodDescription,
                  label: "Food Description",
                  maxLines: 3,
                ),
                CustomTextFormField(
                  controller: quantityController,
                  label: "Quantity",
                ),

                CustomDropdown(
                  items: quantityOptions,
                  hintText: "Select Units",
                  value: selectedUnit,
                  onChanged: (value) => setState(() => selectedUnit = value),
                ),

                CustomTextFormField(
                  controller: caloriesPerServing,
                  label: "Calories Per Serving",
                ),
                CustomTextFormField(
                  controller: proteinController,
                  label: "Protein (grams)",
                ),
                CustomTextFormField(
                  controller: carbohydratesController,
                  label: "Carbohydrates (grams)",
                ),
                CustomTextFormField(
                  controller: fatsController,
                  label: "Fats (grams)",
                ),

                CustomDropdown(
                  items: tagsOptions,
                  hintText: "Select Category",
                  value: selectedTag,
                  onChanged: (value) => setState(() => selectedTag = value),
                ),

                /// ✅ EAT / AVOID TOGGLE RESTORED
                SwitchListTile(
                  title: const Text("Mark as Food to Avoid"),
                  value: isFoodToAvoid,
                  onChanged: (v) => setState(() => isFoodToAvoid = v),
                ),

                Row(
                  children: [
                    ElevatedButton(
                      onPressed: _pickImage,
                      child: const Text("Pick Image"),
                    ),
                    const SizedBox(width: 20),
                    if (_image != null)
                      kIsWeb
                          ? Image.network(_image!.path, height: 120)
                          : Image.file(File(_image!.path), height: 120)
                    else if (imageUrl != null)
                      Image.network(imageUrl!, height: 120)
                    else
                      const Text("No Image Selected"),
                  ],
                ),

                Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF5AFF15), Color(0xFF00B712)],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: buildAddFoodButton(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ElevatedButton buildAddFoodButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      onPressed: () async {
        if (selectedTag == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please select category")),
          );
          return;
        }

        String? uploadedImageUrl = imageUrl;

        if (_image != null) {
          final bytes = await _image!.readAsBytes();
          final fileName =
              "food_${DateTime.now().millisecondsSinceEpoch}_${_image!.name}";

          await Supabase.instance.client.storage
              .from('food_images')
              .uploadBinary(fileName, bytes);

          uploadedImageUrl = Supabase.instance.client.storage
              .from('food_images')
              .getPublicUrl(fileName);
        }

        final food = FirebaseDataModelClass(
          foodName: foodName.text.trim(),
          foodDescription: foodDescription.text.trim(),
          quantity: quantityController.text.trim(),
          caloriesPerServing: caloriesPerServing.text.trim(),
          protein: proteinController.text.trim(),
          carbohydrates: carbohydratesController.text.trim(),
          fats: fatsController.text.trim(),
          selectedUnits: selectedUnit,
          selectedTag: selectedTag,
          foodImageUrl: uploadedImageUrl,
        );

        final foodData = food.toJson()
          ..addAll({
            "createdAt": DateTime.now().toIso8601String(),
          })
          ..removeWhere((k, v) => v == null || v == "");

        final docRef =
        FirebaseFirestore.instance.collection('Foods').doc(selectedTag);

        final field = isFoodToAvoid ? 'foods_to_avoid' : 'foods_to_eat';

        /// ✅ REMOVE OLD FOOD IF EDITING
        if (widget.foodData != null) {
          await docRef.update({
            'foods_to_eat': FieldValue.arrayRemove([widget.foodData]),
            'foods_to_avoid': FieldValue.arrayRemove([widget.foodData]),
          });
        }

        /// ✅ ADD UPDATED FOOD
        await docRef.set({
          field: FieldValue.arrayUnion([foodData]),
        }, SetOptions(merge: true));

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Food saved successfully ✔")),
        );

        Navigator.pop(context);
      },
      child: const Text("ADD FOOD"),
    );
  }
}
