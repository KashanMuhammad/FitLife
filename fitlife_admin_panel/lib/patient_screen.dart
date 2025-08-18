import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
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

            // User Grid
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _userFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (snapshot.hasError) {
                  return const Text("Error loading users");
                }

                final users = snapshot.data;

                if (users == null || users.isEmpty) {
                  return const Text("No users found.");
                }

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(top: 20),
                  itemCount: users.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.8,
                  ),
                  itemBuilder: (context, index) {
                    final user = users[index];

                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Column(
                          children: [
                            // Popup menu in top-right
                            Align(
                              alignment: Alignment.topRight,
                              child: PopupMenuButton<String>(
                                icon: const Icon(Icons.more_vert, size: 20),
                                onSelected: (value) async {
                                  if (value == 'dietPlan') {
                                    final snapshot =
                                        await FirebaseFirestore.instance
                                            .collection('diet')
                                            .get();

                                    // Remove duplicates
                                    final List<String> dietPlans =
                                        snapshot.docs
                                            .map(
                                              (doc) =>
                                                  doc['dietTitle'] as String,
                                            )
                                            .toSet()
                                            .toList();

                                    String? selectedPlan;

                                    // Only preselect if it exists in list
                                    if (user['assignedDietPlan'] != null &&
                                        dietPlans.contains(
                                          user['assignedDietPlan'],
                                        )) {
                                      selectedPlan =
                                          user['assignedDietPlan'] as String;
                                    }

                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text('Assign Diet Plan'),
                                          content: StatefulBuilder(
                                            builder: (context, setState) {
                                              return DropdownButton<String>(
                                                isExpanded: true,
                                                value: selectedPlan,
                                                hint: const Text(
                                                  'Choose a diet plan',
                                                ),
                                                items:
                                                    dietPlans.map((plan) {
                                                      return DropdownMenuItem<
                                                        String
                                                      >(
                                                        value: plan,
                                                        child: Text(plan),
                                                      );
                                                    }).toList(),
                                                onChanged: (value) {
                                                  setState(() {
                                                    selectedPlan = value;
                                                  });
                                                },
                                              );
                                            },
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () async {
                                                if (selectedPlan != null) {
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('Users')
                                                      .doc(user['id'])
                                                      .update({
                                                        'assignedDietPlan':
                                                            selectedPlan,
                                                      });

                                                  Navigator.of(context).pop();

                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                        'Diet plan assigned successfully',
                                                      ),
                                                    ),
                                                  );

                                                  setState(() {
                                                    _userFuture =
                                                        _getAllUsers();
                                                  });
                                                } else {
                                                  Navigator.of(context).pop();
                                                }
                                              },
                                              child: const Text('Assign'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                },
                                itemBuilder:
                                    (context) => const [
                                      PopupMenuItem(
                                        value: 'deleteUser',
                                        child: Text('Delete User'),
                                      ),
                                      PopupMenuItem(
                                        value: 'blockUser',
                                        child: Text('Block User'),
                                      ),
                                      PopupMenuItem(
                                        value: 'dietPlan',
                                        child: Text('Diet Plan'),
                                      ),
                                    ],
                              ),
                            ),

                            // User image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                'assets/male avatar.png',
                                height: 40,
                                width: 40,
                              ),
                            ),

                            const SizedBox(height: 6),

                            // Username
                            Text(
                              user['username'] ?? 'No Name',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),

                            const SizedBox(height: 4),

                            // Diet plan info
                            Text(
                              (user['assignedDietPlan'] != null &&
                                      user['assignedDietPlan']
                                          .toString()
                                          .isNotEmpty)
                                  ? 'Plan: ${user['assignedDietPlan']}'
                                  : 'No Diet Plan Assigned',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
