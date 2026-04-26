import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'meals_history_screen.dart'; // Import the history screen

class AddMealsScreen extends StatefulWidget {
  const AddMealsScreen({super.key});

  @override
  State<AddMealsScreen> createState() => _AddMealsScreenState();
}

class _AddMealsScreenState extends State<AddMealsScreen> {
  // Diet plan variables
  int selectedDay = 1;
  Map<String, dynamic>? assignedDietPlan;
  bool isLoadingDietPlan = true;

  // User data
  Map<String, dynamic>? userData;
  bool _isloading = true;
  String userId = '';

  // Selected foods storage for current day and specific meals
  Map<String, List<Map<String, dynamic>>> selectedFoodsByMeal = {};

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    if (userId.isEmpty) return;

    try {
      final doc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .get();

      if (doc.exists) {
        final data = doc.data()!;

        setState(() {
          userData = data;

          // Get assigned diet plan from user document
          if (data.containsKey('assignedDietPlan') && data['assignedDietPlan'] != null) {
            assignedDietPlan = Map<String, dynamic>.from(data['assignedDietPlan']);
          }

          _isloading = false;
          isLoadingDietPlan = false;

          // After loading diet plan, refresh selected foods
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _refreshSelectedFoodsForCurrentDay();
          });
        });
      } else {
        setState(() {
          _isloading = false;
          isLoadingDietPlan = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching user data: $e");
      setState(() {
        _isloading = false;
        isLoadingDietPlan = false;
      });
    }
  }

  void _refreshSelectedFoodsForCurrentDay() {
    if (userData == null) return;

    // Clear existing data
    selectedFoodsByMeal.clear();

    // Initialize meal types from diet plan for the selected day
    if (assignedDietPlan != null && assignedDietPlan!['weeklyMeals'] != null) {
      String dayKey = 'Day $selectedDay';
      if (assignedDietPlan!['weeklyMeals'][dayKey] != null) {
        List<dynamic> meals = assignedDietPlan!['weeklyMeals'][dayKey];
        for (var meal in meals) {
          String mealName = meal['mealName'] ?? 'Meal 1';
          if (!selectedFoodsByMeal.containsKey(mealName)) {
            selectedFoodsByMeal[mealName] = [];
          }
        }
      }
    }

    // Get user selected foods from userData
    if (userData!.containsKey('userSelectedFood') && userData!['userSelectedFood'] != null) {
      List<dynamic> allFoods = userData!['userSelectedFood'];

      for (var food in allFoods) {
        Map<String, dynamic> foodMap = Map<String, dynamic>.from(food);

        // Check if this food belongs to the selected day
        int foodDay = foodMap['day'] ?? 0;

        // Only include foods that match the selected day
        if (foodDay == selectedDay) {
          String mealType = foodMap['mealType'] ?? 'Meal 1';
          if (!selectedFoodsByMeal.containsKey(mealType)) {
            selectedFoodsByMeal[mealType] = [];
          }
          selectedFoodsByMeal[mealType]?.add(foodMap);
        }
      }
    }

    setState(() {});
  }

  Future<void> _addFood(Map<String, dynamic> food) async {
    if (userId.isEmpty) return;

    try {
      final docRef = FirebaseFirestore.instance.collection('Users').doc(userId);
      final snapshot = await docRef.get();

      List<Map<String, dynamic>> updatedFoods = [];
      if (snapshot.exists && snapshot.data()!.containsKey("userSelectedFood")) {
        updatedFoods = List<Map<String, dynamic>>.from(snapshot.data()!["userSelectedFood"]);
      }

      updatedFoods.add(food);

      await docRef.update({
        "userSelectedFood": updatedFoods,
      });

      // Refresh userData
      final updatedDoc = await docRef.get();
      setState(() {
        userData = updatedDoc.data();
        _refreshSelectedFoodsForCurrentDay();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${food['foodName']} added to ${food['mealType']} (Quantity: ${food['consumptions'][0]['foodQuantity']})'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      debugPrint("Error adding food: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding food: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _deleteFood(Map<String, dynamic> food) async {
    if (userId.isEmpty) return;

    try {
      final docRef = FirebaseFirestore.instance.collection('Users').doc(userId);
      final snapshot = await docRef.get();

      if (!snapshot.exists) return;

      List<Map<String, dynamic>> updatedFoods = List<Map<String, dynamic>>.from(snapshot.data()!["userSelectedFood"]);

      updatedFoods.removeWhere(
            (f) => f['foodName'] == food['foodName'] &&
            f['mealType'] == food['mealType'] &&
            f['consumptions'][0]['date'] == food['consumptions'][0]['date'],
      );

      await docRef.update({
        "userSelectedFood": updatedFoods,
      });

      // Refresh userData
      final updatedDoc = await docRef.get();
      setState(() {
        userData = updatedDoc.data();
        _refreshSelectedFoodsForCurrentDay();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${food['foodName']} removed'),
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 1),
        ),
      );
    } catch (e) {
      debugPrint("Error deleting food: $e");
    }
  }

  Future<void> _updateFoodQuantity(Map<String, dynamic> food, int newQuantity) async {
    if (userId.isEmpty) return;

    try {
      final docRef = FirebaseFirestore.instance.collection('Users').doc(userId);
      final snapshot = await docRef.get();

      if (!snapshot.exists) return;

      List<Map<String, dynamic>> updatedFoods = List<Map<String, dynamic>>.from(snapshot.data()!["userSelectedFood"]);

      // Find and update the food item
      int index = updatedFoods.indexWhere(
            (f) => f['foodName'] == food['foodName'] &&
            f['mealType'] == food['mealType'] &&
            f['consumptions'][0]['date'] == food['consumptions'][0]['date'],
      );

      if (index != -1) {
        updatedFoods[index]['consumptions'][0]['foodQuantity'] = newQuantity.toString();

        await docRef.update({
          "userSelectedFood": updatedFoods,
        });

        // Refresh userData
        final updatedDoc = await docRef.get();
        setState(() {
          userData = updatedDoc.data();
          _refreshSelectedFoodsForCurrentDay();
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${food['foodName']} quantity updated to $newQuantity'),
            backgroundColor: Colors.blue,
            duration: const Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      debugPrint("Error updating food quantity: $e");
    }
  }

  // Helper method to get meals for selected day
  List<dynamic> getMealsForSelectedDay() {
    if (assignedDietPlan == null || assignedDietPlan!['weeklyMeals'] == null) {
      return [];
    }

    String dayKey = 'Day $selectedDay';
    if (assignedDietPlan!['weeklyMeals'][dayKey] != null) {
      return assignedDietPlan!['weeklyMeals'][dayKey] as List<dynamic>;
    }
    return [];
  }

  // Helper method to get foods for a specific meal
  Map<String, dynamic>? getMealData(String mealName) {
    final meals = getMealsForSelectedDay();
    for (var meal in meals) {
      if (meal['mealName'] == mealName) {
        return meal as Map<String, dynamic>;
      }
    }
    return null;
  }

  // Helper method to get foods to eat for a specific meal
  List<dynamic> getFoodsToEatForMeal(String mealName) {
    final mealData = getMealData(mealName);
    if (mealData != null && mealData['foodsToEat'] != null) {
      return mealData['foodsToEat'] as List<dynamic>;
    }
    return [];
  }

  // Helper method to get foods to avoid for a specific meal
  List<dynamic> getFoodsToAvoidForMeal(String mealName) {
    final mealData = getMealData(mealName);
    if (mealData != null && mealData['foodsToAvoid'] != null) {
      return mealData['foodsToAvoid'] as List<dynamic>;
    }
    return [];
  }

  // Get selected foods for a specific meal on the selected day
  List<Map<String, dynamic>> getSelectedFoodsForMeal(String mealName) {
    return selectedFoodsByMeal[mealName] ?? [];
  }

  // Calculate total calories for a specific meal on the selected day
  int calculateMealTotalCalories(String mealName) {
    int totalCalories = 0;
    final foods = getSelectedFoodsForMeal(mealName);

    for (var food in foods) {
      int qty = 1;
      if (food.containsKey('consumptions') && food['consumptions'] != null && food['consumptions'].isNotEmpty) {
        qty = int.tryParse(food['consumptions'][0]['foodQuantity'].toString()) ?? 1;
      }
      int kcal = int.tryParse(food['calories'].toString()) ?? 0;
      totalCalories += qty * kcal;
    }
    return totalCalories;
  }

  // Calculate total items count (sum of quantities) for a specific meal on the selected day
  int calculateMealTotalItems(String mealName) {
    int totalItems = 0;
    final foods = getSelectedFoodsForMeal(mealName);

    for (var food in foods) {
      int qty = 1;
      if (food.containsKey('consumptions') && food['consumptions'] != null && food['consumptions'].isNotEmpty) {
        qty = int.tryParse(food['consumptions'][0]['foodQuantity'].toString()) ?? 1;
      }
      totalItems += qty;
    }
    return totalItems;
  }

  @override
  Widget build(BuildContext context) {
    if (_isloading || isLoadingDietPlan) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00B712)),
          ),
        ),
      );
    }

    if (userData == null) {
      return const Scaffold(
        body: Center(
          child: Text("No user data found"),
        ),
      );
    }

    final meals = getMealsForSelectedDay();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView(
            children: [
              const SizedBox(height: 10),
              // Header
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios),
                  ),
                  const Spacer(),
                  const Text(
                    "My Diet Plan",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),
                  // Navigation to Meals History
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MealsHistoryScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.history),
                    color: const Color(0xFF00B712),
                  ),
                ],
              ),

              // Diet Plan Header Card
              if (assignedDietPlan != null) ...[
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF5AFF15), Color(0xFF00B712)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      if (assignedDietPlan!['dietImageUrl'] != null)
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                          child: Image.network(
                            assignedDietPlan!['dietImageUrl'],
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 150,
                                color: Colors.green[300],
                                child: const Center(
                                  child: Icon(
                                    Icons.food_bank,
                                    size: 50,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              assignedDietPlan!['dietTitle'] ?? 'Diet Plan',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              assignedDietPlan!['dietDescription'] ?? '',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                _buildInfoChip(Icons.timer, assignedDietPlan!['duration'] ?? '7 Days'),
                                _buildInfoChip(Icons.fitness_center, assignedDietPlan!['suitableFor'] ?? ''),
                                _buildInfoChip(Icons.local_offer, assignedDietPlan!['tag'] ?? ''),
                                _buildInfoChip(Icons.person, assignedDietPlan!['createdBy'] ?? ''),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 24),

              // Day Selection
              const Text(
                "Select Day",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 45,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 7,
                  itemBuilder: (context, index) {
                    int day = index + 1;
                    bool isSelected = selectedDay == day;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedDay = day;
                            _refreshSelectedFoodsForCurrentDay();
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isSelected
                              ? const Color(0xFF00B712)
                              : Colors.white,
                          foregroundColor: isSelected
                              ? Colors.white
                              : Colors.black,
                          elevation: isSelected ? 2 : 0,
                          side: BorderSide(
                            color: isSelected ? Colors.transparent : Colors.grey.withOpacity(0.3),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                        ),
                        child: Text(
                          "Day $day",
                          style: TextStyle(
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // Dynamic Meals Sections - Handles any number of meals (2, 3, 4, or more)
              for (var meal in meals) ...[
                _buildMealWithSummary(
                  mealName: meal['mealName'],
                  mealTime: meal['time'] ?? '',
                  mealCategory: meal['category'] ?? '',
                  foodsToEat: getFoodsToEatForMeal(meal['mealName']),
                  foodsToAvoid: getFoodsToAvoidForMeal(meal['mealName']),
                  selectedFoods: getSelectedFoodsForMeal(meal['mealName']),
                  totalCalories: calculateMealTotalCalories(meal['mealName']),
                  totalItems: calculateMealTotalItems(meal['mealName']),
                ),
                const SizedBox(height: 24),
              ],

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  String _getDayOfWeek(int day) {
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return days[(day - 1) % 7];
  }

  // Build meal section with summary on top
  Widget _buildMealWithSummary({
    required String mealName,
    required String mealTime,
    required String mealCategory,
    required List<dynamic> foodsToEat,
    required List<dynamic> foodsToAvoid,
    required List<Map<String, dynamic>> selectedFoods,
    required int totalCalories,
    required int totalItems,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Meal Summary Card (shows added items and calories for THIS MEAL ONLY)
        Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF5AFF15), Color(0xFF00B712)],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.green.withOpacity(0.2),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  _getMealIcon(mealName),
                  const SizedBox(width: 8),
                  Text(
                    mealName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  if (mealTime.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        mealTime,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      mealCategory,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF00B712),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Divider(color: Colors.white.withOpacity(0.3)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildSummaryStat(
                    icon: Icons.food_bank,
                    label: "Items Added",
                    value: totalItems.toString(),
                  ),
                  Container(
                    width: 1,
                    height: 30,
                    color: Colors.white.withOpacity(0.3),
                  ),
                  _buildSummaryStat(
                    icon: Icons.local_fire_department,
                    label: "Total Calories",
                    value: "$totalCalories kcal",
                  ),
                ],
              ),
            ],
          ),
        ),

        // Selected Foods List for THIS MEAL ONLY
        if (selectedFoods.isNotEmpty) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: Row(
              children: [
                Container(
                  width: 3,
                  height: 18,
                  decoration: BoxDecoration(
                    color: const Color(0xFF00B712),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  "Your Selected Items",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF00B712),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: selectedFoods.length,
            itemBuilder: (context, index) {
              final food = selectedFoods[index];
              int qty = 1;
              if (food.containsKey('consumptions') && food['consumptions'] != null && food['consumptions'].isNotEmpty) {
                qty = int.tryParse(food['consumptions'][0]['foodQuantity'].toString()) ?? 1;
              }
              int kcal = int.tryParse(food['calories'].toString()) ?? 0;
              final totalKcal = qty * kcal;

              return _buildSelectedFoodTile(
                itemName: food['foodName'],
                kcal: totalKcal.toString(),
                qty: qty,
                caloriesPerServing: kcal,
                foodImageUrl: food['foodImageUrl'],
                onDelete: () => _deleteFood(food),
                onUpdateQuantity: (newQty) => _updateFoodQuantity(food, newQty),
              );
            },
          ),
          const SizedBox(height: 16),
        ],

        // Foods to Eat Section (from diet plan) - Dynamic for any number of meals
        if (foodsToEat.isNotEmpty) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: Row(
              children: [
                Container(
                  width: 3,
                  height: 18,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  "Recommended Foods",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: foodsToEat.length,
            itemBuilder: (context, index) {
              final food = foodsToEat[index] as Map<String, dynamic>;
              return _buildFoodCard(food, isFoodToAvoid: false, mealName: mealName);
            },
          ),
        ],

        // Foods to Avoid Section (from diet plan) - Dynamic for any number of meals
        if (foodsToAvoid.isNotEmpty) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: Row(
              children: [
                Container(
                  width: 3,
                  height: 18,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  "Foods to Avoid",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: foodsToAvoid.length,
            itemBuilder: (context, index) {
              final food = foodsToAvoid[index] as Map<String, dynamic>;
              return _buildFoodCard(food, isFoodToAvoid: true, mealName: mealName);
            },
          ),
        ],
      ],
    );
  }

  Widget _buildSummaryStat({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, size: 20, color: Colors.white),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  // Build selected food tile with quantity controls
  Widget _buildSelectedFoodTile({
    required String itemName,
    required String kcal,
    required int qty,
    required int caloriesPerServing,
    required String? foodImageUrl,
    required VoidCallback onDelete,
    required Function(int) onUpdateQuantity,
  }) {
    int currentQty = qty;

    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFE9FDE3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              if (foodImageUrl != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    foodImageUrl,
                    height: 45,
                    width: 45,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 45,
                        width: 45,
                        color: Colors.green[100],
                        child: const Icon(Icons.food_bank, size: 20, color: Colors.green),
                      );
                    },
                  ),
                ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      itemName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        Text(
                          "$kcal kcal",
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "($caloriesPerServing kcal/serving)",
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      if (currentQty > 1) {
                        currentQty--;
                        setState(() {});
                        onUpdateQuantity(currentQty);
                      }
                    },
                    icon: const Icon(Icons.remove_circle_outline, size: 20),
                    color: const Color(0xFF00B712),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  Container(
                    width: 30,
                    alignment: Alignment.center,
                    child: Text(
                      currentQty.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      currentQty++;
                      setState(() {});
                      onUpdateQuantity(currentQty);
                    },
                    icon: const Icon(Icons.add_circle_outline, size: 20),
                    color: const Color(0xFF00B712),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete_outline, size: 18, color: Colors.red),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // Get icon based on meal name - Dynamic for any meal number
  Widget _getMealIcon(String mealName) {
    switch (mealName.toLowerCase()) {
      case 'meal 1':
        return const Icon(Icons.brightness_5, color: Colors.white, size: 20);
      case 'meal 2':
        return const Icon(Icons.sunny, color: Colors.white, size: 20);
      case 'meal 3':
        return const Icon(Icons.nightlight_round, color: Colors.white, size: 20);
      case 'meal 4':
        return const Icon(Icons.lunch_dining, color: Colors.white, size: 20);
      default:
        return const Icon(Icons.restaurant, color: Colors.white, size: 20);
    }
  }

  // Build food card with detailed information
  Widget _buildFoodCard(Map<String, dynamic> food, {required bool isFoodToAvoid, required String mealName}) {
    int quantity = 1;

    return StatefulBuilder(
      builder: (context, setState) {
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: isFoodToAvoid ? Colors.red[50] : Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Food Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: food['imageUrl'] != null
                          ? Image.network(
                        food['imageUrl'],
                        height: 80,
                        width: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 80,
                            width: 80,
                            color: isFoodToAvoid ? Colors.red[100] : Colors.grey[200],
                            child: Icon(
                              isFoodToAvoid ? Icons.warning : Icons.food_bank,
                              color: isFoodToAvoid ? Colors.red : Colors.green,
                              size: 40,
                            ),
                          );
                        },
                      )
                          : Container(
                        height: 80,
                        width: 80,
                        color: isFoodToAvoid ? Colors.red[100] : Colors.grey[200],
                        child: Icon(
                          isFoodToAvoid ? Icons.warning : Icons.food_bank,
                          color: isFoodToAvoid ? Colors.red : Colors.green,
                          size: 40,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Food Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            food['foodName'] ?? 'Unknown Food',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: isFoodToAvoid ? Colors.red : Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            food['foodDescription'] ?? '',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Nutritional Information
                if (!isFoodToAvoid && food['caloriesPerServing'] != null) ...[
                  const SizedBox(height: 12),
                  Divider(color: Colors.grey[200], height: 1),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildNutritionChip(Icons.local_fire_department, 'Calories', food['caloriesPerServing'] ?? 'N/A'),
                      if (food['protein'] != null)
                        _buildNutritionChip(Icons.fitness_center, 'Protein', food['protein']),
                      if (food['carbs'] != null)
                        _buildNutritionChip(Icons.grain, 'Carbs', food['carbs']),
                      if (food['fat'] != null)
                        _buildNutritionChip(Icons.oil_barrel, 'Fat', food['fat']),
                      _buildNutritionChip(Icons.restaurant, 'Serving', '${food['servingSize'] ?? ''} ${food['selectedUnits'] ?? ''}'),
                    ],
                  ),
                ],

                const SizedBox(height: 12),

                // Add Button with Quantity (only for foods to eat)
                if (!isFoodToAvoid) ...[
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFE9FDE3),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                if (quantity > 1) {
                                  setState(() => quantity--);
                                }
                              },
                              icon: const Icon(Icons.remove, size: 18),
                              color: const Color(0xFF00B712),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                            Container(
                              width: 30,
                              alignment: Alignment.center,
                              child: Text(
                                quantity.toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() => quantity++);
                              },
                              icon: const Icon(Icons.add, size: 18),
                              color: const Color(0xFF00B712),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            final now = DateTime.now();
                            final consumptionEntry = {
                              'date': now.toIso8601String(),
                              'foodQuantity': quantity.toString(),
                              'mealType': mealName,
                              'day': selectedDay,
                              'dayOfWeek': _getDayOfWeek(selectedDay),
                              'timestamp': now.millisecondsSinceEpoch,
                            };
                            final updatedFood = {
                              'foodName': food['foodName'] ?? '',
                              'calories': _extractNumericValue(food['caloriesPerServing'] ?? '0'),
                              'foodDescription': food['foodDescription'] ?? '',
                              'mealType': mealName,
                              'quantity': "${food['servingSize'] ?? '1'} ${food['selectedUnits'] ?? ''}",
                              'consumptions': [consumptionEntry],
                              'foodImageUrl': food['imageUrl'] ?? '',
                              'addedDate': now.toIso8601String(),
                              'day': selectedDay,
                            };
                            _addFood(updatedFood);
                            setState(() {
                              quantity = 1;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00B712),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                          icon: const Icon(Icons.add_circle_outline, size: 18),
                          label: const Text(
                            "Add to My Meals",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],

                // Warning for foods to avoid
                if (isFoodToAvoid)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.warning_amber_rounded, size: 14, color: Colors.red),
                        SizedBox(width: 4),
                        Text(
                          "Not recommended for this diet",
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Build info chip
  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // Build nutrition chip
  Widget _buildNutritionChip(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFE9FDE3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: const Color(0xFF00B712)),
          const SizedBox(width: 4),
          Text(
            "$label: $value",
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // Extract numeric value from string
  String _extractNumericValue(String value) {
    final RegExp regex = RegExp(r'(\d+(?:\.\d+)?)');
    final match = regex.firstMatch(value);
    return match?.group(1) ?? value;
  }
}