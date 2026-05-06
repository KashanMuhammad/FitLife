// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
//
// class UserScreen extends StatefulWidget {
//   const UserScreen({super.key});
//
//   @override
//   State<UserScreen> createState() => _UserScreenState();
// }
//
// class _UserScreenState extends State<UserScreen> {
//   int selectedToggleIndex = 0;
//   late Future<List<Map<String, dynamic>>> _userFuture;
//   TextEditingController _searchController = TextEditingController();
//   String _searchQuery = '';
//
//   @override
//   void initState() {
//     super.initState();
//     _userFuture = _getAllUsers();
//   }
//
//   Future<List<Map<String, dynamic>>> _getAllUsers() async {
//     QuerySnapshot snapshot =
//         await FirebaseFirestore.instance.collection('Users').get();
//
//     return snapshot.docs.map((doc) {
//       final data = doc.data() as Map<String, dynamic>;
//       data['id'] = doc.id;
//       return data;
//     }).toList();
//   }
//
//   Future<void> _assignDietPlan(String userId, String selectedPlanTitle) async {
//     final firestore = FirebaseFirestore.instance;
//
//     final dietSnapshot =
//         await firestore
//             .collection('diet')
//             .where('dietTitle', isEqualTo: selectedPlanTitle)
//             .limit(1)
//             .get();
//
//     if (dietSnapshot.docs.isEmpty) return;
//
//     final dietDoc = dietSnapshot.docs.first;
//     final dietData = dietDoc.data();
//
//     final assignedDiet = {
//       'dietId': dietDoc.id,
//       'dietTitle': dietData['dietTitle'] ?? '',
//       'dietDescription': dietData['dietDescription'] ?? '',
//       'duration': dietData['duration'] ?? '',
//       'suitableFor': dietData['suitableFor'] ?? '',
//       'selectedMealType': dietData['selectedMealType'] ?? '',
//     };
//
//     final List<Map<String, dynamic>> assignedFoods = [];
//     final Set<String> added = {};
//
//     final weeklyMeals = Map<String, dynamic>.from(dietData['weeklyMeals']);
//
//     for (final day in weeklyMeals.entries) {
//       for (final meal in List.from(day.value)) {
//         // Foods to Eat
//         for (final food in List.from(meal['foodsToEat'] ?? [])) {
//           final key = '${day.key}_${meal['mealName']}_eat_$food'.toLowerCase();
//
//           if (!added.contains(key)) {
//             assignedFoods.add({
//               'day': day.key,
//               'meal': meal['mealName'],
//               'foodName': food,
//               'type': 'eat',
//             });
//             added.add(key);
//           }
//         }
//
//         // Foods to Avoid
//         for (final food in List.from(meal['foodsToAvoid'] ?? [])) {
//           final key =
//               '${day.key}_${meal['mealName']}_avoid_$food'.toLowerCase();
//
//           if (!added.contains(key)) {
//             assignedFoods.add({
//               'day': day.key,
//               'meal': meal['mealName'],
//               'foodName': food,
//               'type': 'avoid',
//             });
//             added.add(key);
//           }
//         }
//       }
//     }
//
//     await firestore.collection('Users').doc(userId).update({
//       'assignedDietPlan': assignedDiet,
//       'assignedFoods': assignedFoods,
//     });
//
//     debugPrint('✅ Total assigned foods: ${assignedFoods.length}');
//   }
//
//   Future<void> fetchAllUserDietTitles() async {
//     final snapshot = await FirebaseFirestore.instance.collection('Users').get();
//
//     for (var doc in snapshot.docs) {
//       final data = doc.data();
//       final dietPlan = data['assignedDietPlan'] as Map<String, dynamic>?;
//
//       final dietTitle = dietPlan?['dietTitle'] ?? 'No diet assigned';
//     }
//   }
//
//   // Filter users based on search query
//   List<QueryDocumentSnapshot> _filterUsers(List<QueryDocumentSnapshot> docs) {
//     if (_searchQuery.isEmpty) {
//       return docs;
//     }
//
//     return docs.where((doc) {
//       final patient = doc.data() as Map<String, dynamic>;
//       final username = (patient['username'] ?? '').toString().toLowerCase();
//       return username.contains(_searchQuery.toLowerCase());
//     }).toList();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Header
//             Row(
//               children: [
//                 const Text(
//                   "Patients",
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
//                 ),
//                 const Spacer(),
//                 Row(
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: const [
//                         Text("Cody Fisher"),
//                         Text("Dashboard Manager"),
//                       ],
//                     ),
//                     const SizedBox(width: 10),
//                     const CircleAvatar(
//                       radius: 24,
//                       backgroundImage: AssetImage("assets/male avatar.png"),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),
//             Row(
//               children: [
//                 Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: ToggleButtons(
//                     isSelected: [
//                       selectedToggleIndex == 0,
//                       selectedToggleIndex == 1,
//                       selectedToggleIndex == 2,
//                       selectedToggleIndex == 3,
//                     ],
//                     onPressed: (index) {
//                       setState(() {
//                         selectedToggleIndex = index;
//                       });
//                     },
//                     fillColor: Colors.transparent,
//                     splashColor: Colors.transparent,
//                     highlightColor: Colors.transparent,
//                     hoverColor: Colors.transparent,
//                     borderColor: Colors.transparent,
//                     selectedColor: Colors.white,
//                     color: Colors.green.shade900,
//                     borderRadius: BorderRadius.circular(8),
//                     renderBorder: false,
//                     children: [
//                       _buildToggleButton(
//                         "All Status",
//                         selectedToggleIndex == 0,
//                       ),
//                       _buildToggleButton("Active", selectedToggleIndex == 1),
//                       _buildToggleButton(
//                         "Non Active",
//                         selectedToggleIndex == 2,
//                       ),
//                       _buildToggleButton("Blocked", selectedToggleIndex == 3),
//                     ],
//                   ),
//                 ),
//                 Spacer(),
//                 SizedBox(
//                   width: 250,
//                   child: TextField(
//                     controller: _searchController,
//                     decoration: InputDecoration(
//                       prefixIcon: Icon(Icons.search),
//                       hintText: "Search by patient name",
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       suffixIcon:
//                           _searchQuery.isNotEmpty
//                               ? IconButton(
//                                 icon: Icon(Icons.clear),
//                                 onPressed: () {
//                                   setState(() {
//                                     _searchController.clear();
//                                     _searchQuery = '';
//                                   });
//                                 },
//                               )
//                               : null,
//                     ),
//                     onChanged: (value) {
//                       setState(() {
//                         _searchQuery = value;
//                       });
//                     },
//                   ),
//                 ),
//                 Container(
//                   margin: const EdgeInsets.all(8),
//                   child: Material(
//                     elevation: 1,
//                     borderRadius: BorderRadius.circular(12),
//                     color: Colors.white,
//                     child: InkWell(
//                       borderRadius: BorderRadius.circular(12),
//                       onTap: () {},
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Icon(
//                           Icons.filter_alt_outlined,
//                           color: Colors.green,
//                           size: 28,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),
//             Card(
//               elevation: 2,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: StreamBuilder<QuerySnapshot>(
//                 stream:
//                     FirebaseFirestore.instance.collection('Users').snapshots(),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return Center(child: CircularProgressIndicator());
//                   }
//
//                   if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                     return Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Text("No patient data found."),
//                     );
//                   }
//
//                   final docs = snapshot.data!.docs;
//                   final filteredDocs = _filterUsers(docs);
//
//                   if (filteredDocs.isEmpty && _searchQuery.isNotEmpty) {
//                     return Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Column(
//                         children: [
//                           Icon(Icons.search_off, size: 50, color: Colors.grey),
//                           SizedBox(height: 10),
//                           Text(
//                             "No patients found for '$_searchQuery'",
//                             style: TextStyle(color: Colors.grey),
//                           ),
//                         ],
//                       ),
//                     );
//                   }
//
//                   return SingleChildScrollView(
//                     scrollDirection: Axis.horizontal,
//                     child: DataTable(
//                       headingRowColor: WidgetStateProperty.all(
//                         Colors.grey[200],
//                       ),
//                       headingTextStyle: TextStyle(fontWeight: FontWeight.bold),
//                       border: TableBorder.all(color: Colors.grey.shade300),
//                       columns: const [
//                         DataColumn(label: Text("Patient Image")),
//                         DataColumn(label: Text("Patient Name")),
//                         DataColumn(label: Text("Patient Weight")),
//                         DataColumn(label: Text("Patient Height")),
//                         DataColumn(label: Text('Plan Suitability')),
//                         DataColumn(label: Text("Assigned Diet Plan")),
//                         DataColumn(label: Text("Actions")),
//                       ],
//                       rows:
//                           filteredDocs.map((doc) {
//                             final patient = doc.data() as Map<String, dynamic>;
//                             final patientId = doc.id;
//                             return DataRow(
//                               cells: [
//                                 DataCell(
//                                   patient['image'] != null &&
//                                           patient['image'] != ''
//                                       ? (kIsWeb
//                                           ? Center(
//                                             child: Image.network(
//                                               patient['image'],
//                                               width: 60,
//                                               height: 60,
//                                             ),
//                                           )
//                                           : Center(
//                                             child: Image.file(
//                                               File(patient['image']),
//                                               width: 60,
//                                               height: 60,
//                                             ),
//                                           ))
//                                       : Center(child: Icon(Icons.image)),
//                                 ),
//                                 DataCell(
//                                   Center(
//                                     child: Text(
//                                       patient['username'] ?? 'No User Name',
//                                     ),
//                                   ),
//                                 ),
//                                 DataCell(
//                                   Center(
//                                     child: Text(
//                                       "${patient['weight'] ?? ''} ${patient['weightUnit'] ?? 'No User Weight'}",
//                                     ),
//                                   ),
//                                 ),
//                                 DataCell(
//                                   Center(
//                                     child: Text(
//                                       "${patient['height'] ?? ''} ${patient['heightUnit'] ?? 'No User Height'}",
//                                     ),
//                                   ),
//                                 ),
//                                 DataCell(
//                                   Center(
//                                     child: Text(
//                                       (patient['assignedDietPlan'] != null &&
//                                               patient['assignedDietPlan']['suitableFor'] !=
//                                                   null)
//                                           ? patient['assignedDietPlan']['suitableFor']
//                                           : 'No Suitability Entered',
//                                     ),
//                                   ),
//                                 ),
//                                 DataCell(
//                                   Center(
//                                     child: Text(
//                                       (patient['assignedDietPlan'] != null &&
//                                               patient['assignedDietPlan']['dietTitle'] !=
//                                                   null)
//                                           ? patient['assignedDietPlan']['dietTitle']
//                                           : 'No Diet Assigned',
//                                     ),
//                                   ),
//                                 ),
//                                 DataCell(
//                                   Center(
//                                     child: PopupMenuButton<String>(
//                                       icon: const Icon(
//                                         Icons.more_vert_outlined,
//                                       ),
//                                       offset: const Offset(100, 0),
//                                       onSelected: (value) async {
//                                         if (value == 'block') {
//                                         } else if (value == 'delete') {
//                                           // 🔹 Delete user from Firestore
//                                           await FirebaseFirestore.instance
//                                               .collection('Users')
//                                               .doc(patientId)
//                                               .delete();
//
//                                           ScaffoldMessenger.of(
//                                             context,
//                                           ).showSnackBar(
//                                             const SnackBar(
//                                               content: Text(
//                                                 "User deleted successfully",
//                                               ),
//                                             ),
//                                           );
//                                         } else if (value == 'dietPlan') {
//                                           // 🔹 Fetch all diet plans
//                                           final snapshot =
//                                               await FirebaseFirestore.instance
//                                                   .collection('diet')
//                                                   .get();
//
//                                           final List<String> dietPlans =
//                                               snapshot.docs
//                                                   .map(
//                                                     (doc) =>
//                                                         doc['dietTitle']
//                                                             .toString(),
//                                                   )
//                                                   .toSet()
//                                                   .toList();
//
//                                           String? selectedPlan;
//                                           bool isLoading = false;
//
//                                           // 🔹 Show dialog to pick diet plan
//                                           showDialog(
//                                             context: context,
//                                             builder: (context) {
//                                               String? selectedPlan;
//                                               bool isLoading = false;
//
//                                               return StatefulBuilder(
//                                                 builder: (context, setState) {
//                                                   return AlertDialog(
//                                                     title: const Text(
//                                                       'Assign Diet Plan',
//                                                     ),
//                                                     content: Column(
//                                                       mainAxisSize:
//                                                           MainAxisSize.min,
//                                                       children: [
//                                                         DropdownButton<String>(
//                                                           isExpanded: true,
//                                                           value: selectedPlan,
//                                                           hint: const Text(
//                                                             'Choose a diet plan',
//                                                           ),
//                                                           items:
//                                                               dietPlans.map((
//                                                                 plan,
//                                                               ) {
//                                                                 return DropdownMenuItem<
//                                                                   String
//                                                                 >(
//                                                                   value: plan,
//                                                                   child: Text(
//                                                                     plan,
//                                                                   ),
//                                                                 );
//                                                               }).toList(),
//                                                           onChanged: (value) {
//                                                             setState(() {
//                                                               selectedPlan =
//                                                                   value;
//                                                             });
//                                                           },
//                                                         ),
//                                                         if (isLoading)
//                                                           const Padding(
//                                                             padding:
//                                                                 EdgeInsets.only(
//                                                                   top: 20,
//                                                                 ),
//                                                             child:
//                                                                 CircularProgressIndicator(),
//                                                           ),
//                                                       ],
//                                                     ),
//                                                     actions: [
//                                                       TextButton(
//                                                         onPressed: () async {
//                                                           if (selectedPlan !=
//                                                               null) {
//                                                             setState(() {
//                                                               isLoading = true;
//                                                             });
//
//                                                             await _assignDietPlan(
//                                                               patientId,
//                                                               selectedPlan!,
//                                                             );
//
//                                                             setState(() {
//                                                               isLoading = false;
//                                                             });
//
//                                                             Navigator.of(
//                                                               context,
//                                                             ).pop();
//
//                                                             ScaffoldMessenger.of(
//                                                               context,
//                                                             ).showSnackBar(
//                                                               const SnackBar(
//                                                                 content: Text(
//                                                                   'Diet plan assigned successfully',
//                                                                 ),
//                                                               ),
//                                                             );
//                                                           } else {
//                                                             Navigator.of(
//                                                               context,
//                                                             ).pop();
//                                                           }
//                                                         },
//                                                         child: const Text(
//                                                           'Assign',
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   );
//                                                 },
//                                               );
//                                             },
//                                           );
//                                         }
//                                       },
//                                       itemBuilder:
//                                           (context) => const [
//                                             PopupMenuItem(
//                                               value: 'block',
//                                               child: Text('Block'),
//                                             ),
//                                             PopupMenuItem(
//                                               value: 'delete',
//                                               child: Text('Delete'),
//                                             ),
//                                             PopupMenuItem(
//                                               value: 'dietPlan',
//                                               child: Text('Add Diet Plan'),
//                                             ),
//                                           ],
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             );
//                           }).toList(),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// Widget _buildToggleButton(String text, bool selected) {
//   return Container(
//     padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
//     decoration: BoxDecoration(
//       gradient:
//           selected
//               ? LinearGradient(colors: [Color(0xFF5AFF15), Color(0xFF00B712)])
//               : null,
//       color: selected ? null : Colors.grey.shade100,
//       borderRadius: BorderRadius.circular(8),
//     ),
//     child: Text(
//       text,
//       style: TextStyle(
//         fontWeight: FontWeight.bold,
//         color: selected ? Colors.white : Colors.black,
//       ),
//     ),
//   );
// }




// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
//
// class UserScreen extends StatefulWidget {
//   const UserScreen({super.key});
//
//   @override
//   State<UserScreen> createState() => _UserScreenState();
// }
//
// class _UserScreenState extends State<UserScreen> {
//   int selectedToggleIndex = 0;
//   late Future<List<Map<String, dynamic>>> _userFuture;
//   TextEditingController _searchController = TextEditingController();
//   String _searchQuery = '';
//
//   @override
//   void initState() {
//     super.initState();
//     _userFuture = _getAllUsers();
//   }
//
//   Future<List<Map<String, dynamic>>> _getAllUsers() async {
//     QuerySnapshot snapshot =
//     await FirebaseFirestore.instance.collection('Users').get();
//
//     return snapshot.docs.map((doc) {
//       final data = doc.data() as Map<String, dynamic>;
//       data['id'] = doc.id;
//       return data;
//     }).toList();
//   }
//
//   // FIXED: This now preserves the complete diet plan structure
//   Future<void> _assignDietPlan(String userId, String selectedPlanTitle) async {
//     final firestore = FirebaseFirestore.instance;
//
//     final dietSnapshot = await firestore
//         .collection('diet')
//         .where('dietTitle', isEqualTo: selectedPlanTitle)
//         .limit(1)
//         .get();
//
//     if (dietSnapshot.docs.isEmpty) return;
//
//     final dietDoc = dietSnapshot.docs.first;
//     final dietData = dietDoc.data();
//
//     // Store the COMPLETE diet document data as assignedDietPlan
//     // This preserves the exact structure including weeklyMeals with all nested data
//     final Map<String, dynamic> assignedDietPlan = {
//       'dietId': dietDoc.id,
//       'dietTitle': dietData['dietTitle'] ?? '',
//       'dietDescription': dietData['dietDescription'] ?? '',
//       'duration': dietData['duration'] ?? '',
//       'suitableFor': dietData['suitableFor'] ?? '',
//       'selectedMealType': '',
//       'dietImageUrl': dietData['dietImageUrl'] ?? '',
//       'tag': dietData['tag'] ?? '',
//       'createdBy': dietData['createdBy'] ?? '',
//       'createdAt': dietData['createdAt'] ?? '',
//       // This is the key - store the complete weeklyMeals structure
//       'weeklyMeals': Map<String, dynamic>.from(dietData['weeklyMeals'] ?? {}),
//     };
//
//     // Update the user document with the complete diet plan
//     await firestore.collection('Users').doc(userId).update({
//       'assignedDietPlan': assignedDietPlan,
//       // Remove assignedFoods - we don't need it anymore since we'll read from weeklyMeals
//       // If you want to keep it for backward compatibility, leave it empty
//      // 'assignedFoods': [],
//     });
//
//   //  debugPrint('✅ Diet plan assigned successfully with complete structure');
//   //  debugPrint('✅ Weekly meals preserved: ${assignedDietPlan['weeklyMeals'].keys}');
//
//     // Show success message
//     if (mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Diet plan assigned successfully with complete structure!'),
//           backgroundColor: Colors.green,
//         ),
//       );
//     }
//   }
//
//   Future<void> fetchAllUserDietTitles() async {
//     final snapshot = await FirebaseFirestore.instance.collection('Users').get();
//
//     for (var doc in snapshot.docs) {
//       final data = doc.data();
//       final dietPlan = data['assignedDietPlan'] as Map<String, dynamic>?;
//
//       final dietTitle = dietPlan?['dietTitle'] ?? 'No diet assigned';
//     }
//   }
//
//   // Filter users based on search query
//   List<QueryDocumentSnapshot> _filterUsers(List<QueryDocumentSnapshot> docs) {
//     if (_searchQuery.isEmpty) {
//       return docs;
//     }
//
//     return docs.where((doc) {
//       final patient = doc.data() as Map<String, dynamic>;
//       final username = (patient['username'] ?? '').toString().toLowerCase();
//       return username.contains(_searchQuery.toLowerCase());
//     }).toList();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Header
//             Row(
//               children: [
//                 const Text(
//                   "Patients",
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
//                 ),
//                 const Spacer(),
//                 Row(
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: const [
//                         Text("Cody Fisher"),
//                         Text("Dashboard Manager"),
//                       ],
//                     ),
//                     const SizedBox(width: 10),
//                     const CircleAvatar(
//                       radius: 24,
//                       backgroundImage: AssetImage("assets/male avatar.png"),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),
//             Row(
//               children: [
//                 Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: ToggleButtons(
//                     isSelected: [
//                       selectedToggleIndex == 0,
//                       selectedToggleIndex == 1,
//                       selectedToggleIndex == 2,
//                       selectedToggleIndex == 3,
//                     ],
//                     onPressed: (index) {
//                       setState(() {
//                         selectedToggleIndex = index;
//                       });
//                     },
//                     fillColor: Colors.transparent,
//                     splashColor: Colors.transparent,
//                     highlightColor: Colors.transparent,
//                     hoverColor: Colors.transparent,
//                     borderColor: Colors.transparent,
//                     selectedColor: Colors.white,
//                     color: Colors.green.shade900,
//                     borderRadius: BorderRadius.circular(8),
//                     renderBorder: false,
//                     children: [
//                       _buildToggleButton("All Status", selectedToggleIndex == 0),
//                       _buildToggleButton("Active", selectedToggleIndex == 1),
//                       _buildToggleButton("Non Active", selectedToggleIndex == 2),
//                       _buildToggleButton("Blocked", selectedToggleIndex == 3),
//                     ],
//                   ),
//                 ),
//                 const Spacer(),
//                 SizedBox(
//                   width: 250,
//                   child: TextField(
//                     controller: _searchController,
//                     decoration: InputDecoration(
//                       prefixIcon: const Icon(Icons.search),
//                       hintText: "Search by patient name",
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       suffixIcon: _searchQuery.isNotEmpty
//                           ? IconButton(
//                         icon: const Icon(Icons.clear),
//                         onPressed: () {
//                           setState(() {
//                             _searchController.clear();
//                             _searchQuery = '';
//                           });
//                         },
//                       )
//                           : null,
//                     ),
//                     onChanged: (value) {
//                       setState(() {
//                         _searchQuery = value;
//                       });
//                     },
//                   ),
//                 ),
//                 Container(
//                   margin: const EdgeInsets.all(8),
//                   child: Material(
//                     elevation: 1,
//                     borderRadius: BorderRadius.circular(12),
//                     color: Colors.white,
//                     child: InkWell(
//                       borderRadius: BorderRadius.circular(12),
//                       onTap: () {},
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Icon(
//                           Icons.filter_alt_outlined,
//                           color: Colors.green,
//                           size: 28,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),
//             Card(
//               elevation: 2,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: StreamBuilder<QuerySnapshot>(
//                 stream: FirebaseFirestore.instance.collection('Users').snapshots(),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const Center(child: CircularProgressIndicator());
//                   }
//
//                   if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                     return const Padding(
//                       padding: EdgeInsets.all(16.0),
//                       child: Text("No patient data found."),
//                     );
//                   }
//
//                   final docs = snapshot.data!.docs;
//                   final filteredDocs = _filterUsers(docs);
//
//                   if (filteredDocs.isEmpty && _searchQuery.isNotEmpty) {
//                     return Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Column(
//                         children: [
//                           const Icon(Icons.search_off, size: 50, color: Colors.grey),
//                           const SizedBox(height: 10),
//                           Text(
//                             "No patients found for '$_searchQuery'",
//                             style: const TextStyle(color: Colors.grey),
//                           ),
//                         ],
//                       ),
//                     );
//                   }
//
//                   return SingleChildScrollView(
//                     scrollDirection: Axis.horizontal,
//                     child: DataTable(
//                       headingRowColor: WidgetStateProperty.all(Colors.grey[200]),
//                       headingTextStyle: const TextStyle(fontWeight: FontWeight.bold),
//                       border: TableBorder.all(color: Colors.grey.shade300),
//                       columns: const [
//                         DataColumn(label: Text("Patient Image")),
//                         DataColumn(label: Text("Patient Name")),
//                         DataColumn(label: Text("Patient Weight")),
//                         DataColumn(label: Text("Patient Height")),
//                         DataColumn(label: Text('Plan Suitability')),
//                         DataColumn(label: Text("Assigned Diet Plan")),
//                         DataColumn(label: Text("Actions")),
//                       ],
//                       rows: filteredDocs.map((doc) {
//                         final patient = doc.data() as Map<String, dynamic>;
//                         final patientId = doc.id;
//                         return DataRow(
//                           cells: [
//                             DataCell(
//                               patient['image'] != null && patient['image'] != ''
//                                   ? (kIsWeb
//                                   ? Center(
//                                 child: Image.network(
//                                   patient['image'],
//                                   width: 60,
//                                   height: 60,
//                                 ),
//                               )
//                                   : Center(
//                                 child: Image.file(
//                                   File(patient['image']),
//                                   width: 60,
//                                   height: 60,
//                                 ),
//                               ))
//                                   : const Center(child: Icon(Icons.image)),
//                             ),
//                             DataCell(
//                               Center(
//                                 child: Text(
//                                   patient['username'] ?? 'No User Name',
//                                 ),
//                               ),
//                             ),
//                             DataCell(
//                               Center(
//                                 child: Text(
//                                   "${patient['weight'] ?? ''} ${patient['weightUnit'] ?? 'No User Weight'}",
//                                 ),
//                               ),
//                             ),
//                             DataCell(
//                               Center(
//                                 child: Text(
//                                   "${patient['height'] ?? ''} ${patient['heightUnit'] ?? 'No User Height'}",
//                                 ),
//                               ),
//                             ),
//                             DataCell(
//                               Center(
//                                 child: Text(
//                                   (patient['assignedDietPlan'] != null &&
//                                       patient['assignedDietPlan']['suitableFor'] != null)
//                                       ? patient['assignedDietPlan']['suitableFor']
//                                       : 'No Suitability Entered',
//                                 ),
//                               ),
//                             ),
//                             DataCell(
//                               Center(
//                                 child: Text(
//                                   (patient['assignedDietPlan'] != null &&
//                                       patient['assignedDietPlan']['dietTitle'] != null)
//                                       ? patient['assignedDietPlan']['dietTitle']
//                                       : 'No Diet Assigned',
//                                 ),
//                               ),
//                             ),
//                             DataCell(
//                               Center(
//                                 child: PopupMenuButton<String>(
//                                   icon: const Icon(Icons.more_vert_outlined),
//                                   offset: const Offset(100, 0),
//                                   onSelected: (value) async {
//                                     if (value == 'block') {
//                                       // Block user logic here
//                                     } else if (value == 'delete') {
//                                       await FirebaseFirestore.instance
//                                           .collection('Users')
//                                           .doc(patientId)
//                                           .delete();
//
//                                       ScaffoldMessenger.of(context).showSnackBar(
//                                         const SnackBar(
//                                           content: Text("User deleted successfully"),
//                                         ),
//                                       );
//                                     } else if (value == 'dietPlan') {
//                                       final snapshot = await FirebaseFirestore.instance
//                                           .collection('diet')
//                                           .get();
//
//                                       final List<String> dietPlans = snapshot.docs
//                                           .map((doc) => doc['dietTitle'].toString())
//                                           .toSet()
//                                           .toList();
//
//                                       showDialog(
//                                         context: context,
//                                         builder: (context) {
//                                           String? selectedPlan;
//                                           bool isLoading = false;
//
//                                           return StatefulBuilder(
//                                             builder: (context, setState) {
//                                               return AlertDialog(
//                                                 title: const Text('Assign Diet Plan'),
//                                                 content: Column(
//                                                   mainAxisSize: MainAxisSize.min,
//                                                   children: [
//                                                     DropdownButton<String>(
//                                                       isExpanded: true,
//                                                       value: selectedPlan,
//                                                       hint: const Text('Choose a diet plan'),
//                                                       items: dietPlans.map((plan) {
//                                                         return DropdownMenuItem<String>(
//                                                           value: plan,
//                                                           child: Text(plan),
//                                                         );
//                                                       }).toList(),
//                                                       onChanged: (value) {
//                                                         setState(() {
//                                                           selectedPlan = value;
//                                                         });
//                                                       },
//                                                     ),
//                                                     if (isLoading)
//                                                       const Padding(
//                                                         padding: EdgeInsets.only(top: 20),
//                                                         child: CircularProgressIndicator(),
//                                                       ),
//                                                   ],
//                                                 ),
//                                                 actions: [
//                                                   TextButton(
//                                                     onPressed: () async {
//                                                       if (selectedPlan != null) {
//                                                         setState(() {
//                                                           isLoading = true;
//                                                         });
//
//                                                         await _assignDietPlan(
//                                                           patientId,
//                                                           selectedPlan!,
//                                                         );
//
//                                                         setState(() {
//                                                           isLoading = false;
//                                                         });
//
//                                                         if (mounted) {
//                                                           Navigator.of(context).pop();
//                                                         }
//                                                       } else {
//                                                         if (mounted) {
//                                                           Navigator.of(context).pop();
//                                                         }
//                                                       }
//                                                     },
//                                                     child: const Text('Assign'),
//                                                   ),
//                                                 ],
//                                               );
//                                             },
//                                           );
//                                         },
//                                       );
//                                     }
//                                   },
//                                   itemBuilder: (context) => const [
//                                     PopupMenuItem(value: 'block', child: Text('Block')),
//                                     PopupMenuItem(value: 'delete', child: Text('Delete')),
//                                     PopupMenuItem(value: 'dietPlan', child: Text('Add Diet Plan')),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         );
//                       }).toList(),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// Widget _buildToggleButton(String text, bool selected) {
//   return Container(
//     padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
//     decoration: BoxDecoration(
//       gradient: selected
//           ? const LinearGradient(colors: [Color(0xFF5AFF15), Color(0xFF00B712)])
//           : null,
//       color: selected ? null : Colors.grey.shade100,
//       borderRadius: BorderRadius.circular(8),
//     ),
//     child: Text(
//       text,
//       style: TextStyle(
//         fontWeight: FontWeight.bold,
//         color: selected ? Colors.white : Colors.black,
//       ),
//     ),
//   );
// }






import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'admin_provider.dart';

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

  // Check if user is active (lastLoginTimestamp less than 3 days)
  bool _isUserActive(Map<String, dynamic> user) {
    Timestamp? lastLogin = user['lastLoginTimestamp'];
    if (lastLogin == null) return false;

    DateTime lastLoginDate = lastLogin.toDate();
    DateTime now = DateTime.now();
    Duration difference = now.difference(lastLoginDate);

    // Active if less than 3 days (72 hours)
    return difference.inDays < 3;
  }

  // Check if user is non-active (lastLoginTimestamp greater than 3 days)
  bool _isUserNonActive(Map<String, dynamic> user) {
    Timestamp? lastLogin = user['lastLoginTimestamp'];
    if (lastLogin == null) return true; // Never logged in, consider non-active

    DateTime lastLoginDate = lastLogin.toDate();
    DateTime now = DateTime.now();
    Duration difference = now.difference(lastLoginDate);

    // Non-active if 3 days or more
    return difference.inDays >= 3;
  }

  // Check if user is blocked
  bool _isUserBlocked(Map<String, dynamic> user) {
    return user['isBlocked'] == true;
  }

  // Block user
  Future<void> _blockUser(String userId) async {
    try {
      await FirebaseFirestore.instance.collection('Users').doc(userId).update({
        'isBlocked': true,
        'blockedAt': FieldValue.serverTimestamp(),
        'blockedBy': 'admin',
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User blocked successfully'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      debugPrint("Error blocking user: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to block user'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Unblock user
  Future<void> _unblockUser(String userId) async {
    try {
      await FirebaseFirestore.instance.collection('Users').doc(userId).update({
        'isBlocked': false,
        'unblockedAt': FieldValue.serverTimestamp(),
        'unblockedBy': 'admin',
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User unblocked successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      debugPrint("Error unblocking user: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to unblock user'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Filter users based on selected toggle
  List<QueryDocumentSnapshot> _filterUsersByStatus(List<QueryDocumentSnapshot> docs) {
    return docs.where((doc) {
      final patient = doc.data() as Map<String, dynamic>;

      switch (selectedToggleIndex) {
        case 0: // All Status
          return true;
        case 1: // Active Users (last login less than 3 days)
          return _isUserActive(patient) && !_isUserBlocked(patient);
        case 2: // Non Active Users (last login greater than 3 days)
          return _isUserNonActive(patient) && !_isUserBlocked(patient);
        case 3: // Blocked Users
          return _isUserBlocked(patient);
        default:
          return true;
      }
    }).toList();
  }

  // Filter users based on search query
  List<QueryDocumentSnapshot> _filterUsersBySearch(List<QueryDocumentSnapshot> docs) {
    if (_searchQuery.isEmpty) {
      return docs;
    }

    return docs.where((doc) {
      final patient = doc.data() as Map<String, dynamic>;
      final username = (patient['username'] ?? '').toString().toLowerCase();
      return username.contains(_searchQuery.toLowerCase());
    }).toList();
  }

  // FIXED: This now preserves the complete diet plan structure
  Future<void> _assignDietPlan(String userId, String selectedPlanTitle) async {
    final firestore = FirebaseFirestore.instance;

    final dietSnapshot = await firestore
        .collection('diet')
        .where('dietTitle', isEqualTo: selectedPlanTitle)
        .limit(1)
        .get();

    if (dietSnapshot.docs.isEmpty) return;

    final dietDoc = dietSnapshot.docs.first;
    final dietData = dietDoc.data();

    // Store the COMPLETE diet document data as assignedDietPlan
    // This preserves the exact structure including weeklyMeals with all nested data
    final Map<String, dynamic> assignedDietPlan = {
      'dietId': dietDoc.id,
      'dietTitle': dietData['dietTitle'] ?? '',
      'dietDescription': dietData['dietDescription'] ?? '',
      'duration': dietData['duration'] ?? '',
      'suitableFor': dietData['suitableFor'] ?? '',
      'selectedMealType': '',
      'dietImageUrl': dietData['dietImageUrl'] ?? '',
      'tag': dietData['tag'] ?? '',
      'createdBy': dietData['createdBy'] ?? '',
      'createdAt': dietData['createdAt'] ?? '',
      // This is the key - store the complete weeklyMeals structure
      'weeklyMeals': Map<String, dynamic>.from(dietData['weeklyMeals'] ?? {}),
    };

    // Update the user document with the complete diet plan
    await firestore.collection('Users').doc(userId).update({
      'assignedDietPlan': assignedDietPlan,
    });

    // Show success message
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Diet plan assigned successfully with complete structure!'),
          backgroundColor: Colors.green,
        ),
      );
    }
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
    String adminName = Provider.of<AdminProvider>(context).adminName;
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
                      children:  [
                        Text(adminName),
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
                      _buildToggleButton("All Status", selectedToggleIndex == 0),
                      _buildToggleButton("Active", selectedToggleIndex == 1),
                      _buildToggleButton("Non Active", selectedToggleIndex == 2),
                      _buildToggleButton("Blocked", selectedToggleIndex == 3),
                    ],
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: 250,
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: "Search by patient name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      suffixIcon: _searchQuery.isNotEmpty
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
                Container(
                  margin: const EdgeInsets.all(8),
                  child: Material(
                    elevation: 1,
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {},
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
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
                stream: FirebaseFirestore.instance.collection('Users').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text("No patient data found."),
                    );
                  }

                  final docs = snapshot.data!.docs;

                  // Apply status filter first
                  final statusFilteredDocs = _filterUsersByStatus(docs);

                  // Then apply search filter
                  final filteredDocs = _filterUsersBySearch(statusFilteredDocs);

                  if (filteredDocs.isEmpty && _searchQuery.isNotEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Icon(Icons.search_off, size: 50, color: Colors.grey),
                          const SizedBox(height: 10),
                          Text(
                            "No patients found for '$_searchQuery'",
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }

                  if (filteredDocs.isEmpty) {
                    String statusText = "";
                    switch (selectedToggleIndex) {
                      case 1:
                        statusText = "active";
                        break;
                      case 2:
                        statusText = "non-active";
                        break;
                      case 3:
                        statusText = "blocked";
                        break;
                      default:
                        statusText = "";
                    }
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Icon(Icons.people_outline, size: 50, color: Colors.grey),
                          const SizedBox(height: 10),
                          Text(
                            statusText.isEmpty
                                ? "No patients found"
                                : "No $statusText patients found",
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.all(Colors.grey[200]),
                      headingTextStyle: const TextStyle(fontWeight: FontWeight.bold),
                      border: TableBorder.all(color: Colors.grey.shade300),
                      columns: const [
                        DataColumn(label: Text("Patient Image")),
                        DataColumn(label: Text("Patient Name")),
                        DataColumn(label: Text("Patient Weight")),
                        DataColumn(label: Text("Patient Height")),
                        DataColumn(label: Text('Plan Suitability')),
                        DataColumn(label: Text("Assigned Diet Plan")),
                        DataColumn(label: Text("Status")),
                        DataColumn(label: Text("Actions")),
                      ],
                      rows: filteredDocs.map((doc) {
                        final patient = doc.data() as Map<String, dynamic>;
                        final patientId = doc.id;
                        final isBlocked = _isUserBlocked(patient);
                        final isActive = _isUserActive(patient);

                        // Determine status text and color
                        String statusText = "";
                        Color statusColor = Colors.grey;
                        if (isBlocked) {
                          statusText = "Blocked";
                          statusColor = Colors.red;
                        } else if (isActive) {
                          statusText = "Active";
                          statusColor = Colors.green;
                        } else {
                          statusText = "Non-Active";
                          statusColor = Colors.orange;
                        }

                        return DataRow(
                          cells: [
                        DataCell(
                              patient['image'] != null && patient['image'] != ''
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
                                  : const Center(child: Icon(Icons.image)),
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
                                      patient['assignedDietPlan']['suitableFor'] != null)
                                      ? patient['assignedDietPlan']['suitableFor']
                                      : 'No Suitability Entered',
                                ),
                              ),
                            ),
                            DataCell(
                              Center(
                                child: Text(
                                  (patient['assignedDietPlan'] != null &&
                                      patient['assignedDietPlan']['dietTitle'] != null)
                                      ? patient['assignedDietPlan']['dietTitle']
                                      : 'No Diet Assigned',
                                ),
                              ),
                            ),
                            DataCell(
                              Center(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: statusColor.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    statusText,
                                    style: TextStyle(
                                      color: statusColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              Center(
                                child: PopupMenuButton<String>(
                                  icon: const Icon(Icons.more_vert_outlined),
                                  offset: const Offset(100, 0),
                                  onSelected: (value) async {
                                    if (value == 'block') {
                                      if (isBlocked) {
                                        await _unblockUser(patientId);
                                      } else {
                                        await _blockUser(patientId);
                                      }
                                    } else if (value == 'delete') {
                                      bool confirmDelete = await showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text('Delete User'),
                                          content: const Text('Are you sure you want to delete this user? This action cannot be undone.'),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(context, false),
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () => Navigator.pop(context, true),
                                              style: TextButton.styleFrom(foregroundColor: Colors.red),
                                              child: const Text('Delete'),
                                            ),
                                          ],
                                        ),
                                      ) ?? false;

                                      if (confirmDelete) {
                                        await FirebaseFirestore.instance
                                            .collection('Users')
                                            .doc(patientId)
                                            .delete();

                                        if (mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text("User deleted successfully"),
                                              backgroundColor: Colors.green,
                                            ),
                                          );
                                        }
                                      }
                                    } else if (value == 'dietPlan') {
                                      final snapshot = await FirebaseFirestore.instance
                                          .collection('diet')
                                          .get();

                                      final List<String> dietPlans = snapshot.docs
                                          .map((doc) => doc['dietTitle'].toString())
                                          .toSet()
                                          .toList();

                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          String? selectedPlan;
                                          bool isLoading = false;

                                          return StatefulBuilder(
                                            builder: (context, setState) {
                                              return AlertDialog(
                                                title: const Text('Assign Diet Plan'),
                                                content: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    DropdownButton<String>(
                                                      isExpanded: true,
                                                      value: selectedPlan,
                                                      hint: const Text('Choose a diet plan'),
                                                      items: dietPlans.map((plan) {
                                                        return DropdownMenuItem<String>(
                                                          value: plan,
                                                          child: Text(plan),
                                                        );
                                                      }).toList(),
                                                      onChanged: (value) {
                                                        setState(() {
                                                          selectedPlan = value;
                                                        });
                                                      },
                                                    ),
                                                    if (isLoading)
                                                      const Padding(
                                                        padding: EdgeInsets.only(top: 20),
                                                        child: CircularProgressIndicator(),
                                                      ),
                                                  ],
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () async {
                                                      if (selectedPlan != null) {
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

                                                        if (mounted) {
                                                          Navigator.of(context).pop();
                                                        }
                                                      } else {
                                                        if (mounted) {
                                                          Navigator.of(context).pop();
                                                        }
                                                      }
                                                    },
                                                    child: const Text('Assign'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                      );
                                    }
                                  },
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      value: 'block',
                                      child: Row(
                                        children: [
                                          Icon(
                                            isBlocked ? Icons.check_circle : Icons.block,
                                            color: isBlocked ? Colors.green : Colors.red,
                                            size: 18,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(isBlocked ? 'Unblock' : 'Block'),
                                        ],
                                      ),
                                    ),
                                    const PopupMenuItem(value: 'delete', child: Text('Delete')),
                                    const PopupMenuItem(value: 'dietPlan', child: Text('Add Diet Plan')),
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
    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
    decoration: BoxDecoration(
      gradient: selected
          ? const LinearGradient(colors: [Color(0xFF5AFF15), Color(0xFF00B712)])
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