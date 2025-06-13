import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'food_screen.dart';
import 'main.dart';
import 'upload_diet_screen.dart';

class DietScreen extends StatefulWidget {
  final VoidCallback onUploadPressed;

  const DietScreen({super.key, required this.onUploadPressed});

  @override
  State<DietScreen> createState() => _DietScreenState();
}

class _DietScreenState extends State<DietScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Diets",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                Spacer(),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("Cody Fisher"),
                        Text("Dashboard Manager"),
                      ],
                    ),
                    SizedBox(width: 10),
                    CircleAvatar(
                      radius: 24,
                      backgroundImage: AssetImage("assets/male avatar.png"),
                    ),
                  ],
                ),
              ],
            ),
            Divider(height: 20),
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
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      "All Diets",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    "New Uploads",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Spacer(),
                SizedBox(
                  width: 250,
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: "Search",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 15),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF5AFF15), Color(0xFF00B712)],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ElevatedButton.icon(
                    onPressed: widget.onUploadPressed,
                    icon: Icon(Icons.add, color: Colors.white),
                    label: Text(
                      "Upload Diet",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 25),
            Text("Food List", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: DataTable(
                headingRowColor: MaterialStateProperty.all(Colors.grey[200]),
                headingTextStyle: TextStyle(fontWeight: FontWeight.bold),
                border: TableBorder.all(color: Colors.grey.shade300),
                columns: [
                  DataColumn(label: Text("Food Image")),
                  DataColumn(label: Text("Food Name")),
                  DataColumn(label: Text("Food Quantity")),
                  DataColumn(label: Text("Food Unit")),
                  DataColumn(label: Text("Calories Per Serving")),
                  DataColumn(label: Text("Food Tag")),
                  DataColumn(label: Text("Actions")),
                ],
                rows: globalFoodMap.entries.map((entry) {
                  final food = entry.value;

                  return DataRow(cells: [
                    DataCell(
                      food['image'] != ''
                          ? (kIsWeb
                          ? Image.network(food['image'], width: 60, height: 60)
                          : Image.file(File(food['image']), width: 60, height: 60))
                          : Icon(Icons.image),
                    ),
                    DataCell(Text(food['foodName'] ?? '')),
                    DataCell(Text(food['quantity'] ?? '')),
                    DataCell(Text(food['unit'] ?? '')),
                    DataCell(Text(food['calories'] ?? '')),
                    DataCell(Text(food['tag'] ?? '')),
                    DataCell(
                      PopupMenuButton<String>(
                        icon: Icon(Icons.more_vert_outlined),
                        offset: Offset(100, 0),
                        onSelected: (value) {
                          if (value == 'form') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FoodScreen(foodData: food),
                              ),
                            );
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(value: 'form', child: Text('Form')),
                        ],
                      ),
                    ),
                  ]);
                }).toList(),
              ),
            ),

            SizedBox(height: 30),
            Text("Diet List", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: DataTable(
                headingRowColor: MaterialStateProperty.all(Colors.grey[200]),
                headingTextStyle: TextStyle(fontWeight: FontWeight.bold),
                border: TableBorder.all(color: Colors.grey.shade300),
                columns: [
                  DataColumn(label: Text("Diet Image")),
                  DataColumn(label: Text("Diet Name")),
                  DataColumn(label: Text("Suitable For")),
                  DataColumn(label: Text("Diet Tag")),
                  DataColumn(label: Text("Created By")),
                  DataColumn(label: Text("Actions")),
                ],
                rows: globalDietMap.entries.map((entry) {
                  final diet = entry.value;

                  return DataRow(cells: [
                    DataCell(
                      diet['image'] != ''
                          ? (kIsWeb
                          ? Image.network(diet['image'], width: 60, height: 60)
                          : Image.file(File(diet['image']), width: 60, height: 60))
                          : Icon(Icons.image),
                    ),
                    DataCell(Text(diet['dietTitle'] ?? '')),
                    DataCell(Text(diet['mealSuitability'] ?? '')),
                    DataCell(Text(diet['mealTag'] ?? '')),
                    DataCell(Text(diet['createdBy'] ?? '')),
                    DataCell(
                      PopupMenuButton<String>(
                        icon: Icon(Icons.more_vert_outlined),
                        offset: Offset(100, 0),
                        onSelected: (value) {
                          if (value == 'form') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UploadDietScreen(dietData: diet),
                              ),
                            );
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(value: 'form', child: Text('Form')),
                        ],
                      ),
                    ),
                  ]);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}