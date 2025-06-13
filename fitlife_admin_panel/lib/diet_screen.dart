import 'dart:io';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'food_screen.dart';
import 'main.dart';

class DietScreen extends StatefulWidget {
  final VoidCallback onUploadPressed;

  const DietScreen({super.key, required this.onUploadPressed ,});

  @override
  State<DietScreen> createState() => _DietScreenState();
}

class _DietScreenState extends State<DietScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 12, left: 12),
                child: Text(
                  "Diets",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("Cody Fisher"),
                        Text("Dashboard Manager"),
                      ],
                    ),
                    Column(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          child: Image.asset("assets/male avatar.png"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Container(
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
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
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
              ),
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
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF5AFF15), Color(0xFF00B712)],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ElevatedButton.icon(
                    onPressed: widget.onUploadPressed,
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
                    icon: Icon(Icons.add, color: Colors.white, weight: 24),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 35),
          DataTable(
            columns: [
              DataColumn(label: Text("Food Image")),
              DataColumn(label: Text("Food Name")),
              DataColumn(label: Text("Food Quantity")),
              DataColumn(label: Text("Food Unit")),
              DataColumn(label: Text("Calories Per Serving")),
              DataColumn(label: Text("Food Tag")),
              DataColumn(label: Text("Actions")),
            ],
            rows:
                globalFoodMap.entries.map((entry) {
                  final food = entry.value;

                  return DataRow(
                    cells: [
                      DataCell(
                        food['image'] != ''
                            ? (kIsWeb
                                ? Image.network(
                                  food['image'],
                                  width: 60,
                                  height: 60,
                                )
                                : Image.file(
                                  File(food['image']),
                                  width: 60,
                                  height: 60,
                                ))
                            : Icon(Icons.image),
                      ),
                      DataCell(Text(food['foodName'] ?? '')),
                      DataCell(Text(food['quantity'] ?? "")),
                      DataCell(Text(food['unit'] ?? "")),
                      DataCell(Text(food['calories'] ?? "")),
                      DataCell(Text(food['tag'] ?? '')),
                      DataCell(
                        PopupMenuButton<String>(
                          icon: Icon(Icons.more_vert_outlined),
                          offset: Offset(100, 0),
                          onSelected: (String value) {
                            if (value == 'form') {

                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => FoodScreen(foodData: food,)),
                              );
                            }
                          },
                          itemBuilder: (BuildContext context) => [
                            const PopupMenuItem<String>(
                              value: 'form',
                              child: Text('Form'),
                            ),
                          ],
                        ),
                      ),

                    ],
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }
}
