import 'package:fitlife_app/custom%20widgets/add_meals_tile.dart';
import 'package:fitlife_app/custom%20widgets/summary_meals_tile.dart';
import 'package:flutter/material.dart';

class AddMealsSummaryScreen extends StatefulWidget {
  const AddMealsSummaryScreen({super.key});

  @override
  State<AddMealsSummaryScreen> createState() => _AddMealsScreenState();
}

class _AddMealsScreenState extends State<AddMealsSummaryScreen> {
  String selectedMealType = 'Breakfast';
  List<String> mealTypes = ['Breakfast', 'Lunch', 'Dinner'];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.arrow_back_ios),
                    ),
                    const SizedBox(width: 20),
                    const Expanded(
                      child: Text(
                        "Add Meals",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 48), // To balance IconButton space
                  ],
                ),

                const SizedBox(height: 20),

                // Search + Dropdown
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search, color: Colors.greenAccent),
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
                    const SizedBox(width: 12),
                    Container(
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
                          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
                          style: const TextStyle(color: Colors.white),
                          items: mealTypes.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value, style: const TextStyle(color: Colors.white)),
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

                const Text(
                  'Breakfast',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 10),

                // Summary meal tiles
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    SummaryMealsTile(
                      itemName: "Bred",
                      kcal: "250",
                      width: (screenWidth - 34) / 2,
                    ),
                    SummaryMealsTile(
                      itemName: "Bred",
                      kcal: "250",
                      width: (screenWidth - 34) / 2,
                    ),


                  ],
                ),
                SummaryMealsTile(
                  itemName: "Bred",
                  kcal: "250",
                  width: (screenWidth - 34) / 2,
                ),
                SizedBox(
                  height: 10,
                ),
                const Divider( thickness: 2),
                SizedBox(
                  height: 14,
                ),
                const Text(
                  'Items',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
