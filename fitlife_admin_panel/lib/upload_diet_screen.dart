import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitlife_admin_panel/custom_widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dashboard.dart';

class UploadDietScreen extends StatefulWidget {
  final String? dietId;
  final Map<String, dynamic>? dietData;

  const UploadDietScreen({super.key, this.dietId, this.dietData});

  @override
  State<UploadDietScreen> createState() => _UploadDietScreenState();
}

class _UploadDietScreenState extends State<UploadDietScreen> {
  final formKey = GlobalKey<FormState>();

  final dietTitleController = TextEditingController();
  final dietDescription = TextEditingController();
  final durationController = TextEditingController();
  final nameController = TextEditingController();

  XFile? _image;
  String? _imageUrl;

  final List<String> suitableForOptions = [
    'Weight Loss',
    'Muscle Gain',
    'Athletes',
    'Beginners',
    'Seniors',
    'Pregnant Women',
    'Diabetic Patients',
    'Heart Patients',
    'Vegetarians',
    'Vegans',
    'General Health',
    'Post Surgery',
    'Kids & Teens',
  ];

  final List<String> tagsOptions = [
    'High Protein',
    'Low Carb',
    'Keto',
    'Paleo',
    'Mediterranean',
    'Gluten Free',
    'Dairy Free',
    'Sugar Free',
    'Low Fat',
    'High Fiber',
    'Anti-inflammatory',
    'Detox',
    'Energy Boosting',
    'Immunity Boosting',
    'Budget Friendly',
    'Quick & Easy',
    'Meal Prep',
  ];

  String? selectedSuitableFor;
  String? selectedTag;

  final List<String> categories = [
    "Fat",
    "Protein",
    "Fish",
    "Vegetables",
    "Liquids",
    "Fruits",
  ];

  final List<String> daysOfWeek = [
    'Day 1',
    'Day 2',
    'Day 3',
    'Day 4',
    'Day 5',
    'Day 6',
    'Day 7',
  ];

  Map<String, List<Map<String, dynamic>>> weeklyMeals = {
    for (int i = 1; i <= 7; i++)
      "Day $i": [
        {
          "mealName": "Meal 1",
          "time": null,
          "category": "Fat",
          "foodsToEatByCategory": {},
          "foodsToAvoidByCategory": {},
        },
        {
          "mealName": "Meal 2",
          "time": null,
          "category": "Fat",
          "foodsToEatByCategory": {},
          "foodsToAvoidByCategory": {},
        },
      ],
  };

  Map<String, List<Map<String, dynamic>>> foodsToEatByCategory = {};
  Map<String, List<Map<String, dynamic>>> foodsToAvoidByCategory = {};

  @override
  void initState() {
    super.initState();
    _loadFoods("Fat"); // default category

    if (widget.dietData != null) {
      dietTitleController.text = widget.dietData!['dietTitle'] ?? '';
      dietDescription.text = widget.dietData!['dietDescription'] ?? '';
      durationController.text = widget.dietData!['duration'] ?? '';
      nameController.text = widget.dietData!['createdBy'] ?? '';
      _imageUrl = widget.dietData!['dietImageUrl'];

      selectedSuitableFor = widget.dietData!['suitableFor'];
      selectedTag =
          widget.dietData!['tag'] ??
          (widget.dietData!['tags'] is List &&
                  widget.dietData!['tags'].isNotEmpty
              ? widget.dietData!['tags'][0]
              : widget.dietData!['tags']);

      if (widget.dietData!['weeklyMeals'] != null) {
        final rawMeals = Map<String, dynamic>.from(
          widget.dietData!['weeklyMeals'],
        );
        weeklyMeals = {};

        rawMeals.forEach((day, dayMeals) {
          final List<Map<String, dynamic>> convertedMeals = [];

          for (var meal in dayMeals) {
            final Map<String, dynamic> mealMap = Map<String, dynamic>.from(
              meal,
            );

            mealMap['category'] = mealMap['category'] ?? 'Fat';
            mealMap['foodsToEatByCategory'] ??= {};
            mealMap['foodsToAvoidByCategory'] ??= {};

            // Populate foods per category
            if (mealMap['foodsToEat'] is List) {
              mealMap['foodsToEatByCategory'][mealMap['category']] =
                  List<Map<String, dynamic>>.from(mealMap['foodsToEat']);
            }
            if (mealMap['foodsToAvoid'] is List) {
              mealMap['foodsToAvoidByCategory'][mealMap['category']] =
                  List<Map<String, dynamic>>.from(mealMap['foodsToAvoid']);
            }

            convertedMeals.add(mealMap);
          }

          weeklyMeals[day] = convertedMeals;
        });
      }
    }
  }

