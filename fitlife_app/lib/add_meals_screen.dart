import 'package:fitlife_app/custom%20widgets/add_meals_tile.dart';
import 'package:flutter/material.dart';

class AddMealsScreen extends StatefulWidget {
  const AddMealsScreen({super.key});

  @override
  State<AddMealsScreen> createState() => _AddMealsScreenState();
}

class _AddMealsScreenState extends State<AddMealsScreen> {
  String selectedMealType = 'Breakfast';
  List<String> mealTypes = ['Breakfast', 'Lunch', 'Dinner'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
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
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.greenAccent,
                          ),
                          hintText: "Search",
                          hintStyle: const TextStyle(color: Colors.greenAccent),
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
                          items:
                              mealTypes.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: const TextStyle(color: Colors.white),
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
                SizedBox(height: 30),
                AddMealsTile(itemName: "Bred", kcal: '3 foods 320 kcl'),
                AddMealsTile(itemName: "Bred", kcal: '3 foods 320 kcl'),
                AddMealsTile(itemName: "Bred", kcal: '3 foods 320 kcl'),
                AddMealsTile(itemName: "Bred", kcal: '3 foods 320 kcl'),
                AddMealsTile(itemName: "Bred", kcal: '3 foods 320 kcl'),
                AddMealsTile(itemName: "Bred", kcal: '3 foods 320 kcl'),
                AddMealsTile(itemName: "Bred", kcal: '3 foods 320 kcl'),
                AddMealsTile(itemName: "Bred", kcal: '3 foods 320 kcl'),
                AddMealsTile(itemName: "Bred", kcal: '3 foods 320 kcl'),
                AddMealsTile(itemName: "Bred", kcal: '3 foods 320 kcl'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
