import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitlife_app/custom widgets/add_meals_tile.dart';
import 'package:fitlife_app/meals_history_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared/user_0nboarding_data_model_class.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitlife_app/custom widgets/summary_meals_tile.dart';

class AddMealsScreen extends StatefulWidget {
  const AddMealsScreen({super.key});

  @override
  State<AddMealsScreen> createState() => _AddMealsScreenState();
}

class _AddMealsScreenState extends State<AddMealsScreen> {
  String selectedMealType = "Breakfast";
  List<String> mealTypes = ["Breakfast", "Lunch", "Dinner"];

  FirebaseDataModelClass? userData;
  bool _isloading = true;

  Map<String, List<FoodModel>> selectedFoodsByMeal = {
    "Breakfast": [],
    "Lunch": [],
    "Dinner": [],
  };

  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final userId = "24pWkz3CU0PUanITZz3LcAIUNIz2";
    try {
      final doc =
      await FirebaseFirestore.instance.collection('Users').doc(userId).get();
      if (doc.exists) {
        setState(() {
          userData = FirebaseDataModelClass.fromJson(doc.data()!);

          if (userData?.userSelectedFood != null) {
            for (var food in userData!.userSelectedFood!) {
              selectedFoodsByMeal[food.mealType ?? "Breakfast"]?.add(food);
            }
          }

          _isloading = false;
        });
      } else {
        setState(() {
          _isloading = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching user data: $e");
    }
  }

  Future<void> _addFood(FoodModel food) async {
    final userId = "24pWkz3CU0PUanITZz3LcAIUNIz2";
    if (userId == null) return;

    try {
      final docRef = FirebaseFirestore.instance.collection('Users').doc(userId);
      final snapshot = await docRef.get();

      List<FoodModel> updatedFoods = [];
      if (snapshot.exists && snapshot.data()!.containsKey("userSelectedFood")) {
        updatedFoods = (snapshot["userSelectedFood"] as List<dynamic>)
            .map((f) => FoodModel.fromMap(f))
            .toList();
      }

      updatedFoods.add(food);

      await docRef.update({
        "userSelectedFood": updatedFoods.map((f) => f.toJson()).toList(),
      });

      setState(() {
        selectedFoodsByMeal[food.mealType ?? "Breakfast"]?.add(food);
      });
    } catch (e) {
      debugPrint("Error adding food: $e");
    }
  }

  Future<void> _deleteFood(FoodModel food) async {
    final userId = "24pWkz3CU0PUanITZz3LcAIUNIz2";
    if (userId == null) return;

    try {
      final docRef = FirebaseFirestore.instance.collection('Users').doc(userId);
      final snapshot = await docRef.get();

      if (!snapshot.exists) return;

      List<FoodModel> updatedFoods = (snapshot["userSelectedFood"] as List<dynamic>)
          .map((f) => FoodModel.fromMap(f))
          .toList();

      updatedFoods.removeWhere((f) =>
      f.foodName == food.foodName &&
          f.mealType == food.mealType &&
          f.consumptions.first.date == food.consumptions.first.date);

      await docRef.update({
        "userSelectedFood": updatedFoods.map((f) => f.toJson()).toList(),
      });

      setState(() {
        selectedFoodsByMeal[food.mealType ?? "Breakfast"]?.remove(food);
      });
    } catch (e) {
      debugPrint("Error deleting food: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isloading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (userData == null) {
      return const Scaffold(
        body: Center(child: Text("No user data found")),
      );
    }

    final foods = userData!.assignedFoods ?? [];

    final filteredFoods = foods
        .where((food) =>
        food.foodName.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: foods.isEmpty
          ? const Center(child: Text("No foods assigned"))
          : SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              const SizedBox(height: 15),
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios),
                  ),
                  const Spacer(),
                  const Text(
                    "Add Meals",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) =>
                          setState(() => searchQuery = value),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.greenAccent,
                        ),
                        hintText: "Search",
                        hintStyle:
                        const TextStyle(color: Colors.greenAccent),
                        fillColor: const Color(0xFFE9FDE3),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Container(
                    width: 145,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF5AFF15), Color(0xFF00B712)],
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedMealType,
                        dropdownColor: const Color(0xFFE9FDE3),
                        borderRadius: BorderRadius.circular(12),
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.white,
                        ),
                        style: const TextStyle(color: Colors.white),
                        items: mealTypes.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style:
                              const TextStyle(color: Colors.black),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedMealType = newValue!;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              if (selectedFoodsByMeal[selectedMealType]!.isNotEmpty) ...[
                Text(
                  selectedMealType,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),

                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: selectedFoodsByMeal[selectedMealType]!
                      .where((food) {
                    final entryDate =
                        DateTime.tryParse(food.consumptions.first.date) ??
                            DateTime.now();
                    final now = DateTime.now();
                    return entryDate.year == now.year &&
                        entryDate.month == now.month &&
                        entryDate.day == now.day;
                  }).length,
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 3,
                  ),
                  itemBuilder: (context, index) {
                    final todayFoods =
                    selectedFoodsByMeal[selectedMealType]!
                        .where((food) {
                      final entryDate = DateTime.tryParse(
                          food.consumptions.first.date) ??
                          DateTime.now();
                      final now = DateTime.now();
                      return entryDate.year == now.year &&
                          entryDate.month == now.month &&
                          entryDate.day == now.day;
                    }).toList();

                    final food = todayFoods[index];
                    final qty =
                        int.tryParse(food.consumptions.first.foodQuantity) ??
                            1;
                    final kcal = int.tryParse(food.calories) ?? 0;
                    final totalKcal = qty * kcal;

                    return SummaryMealsTile(
                      itemName: food.foodName,
                      kcal: totalKcal.toString(),
                      qty: qty,
                      width: MediaQuery.of(context).size.width * 0.45,
                      onDelete: () => _deleteFood(food),
                      foodImageUrl: food.foodImageUrl,
                    );
                  },
                ),
                const SizedBox(height: 20),
              ],

              const Text(
                "Items",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredFoods.length,
                itemBuilder: (context, index) {
                  final food = filteredFoods[index];
                  return AddMealsTile(
                    itemName: food.foodName.isNotEmpty ? food.foodName : "Unknown",
                    subtitle: food.quantity ?? "No quantity",
                    kcal: food.calories,
                    foodImageUrl: food.foodImageUrl,
                    onAdd: (qty) {
                      final consumptionEntry = ConsumptionEntry(
                        date: DateTime.now().toIso8601String(),
                        foodQuantity: qty.toString(),
                        mealType: selectedMealType,
                      );
                      final updatedFood = FoodModel(
                        foodName: food.foodName,
                        calories: food.calories,
                        foodDescription: food.foodDescription,
                        mealType: selectedMealType,
                        quantity: food.quantity,
                        consumptions: [consumptionEntry],
                        foodImageUrl: food.foodImageUrl,
                      );
                      _addFood(updatedFood);
                    },
                  );
                },
              ),
              const SizedBox(height: 30),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MealsHistoryScreen()),
                  );
                },
                child: const Center(child: Text("Meals History")),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