  Future<void> _loadFoods(String category) async {
    if (foodsToEatByCategory.containsKey(category) &&
        foodsToAvoidByCategory.containsKey(category)) {
      return;
    }

    final doc =
        await FirebaseFirestore.instance
            .collection("Foods")
            .doc(category)
            .get();

    if (!doc.exists) {
      setState(() {
        foodsToEatByCategory[category] = [];
        foodsToAvoidByCategory[category] = [];
      });
      return;
    }

    final data = doc.data();
    setState(() {
      foodsToEatByCategory[category] =
          (data?['foods_to_eat'] ?? [])
              .map<Map<String, dynamic>>(
                (food) => {
                  'foodName': food['foodName'] ?? '',
                  'caloriesPerServing': food['caloriesPerServing'] ?? '0 kcal',
                  'imageUrl': food['foodImageUrl'] ?? '',
                  'servingSize': food['quantity'] ?? '',
                  'protein': food['protein'] ?? '0 g',
                  'carbs': food['carbohydrates'] ?? '0 g',
                  'fat': food['fats'] ?? '0 g',
                  'foodDescription': food['foodDescription'] ?? '',
                  'selectedTag': food['selectedTag'] ?? '',
                  'selectedUnits': food['selectedUnits'] ?? '',
                },
              )
              .toList();

      foodsToAvoidByCategory[category] =
          (data?['foods_to_avoid'] ?? [])
              .map<Map<String, dynamic>>(
                (food) => {
                  'foodName': food['foodName'] ?? '',
                  'caloriesPerServing': food['caloriesPerServing'] ?? '0 kcal',
                  'imageUrl': food['foodImageUrl'] ?? '',
                  'servingSize': food['quantity'] ?? '',
                  'protein': food['protein'] ?? '0 g',
                  'carbs': food['carbohydrates'] ?? '0 g',
                  'fat': food['fats'] ?? '0 g',
                  'foodDescription': food['foodDescription'] ?? '',
                  'selectedTag': food['selectedTag'] ?? '',
                  'selectedUnits': food['selectedUnits'] ?? '',
                },
              )
              .toList();
    });
  }

