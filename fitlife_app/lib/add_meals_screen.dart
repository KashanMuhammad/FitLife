import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitlife_app/custom%20widgets/add_meals_tile.dart';
import 'package:fitlife_app/meals_history_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared/user_0nboarding_data_model_class.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  // ✅ Local map to store added foods by meal type
  Map<String, List<Map<String, dynamic>>> selectedFoodsByMeal = {
    "Breakfast": [],
    "Lunch": [],
    "Dinner": [],
  };

  // ✅ Search query
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    try {
      final doc =
      await FirebaseFirestore.instance.collection("Users").doc(userId).get();
      if (doc.exists) {
        setState(() {
          userData = FirebaseDataModelClass.fromJson(doc.data()!);

          // ✅ Load previously saved foods from Firestore
          if (doc.data()!.containsKey("userSelectedFood")) {
            List<dynamic> savedFoods = doc["userSelectedFood"];
            for (var food in savedFoods) {
              selectedFoodsByMeal[food["mealType"]]
                  ?.add(Map<String, dynamic>.from(food));
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
      print("Error fetching user data: $e");
      setState(() => _isloading = true);
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

    // ✅ Filter foods by search query
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
                    onPressed: () {},
                    icon: const Icon(Icons.arrow_back_ios),
                  ),
                  const SizedBox(width: 100),
                  const Text(
                    "Add Meals",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  // 🔍 Search field
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
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
                  // 🍽️ Dropdown container
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

              // ✅ Summary section for selected meal
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

                SizedBox(
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: selectedFoodsByMeal[selectedMealType]!
                        .where((food) {
                      // ✅ Filter by today's date
                      if (food["consumptions"] == null ||
                          food["consumptions"].isEmpty) {
                        return false;
                      }
                      DateTime entryDate =
                          DateTime.tryParse(food["consumptions"][0]
                          ["date"]) ??
                              DateTime.now();
                      DateTime now = DateTime.now();

                      return entryDate.year == now.year &&
                          entryDate.month == now.month &&
                          entryDate.day == now.day;
                    }).length,
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // ✅ 2 per row
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 3, // ✅ Adjust height/width ratio
                    ),
                    itemBuilder: (context, index) {
                      final todayFoods =
                      selectedFoodsByMeal[selectedMealType]!
                          .where((food) {
                        if (food["consumptions"] == null ||
                            food["consumptions"].isEmpty) {
                          return false;
                        }
                        DateTime entryDate = DateTime.tryParse(
                            food["consumptions"][0]["date"]) ??
                            DateTime.now();
                        DateTime now = DateTime.now();

                        return entryDate.year == now.year &&
                            entryDate.month == now.month &&
                            entryDate.day == now.day;
                      }).toList();

                      final food = todayFoods[index];

                      int qty = int.tryParse(food["consumptions"][0]
                      ["foodQuantity"]
                          .toString()) ??
                          1;
                      int kcal =
                          int.tryParse(food["caloriesPerServing"].toString()) ??
                              0;
                      int totalKcal = qty * kcal;

                      return Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 5,
                              spreadRadius: 1,
                            )
                          ],
                        ),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/images/Rectangleimage.svg',
                              width: 35,
                              height: 35,
                            ),
                            SizedBox(width: 5),
                            // Food info
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  Text(
                                    food["foodName"],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    "$totalKcal Kcal",
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.black54),
                                  ),
                                ],
                              ),
                            ),

                            // 🔴 Quantity circle
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red,
                              ),
                              child: Text(
                                qty.toString(),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),

                            const SizedBox(width: 6),

                            // ❌ Delete button
                            InkWell(
                              onTap: () async {
                                try {
                                  await FirebaseFirestore.instance
                                      .collection("Users")
                                      .doc(
                                      FirebaseAuth.instance.currentUser?.uid)
                                      .update({
                                    "userSelectedFood":
                                    FieldValue.arrayRemove([food]),
                                  });

                                  setState(() {
                                    selectedFoodsByMeal[selectedMealType]!
                                        .remove(food);
                                  });
                                } catch (e) {
                                  print("Error deleting food: $e");
                                }
                              },
                              child: const Icon(Icons.close,
                                  color: Colors.red, size: 18),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
              ],

              Text(
                "Items",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              const SizedBox(height: 20),

              // ✅ Assigned foods list (filtered by search)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredFoods.length,
                itemBuilder: (context, index) {
                  final food = filteredFoods[index];
                  return AddMealsTile(
                    itemName: food.foodName.isNotEmpty
                        ? food.foodName
                        : "Unknown",
                    subtitle: food.quantity ?? "No quantity",
                    kcal: food.calories,
                    onAdd: (qty) async {
                      final consumptionEntry = {
                        "date": DateTime.now().toIso8601String(),
                        "foodQuantity": qty.toString(),
                      };
                      final updatedFood = {
                        "mealType": selectedMealType,
                        "foodName": food.foodName,
                        "caloriesPerServing": food.calories,
                        "consumptions": [consumptionEntry],
                      };

                      try {
                        await FirebaseFirestore.instance
                            .collection("Users")
                            .doc( FirebaseAuth.instance.currentUser?.uid)
                            .update({
                          "userSelectedFood":
                          FieldValue.arrayUnion([updatedFood]),
                        });

                        setState(() {
                          selectedFoodsByMeal[selectedMealType]!
                              .add(updatedFood);
                        });
                      } catch (e) {
                        print("Error : not updated");
                      }
                    },
                  );
                },
              ),
              SizedBox(height: 30),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MealsHistoryScreen()));
                },
                child: Center(child: const Text("Meals History")),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
