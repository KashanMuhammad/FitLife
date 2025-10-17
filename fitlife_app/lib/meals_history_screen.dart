import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitlife_app/custom%20widgets/custom_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:shared/user_0nboarding_data_model_class.dart';

class MealsHistoryScreen extends StatefulWidget {
  const MealsHistoryScreen({super.key});

  @override
  State<MealsHistoryScreen> createState() => _MealsHistoryScreenState();
}

class _MealsHistoryScreenState extends State<MealsHistoryScreen> {
  FirebaseDataModelClass? userData;
  bool _isLoading = true;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    var userId = FirebaseAuth.instance.currentUser!.uid;
    try {
      final doc =
      await FirebaseFirestore.instance.collection('Users').doc(userId).get();

      if (doc.exists) {
        setState(() {
          userData = FirebaseDataModelClass.fromJson(doc.data()!);
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print("⚠️ Error fetching user meals: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (userData == null || userData!.userSelectedFood == null) {
      return const Scaffold(
        body: Center(child: Text("No meals history found")),
      );
    }

    final List<FoodModel> foods = userData!.userSelectedFood ?? [];

    // 🔍 Filter by meal type using toggle
    List<FoodModel> filteredFoods;
    if (selectedIndex == 0) {
      filteredFoods = foods; // All
    } else if (selectedIndex == 1) {
      filteredFoods = foods.where((f) => f.mealType == "Breakfast").toList();
    } else if (selectedIndex == 2) {
      filteredFoods = foods.where((f) => f.mealType == "Lunch").toList();
    } else {
      filteredFoods = foods.where((f) => f.mealType == "Dinner").toList();
    }

    final dateBeforeYesterday = DateTime.now().subtract(const Duration(days: 2));

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back_ios),
                    ),
                    const SizedBox(width: 100),
                    const Text(
                      "Meals History",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(8),
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: const Color(0xFFE9FDE3),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // All Button
                      AllToggleButton(),

                      // Breakfast Button
                      BreakfastToggleButton(),

                      // Lunch Button
                      LunchToggleButton(),

                      // Dinner Button
                      DinnerToggleButton(),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  "Today's Meals",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),

                // 🔹 Today Meals
                TodaysMeals(filteredFoods),
                SizedBox(height: 15),
                Text(
                  "Yesterday's Meals",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),

                // 🔹 Yesterday Meals
                YesterdayMeals(filteredFoods),
                SizedBox(height: 15),

                // 🔹 Before Yesterday
                Text(
                  "${dateBeforeYesterday.day}-${dateBeforeYesterday.month}-${dateBeforeYesterday.year} Meals",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),

                BeforeYesterdayMeals(filteredFoods),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding BeforeYesterdayMeals(List<FoodModel> filteredFoods) {
    return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: filteredFoods.length,
                  itemBuilder: (context, index) {
                    final food = filteredFoods[index];

                    // Date before yesterday
                    final beforeYesterday =
                    DateTime.now().subtract(const Duration(days: 2));

                    final filteredConsumptions =
                    food.consumptions.where((c) {
                      DateTime consumptionDate =
                          DateTime.tryParse(c.date) ?? DateTime.now();
                      return consumptionDate.year == beforeYesterday.year &&
                          consumptionDate.month == beforeYesterday.month &&
                          consumptionDate.day == beforeYesterday.day;
                    }).toList();

                    if (filteredConsumptions.isEmpty) {
                      return const SizedBox.shrink(); // Skip foods with no entries
                    }

                    // Build subtitle text
                    String consumptionText =
                    filteredConsumptions.map((c) {
                      double foodCalories =
                          double.tryParse(food.calories) ?? 0;
                      double quantity =
                          double.tryParse(c.foodQuantity) ?? 1;
                      double totalCalories = foodCalories * quantity;
                      return "${c.foodQuantity} Foods   (${totalCalories.toStringAsFixed(0)} kcal)";
                    }).join("\n");

                    return CustomListTile(
                      title: food.foodName,
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          food.foodImageUrl ?? 'https://via.placeholder.com/60',
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.fastfood, color: Colors.grey),
                          ),
                        ),
                      ),

                      subtitle: consumptionText.isEmpty
                          ? "No consumption entries • ${food.calories} kcal"
                          : consumptionText,
                      trailing: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.arrow_forward_ios),
                      ),
                      tileColor: Color(0xFFFAFAFA),
                    );
                  },
                ),
              );
  }

  Padding YesterdayMeals(List<FoodModel> filteredFoods) {
    return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: filteredFoods.length,
                  itemBuilder: (context, index) {
                    final food = filteredFoods[index];

                    // Filter consumptions only from yesterday
                    final yesterday =
                    DateTime.now().subtract(const Duration(days: 1));
                    final filteredConsumptions =
                    food.consumptions.where((c) {
                      DateTime consumptionDate =
                          DateTime.tryParse(c.date) ?? DateTime.now();
                      return consumptionDate.year == yesterday.year &&
                          consumptionDate.month == yesterday.month &&
                          consumptionDate.day == yesterday.day;
                    }).toList();

                    if (filteredConsumptions.isEmpty) {
                      return const SizedBox.shrink(
                        child: Text("No meals yesterday",style: TextStyle(fontSize: 16,color: Colors.black),),
                      ); // skip if no meals yesterday
                    }

                    // Build text for yesterday’s consumptions
                    String consumptionText =
                    filteredConsumptions.map((c) {
                      double foodCalories =
                          double.tryParse(food.calories) ?? 0;
                      double quantity =
                          double.tryParse(c.foodQuantity) ?? 1;
                      double totalCalories = foodCalories * quantity;
                      return "${c.foodQuantity} Foods    ${totalCalories.toStringAsFixed(0)} kcal";
                    }).join("\n");

                    return CustomListTile(
                      title: food.foodName,
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          food.foodImageUrl ?? 'https://via.placeholder.com/60',
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.fastfood, color: Colors.grey),
                          ),
                        ),
                      ),

                      subtitle: consumptionText.isEmpty
                          ? "No consumption entries • ${food.calories} kcal"
                          : consumptionText,
                      trailing: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.arrow_forward_ios),
                      ),
                      tileColor: Color(0xFFFAFAFA),
                    );
                  },
                ),
              );
  }

  Padding TodaysMeals(List<FoodModel> filteredFoods) {
    return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: filteredFoods.length,
                  itemBuilder: (context, index) {
                    final food = filteredFoods[index];

                    // Filter consumptions only from today
                    final today = DateTime.now();
                    final filteredConsumptions =
                    food.consumptions.where((c) {
                      DateTime consumptionDate =
                          DateTime.tryParse(c.date) ?? DateTime.now();
                      return consumptionDate.year == today.year &&
                          consumptionDate.month == today.month &&
                          consumptionDate.day == today.day;
                    }).toList();

                    if (filteredConsumptions.isEmpty) {
                      return const SizedBox.shrink(); // skip foods not eaten today
                    }

                    // Build subtitle text
                    String consumptionText =
                    filteredConsumptions.map((c) {
                      double foodCalories =
                          double.tryParse(food.calories) ?? 0;
                      double quantity =
                          double.tryParse(c.foodQuantity) ?? 1;
                      double totalCalories = foodCalories * quantity;
                      return "${c.foodQuantity} Foods    ${totalCalories.toStringAsFixed(0)} kcal";
                    }).join("\n");

                    return CustomListTile(
                      title: food.foodName,
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          food.foodImageUrl ?? 'https://via.placeholder.com/60',
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.fastfood, color: Colors.grey),
                          ),
                        ),
                      ),

                      subtitle: consumptionText.isEmpty
                          ? "No consumption entries • ${food.calories} kcal"
                          : consumptionText,
                      trailing: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.arrow_forward_ios),
                      ),
                      tileColor: Color(0xFFFAFAFA),
                    );
                  },
                ),
              );
  }

  GestureDetector DinnerToggleButton() {
    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = 3;
                        });
                      },
                      child: Container(
                        height: 35,
                        width: 70,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: selectedIndex == 3
                              ? const LinearGradient(
                            colors: [
                              Color(0xFF5AFF15),
                              Color(0xFF00B712),
                            ],
                          )
                              : null,
                          color: selectedIndex == 3 ? null : Colors.white,
                        ),
                        child: Text(
                          "Dinner",
                          style: TextStyle(
                            color: selectedIndex == 3
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
  }

  GestureDetector LunchToggleButton() {
    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = 2;
                        });
                      },
                      child: Container(
                        height: 35,
                        width: 60,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: selectedIndex == 2
                              ? const LinearGradient(
                            colors: [
                              Color(0xFF5AFF15),
                              Color(0xFF00B712),
                            ],
                          )
                              : null,
                          color: selectedIndex == 2 ? null : Colors.white,
                        ),
                        child: Text(
                          "Lunch",
                          style: TextStyle(
                            color: selectedIndex == 2
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
  }

  GestureDetector BreakfastToggleButton() {
    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = 1;
                        });
                      },
                      child: Container(
                        height: 35,
                        width: 75,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: selectedIndex == 1
                              ? const LinearGradient(
                            colors: [
                              Color(0xFF5AFF15),
                              Color(0xFF00B712),
                            ],
                          )
                              : null,
                          color: selectedIndex == 1 ? null : Colors.white,
                        ),
                        child: Text(
                          "Breakfast",
                          style: TextStyle(
                            color: selectedIndex == 1
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
  }

  GestureDetector AllToggleButton() {
    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = 0;
                        });
                      },
                      child: Container(
                        height: 35,
                        width: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: selectedIndex == 0
                              ? const LinearGradient(
                            colors: [
                              Color(0xFF5AFF15),
                              Color(0xFF00B712),
                            ],
                          )
                              : null,
                          color: selectedIndex == 0 ? null : Colors.white,
                        ),
                        child: Text(
                          "All",
                          style: TextStyle(
                            color: selectedIndex == 0
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
  }
}
