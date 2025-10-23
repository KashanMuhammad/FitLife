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

  /// 🔹 Assign diet plan with full details + foods
  Future<void> _assignDietPlan(String userId, String selectedPlanTitle) async {
    final firestore = FirebaseFirestore.instance;

    // 1. Get diet document
    final dietSnapshot =
        await firestore
            .collection('diet')
            .where('dietTitle', isEqualTo: selectedPlanTitle)
            .limit(1)
            .get();

    if (dietSnapshot.docs.isEmpty) return;
    final dietDoc = dietSnapshot.docs.first;
    final dietData = dietDoc.data();

    // 2. Extract diet details (KEEP original types)
    final assignedDiet = {
      'dietId': dietDoc.id,
      'dietTitle': dietData['dietTitle'] ?? '',
      'dietDescription': dietData['dietDescription'] ?? '',
      'duration': dietData['duration'] ?? 0, // can be int or string
      'suitableFor': dietData['suitableFor'] ?? '',
      'selectedMealType': dietData['selectedMealType'] ?? '',
    };

    // 3. Fetch all foods with full details
    List<Map<String, dynamic>> foods = [];
    if (dietData.containsKey('listOfFood')) {
      for (var foodName in List.from(dietData['listOfFood'])) {
        final foodSnap =
            await firestore
                .collection('food')
                .where('foodName', isEqualTo: foodName.toString())
                .limit(1)
                .get();

        if (foodSnap.docs.isNotEmpty) {
          final foodDoc = foodSnap.docs.first;
          final foodData = foodDoc.data();

          foods.add({
            'foodId': foodDoc.id,
            ...foodData, 
          });
        }
      }
    }

    // 4. Save diet + foods in User doc
    await firestore.collection('Users').doc(userId).update({
      'assignedDietPlan': assignedDiet,
      'assignedFoods': foods,
    });
  }

  Future<void> fetchAllUserDietTitles() async {
    final snapshot = await FirebaseFirestore.instance.collection('Users').get();

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final dietPlan = data['assignedDietPlan'] as Map<String, dynamic>?;

      final dietTitle = dietPlan?['dietTitle'] ?? 'No diet assigned';
    }
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
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: "Search",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
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
                      onTap: () {
                        
                      },
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
                          docs.map((doc) {
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

                                // DataCell(
                                //   PopupMenuButton<String>(
                                //     icon: Icon(Icons.more_vert_outlined),
                                //     offset: Offset(100, 0),
                                //     onSelected: (value) {
                                //       if (value == 'form') {
                                //         Navigator.push(
                                //           context,
                                //           MaterialPageRoute(
                                //             builder:
                                //                 (context) => UploadDietScreen(
                                //               dietId: patientId,
                                //               dietData: patient,
                                //             ),
                                //           ),
                                //         );
                                //       }
                                //     },
                                //     itemBuilder:
                                //         (context) => const [
                                //       PopupMenuItem(
                                //         value: 'form',
                                //         child: Text('Form'),
                                //       ),
                                //     ],
                                //   ),
                                // ),
                              ],
                            );
                          }).toList(),
                    ),
                  );
                },
              ),
            ),
            // User Grid
            // FutureBuilder<List<Map<String, dynamic>>>(
            //   future: _userFuture,
            //   builder: (context, snapshot) {
            //     if (snapshot.connectionState == ConnectionState.waiting) {
            //       return const Padding(
            //         padding: EdgeInsets.only(top: 50),
            //         child: Center(child: CircularProgressIndicator()),
            //       );
            //     }
            //
            //     if (snapshot.hasError) {
            //       return const Text("Error loading users");
            //     }
            //
            //     final users = snapshot.data;
            //
            //     if (users == null || users.isEmpty) {
            //       return const Text("No users found.");
            //     }
            //
            //     return GridView.builder(
            //       shrinkWrap: true,
            //       physics: const NeverScrollableScrollPhysics(),
            //       padding: const EdgeInsets.only(top: 20),
            //       itemCount: users.length,
            //       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            //         crossAxisCount: 6,
            //         crossAxisSpacing: 12,
            //         mainAxisSpacing: 12,
            //         childAspectRatio: 0.8,
            //       ),
            //       itemBuilder: (context, index) {
            //         final user = users[index];
            //
            //         return Card(
            //           shape: RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(12),
            //           ),
            //           elevation: 3,
            //           child: Padding(
            //             padding: const EdgeInsets.all(6.0),
            //             child: Column(
            //               children: [
            //                 // Popup menu
            //                 Align(
            //                   alignment: Alignment.topRight,
            //                   child: PopupMenuButton<String>(
            //                     icon: const Icon(Icons.more_vert, size: 20),
            //                     onSelected: (value) async {
            //                       if (value == 'dietPlan') {
            //                         final snapshot =
            //                         await FirebaseFirestore.instance
            //                             .collection('diet')
            //                             .get();
            //
            //                         final List<String> dietPlans = snapshot.docs
            //                             .map((doc) =>
            //                             doc['dietTitle'].toString())
            //                             .toSet()
            //                             .toList();
            //
            //                         String? selectedPlan;
            //
            //                         showDialog(
            //                           context: context,
            //                           builder: (context) {
            //                             return AlertDialog(
            //                               title: const Text('Assign Diet Plan'),
            //                               content: StatefulBuilder(
            //                                 builder: (context, setState) {
            //                                   return DropdownButton<String>(
            //                                     isExpanded: true,
            //                                     value: selectedPlan,
            //                                     hint: const Text(
            //                                       'Choose a diet plan',
            //                                     ),
            //                                     items: dietPlans.map((plan) {
            //                                       return DropdownMenuItem<
            //                                           String>(
            //                                         value: plan,
            //                                         child: Text(plan),
            //                                       );
            //                                     }).toList(),
            //                                     onChanged: (value) {
            //                                       setState(() {
            //                                         selectedPlan = value;
            //                                       });
            //                                     },
            //                                   );
            //                                 },
            //                               ),
            //                               actions: [
            //                                 TextButton(
            //                                   onPressed: () async {
            //                                     if (selectedPlan != null) {
            //                                       await _assignDietPlan(
            //                                           user['id'], selectedPlan!);
            //
            //                                       Navigator.of(context).pop();
            //
            //                                       ScaffoldMessenger.of(
            //                                         context,
            //                                       ).showSnackBar(
            //                                         const SnackBar(
            //                                           content: Text(
            //                                             'Diet plan assigned successfully',
            //                                           ),
            //                                         ),
            //                                       );
            //
            //                                       setState(() {
            //                                         _userFuture =
            //                                             _getAllUsers();
            //                                       });
            //                                     } else {
            //                                       Navigator.of(context).pop();
            //                                     }
            //                                   },
            //                                   child: const Text('Assign'),
            //                                 ),
            //                               ],
            //                             );
            //                           },
            //                         );
            //                       }
            //                     },
            //                     itemBuilder: (context) => const [
            //                       PopupMenuItem(
            //                         value: 'deleteUser',
            //                         child: Text('Delete User'),
            //                       ),
            //                       PopupMenuItem(
            //                         value: 'blockUser',
            //                         child: Text('Block User'),
            //                       ),
            //                       PopupMenuItem(
            //                         value: 'dietPlan',
            //                         child: Text('Diet Plan'),
            //                       ),
            //                     ],
            //                   ),
            //                 ),
            //
            //                 // User image
            //                 ClipRRect(
            //                   borderRadius: BorderRadius.circular(12),
            //                   child: Image.asset(
            //                     'assets/male avatar.png',
            //                     height: 40,
            //                     width: 40,
            //                   ),
            //                 ),
            //
            //                 const SizedBox(height: 6),
            //
            //                 // Username
            //                 Text(
            //                   user['username']?.toString() ?? 'No Name',
            //                   textAlign: TextAlign.center,
            //                   style: const TextStyle(
            //                     fontWeight: FontWeight.bold,
            //                     fontSize: 14,
            //                   ),
            //                 ),
            //
            //                 const SizedBox(height: 4),
            //
            //                 // Diet info (show diet title if assigned)
            //                 Text(
            //                   (user['assignedDietPlan'] != null &&
            //                       user['assignedDietPlan']['dietTitle'] !=
            //                           null)
            //                       ? 'Plan: ${user['assignedDietPlan']['dietTitle']}'
            //                       : 'No Diet Plan Assigned',
            //                   textAlign: TextAlign.center,
            //                   style: TextStyle(
            //                     fontSize: 12,
            //                     color: Colors.grey[700],
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           ),
            //         );
            //       },
            //     );
            //   },
            // ),
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