  Future<void> _pickMealTime(String day, int index) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        weeklyMeals[day]![index]['time'] = picked.format(context);
      });
    }
  }

  void _addMealToDay(String day) {
    setState(() {
      final mealNumber = weeklyMeals[day]!.length + 1;
      weeklyMeals[day]!.add({
        "mealName": "Meal $mealNumber",
        "time": null,
        "category": "Fat",
        "foodsToEatByCategory": {},
        "foodsToAvoidByCategory": {},
      });
    });
  }

  Widget _foodGrid(
    String category,
    List selectedList,
    bool isFoodsToEat,
    void Function(Map<String, dynamic> food) onTap,
  ) {
    final foods =
        isFoodsToEat
            ? (foodsToEatByCategory[category] ?? [])
            : (foodsToAvoidByCategory[category] ?? []);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        childAspectRatio: 1.25,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: foods.length,
      itemBuilder: (_, i) {
        final food = foods[i];
        final name = food['foodName'] ?? '';
        final calories = food['caloriesPerServing'] ?? 0;
        final imageUrl = food['imageUrl'] ?? '';

        final isSelected = selectedList.any((selectedFood) {
          final selectedName = selectedFood['foodName'] ?? '';
          return selectedName == name;
        });

        return Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: isSelected ? Colors.blue.shade50 : Colors.white,
          child: InkWell(
            onTap: () => onTap(food),
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 12, 8, 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.grey.shade200,
                        backgroundImage:
                            imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
                        child:
                            imageUrl.isEmpty
                                ? const Icon(Icons.fastfood, size: 20)
                                : null,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        name,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        "Calories per serving",
                        style: TextStyle(
                          fontSize: 9,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          "$calories kcal",
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: -4,
                  right: -4,
                  child: Transform.scale(
                    scale: 0.8,
                    child: Checkbox(
                      value: isSelected,
                      activeColor: Colors.blue,
                      shape: const CircleBorder(),
                      onChanged: (_) => onTap(food),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _categoryToggle(String day, int index) {
    final current = weeklyMeals[day]![index]['category'];

    return Wrap(
      spacing: 8,
      children:
          categories.map((cat) {
            return ChoiceChip(
              label: Text(cat),
              selected: current == cat,
              onSelected: (selected) async {
                if (selected) {
                  setState(() {
                    weeklyMeals[day]![index]['category'] = cat;
                  });
                  await _loadFoods(cat);
                }
              },
            );
          }).toList(),
    );
  }

  Widget _mealCard(String day, int index) {
    final meal = weeklyMeals[day]![index];
    final currentCategory = meal['category'];

    meal['foodsToEatByCategory'] ??= {};
    meal['foodsToAvoidByCategory'] ??= {};

    final foodsToEatList = List<Map<String, dynamic>>.from(
      meal['foodsToEatByCategory'][currentCategory] ?? [],
    );
    final foodsToAvoidList = List<Map<String, dynamic>>.from(
      meal['foodsToAvoidByCategory'][currentCategory] ?? [],
    );

    if (!foodsToEatByCategory.containsKey(currentCategory)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadFoods(currentCategory);
      });

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Center(
          child: Column(
            children: const [
              CircularProgressIndicator(),
              SizedBox(height: 10),
              Text('Loading foods...'),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                meal['mealName'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              Text(
                meal['time'] ?? "No time",
                style: const TextStyle(color: Colors.grey),
              ),
              IconButton(
                icon: const Icon(Icons.access_time),
                onPressed: () => _pickMealTime(day, index),
              ),
            ],
          ),
          const Text(
            "Select Category:",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          _categoryToggle(day, index),
          const SizedBox(height: 12),
          const Text(
            "Foods To Eat",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
          ),
          const Divider(),
          _foodGrid(currentCategory, foodsToEatList, true, (food) {
            setState(() {
              final existingIndex = foodsToEatList.indexWhere(
                (f) => f['foodName'] == food['foodName'],
              );
              if (existingIndex >= 0) {
                foodsToEatList.removeAt(existingIndex);
              } else {
                foodsToEatList.add(food);
              }
              meal['foodsToEatByCategory'][currentCategory] = foodsToEatList;
            });
          }),
          const SizedBox(height: 12),
          const Text(
            "Foods To Avoid",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
          ),
          const Divider(),
          _foodGrid(currentCategory, foodsToAvoidList, false, (food) {
            setState(() {
              final existingIndex = foodsToAvoidList.indexWhere(
                (f) => f['foodName'] == food['foodName'],
              );
              if (existingIndex >= 0) {
                foodsToAvoidList.removeAt(existingIndex);
              } else {
                foodsToAvoidList.add(food);
              }
              meal['foodsToAvoidByCategory'][currentCategory] =
                  foodsToAvoidList;
            });
          }),
          const Divider(thickness: 2),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (dietTitleController.text.isEmpty ||
        selectedSuitableFor == null ||
        selectedTag == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields")),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      String? imageUrl = _imageUrl;
      if (_image != null) {
        final bytes = await _image!.readAsBytes();
        final fileName = "diet_${DateTime.now().millisecondsSinceEpoch}";
        await Supabase.instance.client.storage
            .from('diet_images')
            .uploadBinary(fileName, bytes);
        imageUrl = Supabase.instance.client.storage
            .from('diet_images')
            .getPublicUrl(fileName);
      }

      // Flatten foods by category before saving
      final flattenedMeals = <String, List<Map<String, dynamic>>>{};
      weeklyMeals.forEach((day, meals) {
        flattenedMeals[day] =
            meals.map((meal) {
              final foodsToEat = <Map<String, dynamic>>[];
              final foodsToAvoid = <Map<String, dynamic>>[];

              (meal['foodsToEatByCategory'] ?? {}).forEach(
                (cat, list) => foodsToEat.addAll(list),
              );
              (meal['foodsToAvoidByCategory'] ?? {}).forEach(
                (cat, list) => foodsToAvoid.addAll(list),
              );

              return {
                ...meal,
                'foodsToEat': foodsToEat,
                'foodsToAvoid': foodsToAvoid,
              };
            }).toList();
      });

      final data = {
        "dietTitle": dietTitleController.text,
        "dietDescription": dietDescription.text,
        "duration": durationController.text,
        "createdBy": nameController.text,
        "createdAt": DateTime.now().toIso8601String(),
        "dietImageUrl": imageUrl,
        "suitableFor": selectedSuitableFor,
        "tag": selectedTag,
        "weeklyMeals": flattenedMeals,
      };

      if (widget.dietId != null) {
        await FirebaseFirestore.instance
            .collection("diet")
            .doc(widget.dietId)
            .update(data);
      } else {
        await FirebaseFirestore.instance.collection("diet").add(data);
      }

      if (mounted) {
        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const Dashboard()),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.dietId == null
                  ? "Diet plan created successfully!"
                  : "Diet plan updated successfully!",
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: ${error.toString()}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.dietId == null ? "Upload Diet" : "Edit Diet"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextFormField(
              controller: dietTitleController,
              label: "Diet Title",
              hintText: "Enter diet title",
            ),
            const SizedBox(height: 16),
            CustomTextFormField(
              controller: dietDescription,
              label: "Description",
              hintText: "Enter diet description",
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            CustomTextFormField(
              controller: durationController,
              label: "Duration",
              hintText: "e.g., 30 days, 12 weeks",
            ),
            const SizedBox(height: 16),
            const Text(
              "Suitable For",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            CustomDropdown(
              items: suitableForOptions,
              hintText: "Select who this diet is suitable for",
              value: selectedSuitableFor,
              onChanged: (v) => setState(() => selectedSuitableFor = v),
            ),
            const SizedBox(height: 16),
            const Text(
              "Tag",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            CustomDropdown(
              items: tagsOptions,
              hintText: "Select a tag",
              value: selectedTag,
              onChanged: (v) => setState(() => selectedTag = v),
            ),
            const SizedBox(height: 20),
            const Text(
              "Weekly Schedule",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            for (final day in daysOfWeek)
              Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ExpansionTile(
                  tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                  title: Text(
                    day,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  children: [
                    for (int i = 0; i < weeklyMeals[day]!.length; i++)
                      _mealCard(day, i),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: ElevatedButton.icon(
                          onPressed: () => _addMealToDay(day),
                          icon: const Icon(Icons.add),
                          label: const Text('Add Meal'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Diet Image",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed: () async {
                            final img = await ImagePicker().pickImage(
                              source: ImageSource.gallery,
                            );
                            if (img != null) setState(() => _image = img);
                          },
                          icon: const Icon(Icons.image),
                          label: const Text("Pick Image"),
                        ),
                        const SizedBox(width: 20),
                        if (_image != null)
                          kIsWeb
                              ? FutureBuilder<Uint8List>(
                                future: _image!.readAsBytes(),
                                builder:
                                    (_, s) =>
                                        s.hasData
                                            ? Image.memory(s.data!, height: 100)
                                            : const SizedBox(),
                              )
                              : Image.file(File(_image!.path), height: 100)
                        else if (_imageUrl != null)
                          Image.network(_imageUrl!, height: 100),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            CustomTextFormField(
              controller: nameController,
              label: "Created By",
              hintText: "Enter your name",
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _submit,
                child: Text(
                  widget.dietId == null ? "SUBMIT DIET" : "UPDATE DIET",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
