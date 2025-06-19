import 'dart:io';
import 'package:fitlife_admin_panel/upload_food_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class FoodScreen extends StatefulWidget {
  final VoidCallback? onUploadPressed;
  const FoodScreen({super.key , this.onUploadPressed});

  @override
  State<FoodScreen> createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {
  int selectedToggleIndex = 0;
  @override
  void initState() {
    super.initState();
    _initializeDefaultFoodData();
  }
  void _initializeDefaultFoodData() {
    if (globalFoodMap.isEmpty) {
      globalFoodMap = {
        '1': {
          'image': 'assets/Brown Rice.jpeg',
          'foodName': 'Brown Rice',
          'quantity': '100',
          'unit': 'grams',
          'calories': '112',
          'tag': 'Carbs',
        },
        '2': {
          'image': 'assets/Grilled Salmon.jpeg',
          'foodName': 'Grilled Salmon',
          'quantity': '150',
          'unit': 'grams',
          'calories': '208',
          'tag': 'Protein',
        },
      };
    }
  }
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
                  "Foods",
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
                    borderRadius: BorderRadius.circular(8),

                  ),
                  child: ToggleButtons(
                    isSelected: [selectedToggleIndex == 0, selectedToggleIndex == 1],
                    onPressed: (index) {
                      setState(() {
                        selectedToggleIndex = index;
                      });
                    },
                    fillColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    borderColor: Colors.transparent,
                    selectedColor: Colors.white,
                    color: Colors.green.shade900,
                    borderRadius: BorderRadius.circular(8),
                    renderBorder: false,
                    children: [
                      _buildToggleButton("All Foods", selectedToggleIndex == 0),
                      _buildToggleButton("New Uploads", selectedToggleIndex == 1),
                    ],
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
                      "Upload Food",
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
            Text("Food List", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(Colors.grey[200]),
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
                                builder: (context) => UploadFoodScreen(foodData: food,),
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
  Widget _buildToggleButton(String text, bool selected) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        gradient: selected
            ? LinearGradient(colors: [Color(0xFF5AFF15), Color(0xFF00B712)])
            : null,
        color: selected ? null : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: selected ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
