import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitlife_app/custom%20widgets/add_meals_tile.dart';
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
  bool _isLoading= true;
  int selectedIndex = 0;
  final List<String> todaysMeal = ['Bred', 'Bred', 'Bred'];
  final List<String> yesterdayMeal = ['Bred', 'Bred', 'Bred'];
  final List<String> beforeYesterdayMeal = ['Bred', 'Bred', 'Bred'];
@override
void initState(){
  super.initState();
  loadUserData();
}
  Future<void> loadUserData() async {
    const userId = "3UCi7hE0jHNl79r7dIzA3wl0D083";
    try {
      final doc =
      await FirebaseFirestore.instance.collection("Users").doc(userId).get();

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
                      GestureDetector(
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
                            gradient:
                                selectedIndex == 0
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
                              color:
                                  selectedIndex == 0
                                      ? Colors.white
                                      : Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),

                      // Breakfast Button
                      GestureDetector(
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
                            gradient:
                                selectedIndex == 1
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
                              color:
                                  selectedIndex == 1
                                      ? Colors.white
                                      : Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),

                      // Lunch Button
                      GestureDetector(
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
                            gradient:
                                selectedIndex == 2
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
                              color:
                                  selectedIndex == 2
                                      ? Colors.white
                                      : Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
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
                            gradient:
                                selectedIndex == 3
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
                              color:
                                  selectedIndex == 3
                                      ? Colors.white
                                      : Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  "Today Meal",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: foods.length,
                itemBuilder: (context, index) {
                  final food = foods[index];

                  // Create a string of all consumption entries
                  String consumptionText = food.consumptions.map((c) {
                    double foodCalories = double.tryParse(food.calories) ?? 0;
                    double quantity = double.tryParse(c.foodQuantity) ?? 1;
                    double totalCalories = foodCalories * quantity;
                    return "${c.foodQuantity} Foods   (${totalCalories.toStringAsFixed(0)} kcal) on ${c.date.split("T")[0]}";
                  }).join("\n");

                  return CustomListTile(
                    title: food.foodName,
                    leading: Image.asset("assets/images/rectangle.png"),
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
            ),
                SizedBox(height: 15),
                Text(
                  "Yesterday Meal",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: yesterdayMeal.length,
                    itemBuilder: (context, index) {
                      return CustomListTile(
                        title: yesterdayMeal[index],
                        leading: Image.asset("assets/images/rectangle.png"),
                        subtitle: "3 foods 370 kcl",
                        trailing: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.arrow_forward_ios),
                        ),
                        tileColor: Color(0xFFFAFAFA),
                      );
                    },
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  "14-9-2025 Meals",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
                
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: beforeYesterdayMeal.length,
                    itemBuilder: (context, index) {
                      return CustomListTile(
                        title: beforeYesterdayMeal[index],
                        leading: Image.asset("assets/images/rectangle.png"),
                        subtitle: "3 foods 370 kcl",
                        trailing: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.arrow_forward_ios),
                        ),
                        tileColor: Color(0xFFFAFAFA),
                      );
                    },
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
