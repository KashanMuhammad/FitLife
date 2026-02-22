import 'package:cloud_firestore/cloud_firestore.dart';
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
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

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

  /// ✅ Check if diet was created today
  bool _isCreatedToday(String? createdAt) {
    if (createdAt == null || createdAt.isEmpty) return false;

    try {
      final createdDate = DateTime.parse(createdAt);
      final now = DateTime.now();

      return createdDate.year == now.year &&
          createdDate.month == now.month &&
          createdDate.day == now.day;
    } catch (e) {
      return false;
    }
  }

  /// ✅ Filter diets by toggle + search
  List<QueryDocumentSnapshot> _filterDiets(List<QueryDocumentSnapshot> docs) {
    List<QueryDocumentSnapshot> filtered = docs;

    // 🔹 New Uploads toggle (today only)
    if (selectedToggleIndex == 1) {
      filtered =
          filtered.where((doc) {
            final diet = doc.data() as Map<String, dynamic>;
            return _isCreatedToday(diet['createdAt']);
          }).toList();
    }

    // 🔹 Search filter
    if (_searchQuery.isEmpty) return filtered;

    final searchLower = _searchQuery.toLowerCase();

    return filtered.where((doc) {
      final diet = doc.data() as Map<String, dynamic>;

      final dietTitle = (diet['dietTitle'] ?? '').toString().toLowerCase();
      final createdBy = (diet['createdBy'] ?? '').toString().toLowerCase();
      final tag = (diet['tag'] ?? '').toString().toLowerCase();
      final suitableFor = (diet['suitableFor'] ?? '').toString().toLowerCase();

      return dietTitle.contains(searchLower) ||
          createdBy.contains(searchLower) ||
          tag.contains(searchLower) ||
          suitableFor.contains(searchLower);
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
                const Text(
                  "Diets",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                const Spacer(),
                Row(
                  children: const [
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
            const Divider(height: 20),

            /// 🔹 Toggle + Search + Upload
            Row(
              children: [
                ToggleButtons(
                  isSelected: [
                    selectedToggleIndex == 0,
                    selectedToggleIndex == 1,
                  ],
                  onPressed: (index) {
                    setState(() {
                      selectedToggleIndex = index;
                    });
                  },
                  hoverColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  renderBorder: false,
                  fillColor: Colors.transparent,
                  children: [
                    _buildToggleButton("All Diets", selectedToggleIndex == 0),
                    _buildToggleButton("New Uploads", selectedToggleIndex == 1),
                  ],
                ),
                const Spacer(),
                SizedBox(
                  width: 250,
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: "Search by diet name, tag, or creator",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      suffixIcon:
                          _searchQuery.isNotEmpty
                              ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  setState(() {
                                    _searchController.clear();
                                    _searchQuery = '';
                                  });
                                },
                              )
                              : null,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 15),

                Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF5AFF15), Color(0xFF00B712)],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ElevatedButton.icon(
                    onPressed: widget.onUploadPressed,
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text(
                      "Upload Diet",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(0, 52), // 🔥 height = 52
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

            const SizedBox(height: 25),
            const Text(
              "Diet List",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            /// 🔹 Data Table
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
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text("No diet data found."),
                    );
                  }

                  final filteredDocs = _filterDiets(snapshot.data!.docs);

                  if (filteredDocs.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: Text("No diets found")),
                    );
                  }

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.all(
                        Colors.grey[200],
                      ),
                      columns: const [
                        DataColumn(label: Text("Diet Image")),
                        DataColumn(label: Text("Diet Name")),
                        DataColumn(label: Text("Suitable For")),
                        DataColumn(label: Text("Diet Tag")),
                        DataColumn(label: Text("Created By")),
                        DataColumn(label: Text("Actions")),
                      ],
                      rows:
                          filteredDocs.map((doc) {
                            final diet = doc.data() as Map<String, dynamic>;
                            return DataRow(
                              cells: [
                                DataCell(
                                  diet['dietImageUrl'] != null &&
                                          diet['dietImageUrl'] != ''
                                      ? Image.network(
                                        diet['dietImageUrl'],
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover,
                                      )
                                      : const Text(
                                        "No image",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                ),
                                DataCell(Text(diet['dietTitle'] ?? '')),
                                DataCell(Text(diet['suitableFor'] ?? '')),
                                DataCell(Text(diet['tag'] ?? '')),
                                DataCell(Text(diet['createdBy'] ?? '')),
                                DataCell(
                                  PopupMenuButton<String>(
                                    onSelected: (value) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (_) => UploadDietScreen(
                                                dietId: doc.id,
                                                dietData:
                                                    doc.data()
                                                        as Map<
                                                          String,
                                                          dynamic
                                                        >, // full data including weeklyMeals
                                              ),
                                        ),
                                      );
                                    },
                                    itemBuilder:
                                        (_) => const [
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
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildToggleButton(String text, bool selected) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
    decoration: BoxDecoration(
      gradient:
          selected
              ? const LinearGradient(
                colors: [Color(0xFF5AFF15), Color(0xFF00B712)],
              )
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
