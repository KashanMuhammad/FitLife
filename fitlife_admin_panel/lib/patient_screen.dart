import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  int selectedToggleIndex = 0;
  late Future<List<Map<String, dynamic>>> _userFuture;
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _userFuture = _getAllUsers();
  }

  Future<List<Map<String, dynamic>>> _getAllUsers() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('Users').get();

    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return data;
    }).toList();
  }

  Future<void> _assignDietPlan(String userId, String selectedPlanTitle) async {
    final firestore = FirebaseFirestore.instance;

    final dietSnapshot =
        await firestore
            .collection('diet')
            .where('dietTitle', isEqualTo: selectedPlanTitle)
            .limit(1)
            .get();

    if (dietSnapshot.docs.isEmpty) return;

    final dietDoc = dietSnapshot.docs.first;
    final dietData = dietDoc.data();

    final assignedDiet = {
      'dietId': dietDoc.id,
      'dietTitle': dietData['dietTitle'] ?? '',
      'dietDescription': dietData['dietDescription'] ?? '',
      'duration': dietData['duration'] ?? '',
      'suitableFor': dietData['suitableFor'] ?? '',
      'selectedMealType': dietData['selectedMealType'] ?? '',
    };

    final List<Map<String, dynamic>> assignedFoods = [];
    final Set<String> added = {};

    final weeklyMeals = Map<String, dynamic>.from(dietData['weeklyMeals']);

    for (final day in weeklyMeals.entries) {
      for (final meal in List.from(day.value)) {
        // Foods to Eat
        for (final food in List.from(meal['foodsToEat'] ?? [])) {
          final key = '${day.key}_${meal['mealName']}_eat_$food'.toLowerCase();

          if (!added.contains(key)) {
            assignedFoods.add({
              'day': day.key,
              'meal': meal['mealName'],
              'foodName': food,
              'type': 'eat',
            });
            added.add(key);
          }
        }

        // Foods to Avoid
        for (final food in List.from(meal['foodsToAvoid'] ?? [])) {
          final key =
              '${day.key}_${meal['mealName']}_avoid_$food'.toLowerCase();

          if (!added.contains(key)) {
            assignedFoods.add({
              'day': day.key,
              'meal': meal['mealName'],
              'foodName': food,
              'type': 'avoid',
            });
            added.add(key);
          }
        }
      }
    }

    await firestore.collection('Users').doc(userId).update({
      'assignedDietPlan': assignedDiet,
      'assignedFoods': assignedFoods,
    });

    debugPrint('✅ Total assigned foods: ${assignedFoods.length}');
  }

  Future<void> fetchAllUserDietTitles() async {
    final snapshot = await FirebaseFirestore.instance.collection('Users').get();

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final dietPlan = data['assignedDietPlan'] as Map<String, dynamic>?;

      final dietTitle = dietPlan?['dietTitle'] ?? 'No diet assigned';
    }
  }

  // Filter users based on search query
  List<QueryDocumentSnapshot> _filterUsers(List<QueryDocumentSnapshot> docs) {
    if (_searchQuery.isEmpty) {
      return docs;
    }

    return docs.where((doc) {
      final patient = doc.data() as Map<String, dynamic>;
      final username = (patient['username'] ?? '').toString().toLowerCase();
      return username.contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                const Text(
                  "Patients",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                const Spacer(),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: const [
                        Text("Cody Fisher"),
                        Text("Dashboard Manager"),
                      ],
                    ),
                    const SizedBox(width: 10),
                    const CircleAvatar(
                      radius: 24,
                      backgroundImage: AssetImage("assets/male avatar.png"),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
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
                      selectedToggleIndex == 2,
                      selectedToggleIndex == 3,
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
                      _buildToggleButton(
                        "All Status",
                        selectedToggleIndex == 0,
                      ),
                      _buildToggleButton("Active", selectedToggleIndex == 1),
                      _buildToggleButton(
                        "Non Active",
                        selectedToggleIndex == 2,
                      ),
                      _buildToggleButton("Blocked", selectedToggleIndex == 3),
                    ],
                  ),
                ),
                Spacer(),
                SizedBox(
                  width: 250,
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: "Search by patient name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      suffixIcon:
                          _searchQuery.isNotEmpty
                              ? IconButton(
                                icon: Icon(Icons.clear),
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
                Container(
                  margin: const EdgeInsets.all(8),
                  child: Material(
                    elevation: 1,
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.filter_alt_outlined,
                          color: Colors.green,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('Users').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text("No patient data found."),
                    );
                  }

                  final docs = snapshot.data!.docs;
                  final filteredDocs = _filterUsers(docs);

                  if (filteredDocs.isEmpty && _searchQuery.isNotEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Icon(Icons.search_off, size: 50, color: Colors.grey),
                          SizedBox(height: 10),
                          Text(
                            "No patients found for '$_searchQuery'",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.all(
                        Colors.grey[200],
                      ),
                      headingTextStyle: TextStyle(fontWeight: FontWeight.bold),
                      border: TableBorder.all(color: Colors.grey.shade300),
                      columns: const [
                        DataColumn(label: Text("Patient Image")),
                        DataColumn(label: Text("Patient Name")),
                        DataColumn(label: Text("Patient Weight")),
                        DataColumn(label: Text("Patient Height")),
                        DataColumn(label: Text('Plan Suitability')),
                        DataColumn(label: Text("Assigned Diet Plan")),
                        DataColumn(label: Text("Actions")),
                      ],
                      rows:
                          filteredDocs.map((doc) {
                            final patient = doc.data() as Map<String, dynamic>;
                            final patientId = doc.id;
                            return DataRow(
                              cells: [
                                DataCell(
                                  patient['image'] != null &&
                                          patient['image'] != ''
                                      ? (kIsWeb
                                          ? Center(
                                            child: Image.network(
                                              patient['image'],
                                              width: 60,
                                              height: 60,
                                            ),
                                          )
                                          : Center(
                                            child: Image.file(
                                              File(patient['image']),
                                              width: 60,
                                              height: 60,
                                            ),
                                          ))
                                      : Center(child: Icon(Icons.image)),
                                ),
                                DataCell(
                                  Center(
                                    child: Text(
                                      patient['username'] ?? 'No User Name',
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Center(
                                    child: Text(
                                      "${patient['weight'] ?? ''} ${patient['weightUnit'] ?? 'No User Weight'}",
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Center(
                                    child: Text(
                                      "${patient['height'] ?? ''} ${patient['heightUnit'] ?? 'No User Height'}",
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Center(
                                    child: Text(
                                      (patient['assignedDietPlan'] != null &&
                                              patient['assignedDietPlan']['suitableFor'] !=
                                                  null)
                                          ? patient['assignedDietPlan']['suitableFor']
                                          : 'No Suitability Entered',
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Center(
                                    child: Text(
                                      (patient['assignedDietPlan'] != null &&
                                              patient['assignedDietPlan']['dietTitle'] !=
                                                  null)
                                          ? patient['assignedDietPlan']['dietTitle']
                                          : 'No Diet Assigned',
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Center(
                                    child: PopupMenuButton<String>(
                                      icon: const Icon(
                                        Icons.more_vert_outlined,
                                      ),
                                      offset: const Offset(100, 0),
                                      onSelected: (value) async {
                                        if (value == 'block') {
                                        } else if (value == 'delete') {
                                          // 🔹 Delete user from Firestore
                                          await FirebaseFirestore.instance
                                              .collection('Users')
                                              .doc(patientId)
                                              .delete();

                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                "User deleted successfully",
                                              ),
                                            ),
                                          );
                                        } else if (value == 'dietPlan') {
                                          // 🔹 Fetch all diet plans
                                          final snapshot =
                                              await FirebaseFirestore.instance
                                                  .collection('diet')
                                                  .get();

                                          final List<String> dietPlans =
                                              snapshot.docs
                                                  .map(
                                                    (doc) =>
                                                        doc['dietTitle']
                                                            .toString(),
                                                  )
                                                  .toSet()
                                                  .toList();

                                          String? selectedPlan;
                                          bool isLoading = false;

                                          // 🔹 Show dialog to pick diet plan
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              String? selectedPlan;
                                              bool isLoading = false;

                                              return StatefulBuilder(
                                                builder: (context, setState) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                      'Assign Diet Plan',
                                                    ),
                                                    content: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        DropdownButton<String>(
                                                          isExpanded: true,
                                                          value: selectedPlan,
                                                          hint: const Text(
                                                            'Choose a diet plan',
                                                          ),
                                                          items:
                                                              dietPlans.map((
                                                                plan,
                                                              ) {
                                                                return DropdownMenuItem<
                                                                  String
                                                                >(
                                                                  value: plan,
                                                                  child: Text(
                                                                    plan,
                                                                  ),
                                                                );
                                                              }).toList(),
                                                          onChanged: (value) {
                                                            setState(() {
                                                              selectedPlan =
                                                                  value;
                                                            });
                                                          },
                                                        ),
                                                        if (isLoading)
                                                          const Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                  top: 20,
                                                                ),
                                                            child:
                                                                CircularProgressIndicator(),
                                                          ),
                                                      ],
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () async {
                                                          if (selectedPlan !=
                                                              null) {
                                                            setState(() {
                                                              isLoading = true;
                                                            });

                                                            await _assignDietPlan(
                                                              patientId,
                                                              selectedPlan!,
                                                            );

                                                            setState(() {
                                                              isLoading = false;
                                                            });

                                                            Navigator.of(
                                                              context,
                                                            ).pop();

                                                            ScaffoldMessenger.of(
                                                              context,
                                                            ).showSnackBar(
                                                              const SnackBar(
                                                                content: Text(
                                                                  'Diet plan assigned successfully',
                                                                ),
                                                              ),
                                                            );
                                                          } else {
                                                            Navigator.of(
                                                              context,
                                                            ).pop();
                                                          }
                                                        },
                                                        child: const Text(
                                                          'Assign',
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                          );
                                        }
                                      },
                                      itemBuilder:
                                          (context) => const [
                                            PopupMenuItem(
                                              value: 'block',
                                              child: Text('Block'),
                                            ),
                                            PopupMenuItem(
                                              value: 'delete',
                                              child: Text('Delete'),
                                            ),
                                            PopupMenuItem(
                                              value: 'dietPlan',
                                              child: Text('Add Diet Plan'),
                                            ),
                                          ],
                                    ),
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
