import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'upload_diet_screen.dart';

class DietScreen extends StatefulWidget {
  final VoidCallback onUploadPressed;

  const DietScreen({super.key, required this.onUploadPressed});

  @override
  State<DietScreen> createState() => _DietScreenState();
}

class _DietScreenState extends State<DietScreen> {
  int selectedToggleIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeDefaultDietData();
  }

  void _initializeDefaultDietData() {
    if (globalDietMap.isEmpty) {
      globalDietMap = {
        '1': {
          'image': 'assets/BalancedDiet.jpg',
          'dietTitle': 'Balanced Diet',
          'mealSuitability': 'All Ages',
          'mealTag': 'General',
          'createdBy': 'Admin',
        },
        '2': {
          'image': 'assets/KetoPlan.jpeg',
          'dietTitle': 'Keto Plan',
          'mealSuitability': 'Adults',
          'mealTag': 'Low Carb',
          'createdBy': 'Nutritionist Team',
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
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ToggleButtons(
                    isSelected: [
                      selectedToggleIndex == 0,
                      selectedToggleIndex == 1,
                    ],
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
                      _buildToggleButton("All Diets", selectedToggleIndex == 0),
                      _buildToggleButton(
                        "New Uploads",
                        selectedToggleIndex == 1,
                      ),
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

            Text(
              "Diet List",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),

            // Card(
            //   elevation: 2,
            //   shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.circular(12),
            //   ),
            //   child: DataTable(
            //     headingRowColor: WidgetStateProperty.all(Colors.grey[200]),
            //     headingTextStyle: TextStyle(fontWeight: FontWeight.bold),
            //     border: TableBorder.all(color: Colors.grey.shade300),
            //     columns: [
            //       DataColumn(label: Text("Diet Image")),
            //       DataColumn(label: Text("Diet Name")),
            //       DataColumn(label: Text("Suitable For")),
            //       DataColumn(label: Text("Diet Tag")),
            //       DataColumn(label: Text("Created By")),
            //       DataColumn(label: Text("Actions")),
            //     ],
            //     rows:
            //         globalDietMap.entries.map((entry) {
            //           final diet = entry.value;
            //
            //           return DataRow(
            //             cells: [
            //               DataCell(
            //                 diet['image'] != ''
            //                     ? (kIsWeb
            //                         ? Image.network(
            //                           diet['image'],
            //                           width: 60,
            //                           height: 60,
            //                         )
            //                         : Image.file(
            //                           File(diet['image']),
            //                           width: 60,
            //                           height: 60,
            //                         ))
            //                     : Icon(Icons.image),
            //               ),
            //               DataCell(Text(diet['dietTitle'] ?? '')),
            //               DataCell(Text(diet['mealSuitability'] ?? '')),
            //               DataCell(Text(diet['mealTag'] ?? '')),
            //               DataCell(Text(diet['createdBy'] ?? '')),
            //               DataCell(
            //                 PopupMenuButton<String>(
            //                   icon: Icon(Icons.more_vert_outlined),
            //                   offset: Offset(100, 0),
            //                   onSelected: (value) {
            //                     if (value == 'form') {
            //                       Navigator.push(
            //                         context,
            //                         MaterialPageRoute(
            //                           builder:
            //                               (context) =>
            //                                   UploadDietScreen(dietData: diet),
            //                         ),
            //                       );
            //                     }
            //                   },
            //                   itemBuilder:
            //                       (context) => [
            //                         const PopupMenuItem(
            //                           value: 'form',
            //                           child: Text('Form'),
            //                         ),
            //                       ],
            //                 ),
            //               ),
            //             ],
            //           );
            //         }).toList(),
            //   ),
            // ),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('diet').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text("No diet data found."),
                    );
                  }

                  final docs = snapshot.data!.docs;

                  return DataTable(
                    headingRowColor: WidgetStateProperty.all(Colors.grey[200]),
                    headingTextStyle: TextStyle(fontWeight: FontWeight.bold),
                    border: TableBorder.all(color: Colors.grey.shade300),
                    columns: const [
                      DataColumn(label: Text("Diet Image")),
                      DataColumn(label: Text("Diet Name")),
                      DataColumn(label: Text("Suitable For")),
                      DataColumn(label: Text("Diet Tag")),
                      DataColumn(label: Text("Created By")),
                      DataColumn(label: Text("Actions")),
                    ],
                    rows:
                        docs.map((doc) {
                          final diet = doc.data() as Map<String, dynamic>;

                          return DataRow(
                            cells: [
                              DataCell(
                                diet['image'] != null && diet['image'] != ''
                                    ? (kIsWeb
                                        ? Image.network(
                                          diet['image'],
                                          width: 60,
                                          height: 60,
                                        )
                                        : Image.file(
                                          File(diet['image']),
                                          width: 60,
                                          height: 60,
                                        ))
                                    : Icon(Icons.image),
                              ),
                              DataCell(Text(diet['dietTitle'] ?? '')),
                              DataCell(Text(diet['suitableFor'] ?? '')),
                              DataCell(Text(diet['tag'] ?? '')),
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
                                          builder:
                                              (context) => UploadDietScreen(
                                                dietData: diet,
                                              ),
                                        ),
                                      );
                                    }
                                  },
                                  itemBuilder:
                                      (context) => const [
                                        PopupMenuItem(
                                          value: 'form',
                                          child: Text('Form'),
                                        ),
                                      ],
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                  );
                },
              ),
            ),

            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButton(String text, bool selected) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        gradient:
            selected
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
