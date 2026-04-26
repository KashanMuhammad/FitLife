import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MealsHistoryScreen extends StatefulWidget {
  const MealsHistoryScreen({super.key});

  @override
  State<MealsHistoryScreen> createState() => _MealsHistoryScreenState();
}

class _MealsHistoryScreenState extends State<MealsHistoryScreen> {
  List<Map<String, dynamic>> allUserSelectedFoods = [];
  bool _isLoading = true;
  String userId = '';
  int selectedIndex = 0; // 0: All, 1: Meal 1, 2: Meal 2, 3: Meal 3

  // Statistics for different periods
  Map<String, dynamic> todayStats = {};
  Map<String, dynamic> yesterdayStats = {};
  Map<String, dynamic> beforeYesterdayStats = {};

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    userId = "ItVI3JhcWnQmTFekpCzCcYhYpHQ2";
    if (userId.isEmpty) return;

    try {
      final doc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .get();

      if (doc.exists) {
        final data = doc.data()!;

        // Load user selected foods
        if (data.containsKey('userSelectedFood') && data['userSelectedFood'] != null) {
          allUserSelectedFoods = List<Map<String, dynamic>>.from(data['userSelectedFood']);
          print("Loaded ${allUserSelectedFoods.length} food items");

          // Print each food for debugging
          for (var food in allUserSelectedFoods) {
            print("Food: ${food['foodName']}, Day: ${food['day']}, Meal: ${food['mealType']}, Quantity: ${food['consumptions'][0]['foodQuantity']}");
          }
        } else {
          print("No userSelectedFood field found");
        }

        setState(() {
          _isLoading = false;
          calculateStatistics();
        });
      } else {
        print("Document does not exist");
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print("⚠️ Error fetching user meals: $e");
      setState(() => _isLoading = false);
    }
  }

  void calculateStatistics() {
    if (allUserSelectedFoods.isEmpty) return;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final beforeYesterday = today.subtract(const Duration(days: 2));

    // Calculate today's stats
    todayStats = _calculateStatsForDate(today);

    // Calculate yesterday's stats
    yesterdayStats = _calculateStatsForDate(yesterday);

    // Calculate before yesterday's stats (all days before yesterday)
    beforeYesterdayStats = _calculateStatsForDateRange(DateTime(2000, 1, 1), beforeYesterday.subtract(const Duration(days: 1)));

    setState(() {});
  }

  Map<String, dynamic> _calculateStatsForDate(DateTime date) {
    int totalItems = 0;
    int totalCalories = 0;
    Map<String, Map<String, dynamic>> mealsData = {};

    for (var food in allUserSelectedFoods) {
      // Check if food belongs to this date
      int foodDay = food['day'] ?? -1;
      bool matchesDay = (foodDay == date.day);

      // Also check by date string if day field doesn't match
      if (!matchesDay && food.containsKey('consumptions') && food['consumptions'] != null && food['consumptions'].isNotEmpty) {
        String foodDate = food['consumptions'][0]['date'].split('T')[0];
        DateTime foodDateTime = DateTime.tryParse(foodDate) ?? DateTime.now();
        matchesDay = (foodDateTime.year == date.year && foodDateTime.month == date.month && foodDateTime.day == date.day);
      }

      if (matchesDay) {
        // Apply meal type filter
        String foodMealType = food['mealType'] ?? 'Meal 1';
        if (selectedIndex != 0) {
          String targetMealType = selectedIndex == 1 ? "Meal 1" : (selectedIndex == 2 ? "Meal 2" : "Meal 3");
          if (foodMealType != targetMealType) {
            continue;
          }
        }

        int qty = 1;
        if (food.containsKey('consumptions') && food['consumptions'] != null && food['consumptions'].isNotEmpty) {
          qty = int.tryParse(food['consumptions'][0]['foodQuantity'].toString()) ?? 1;
        }
        int kcal = int.tryParse(food['calories'].toString()) ?? 0;
        int totalKcal = qty * kcal;

        totalItems += qty;
        totalCalories += totalKcal;

        if (!mealsData.containsKey(foodMealType)) {
          mealsData[foodMealType] = {
            'items': 0,
            'calories': 0,
          };
        }
        mealsData[foodMealType]!['items'] += qty;
        mealsData[foodMealType]!['calories'] += totalKcal;
      }
    }

    return {
      'totalItems': totalItems,
      'totalCalories': totalCalories,
      'mealsData': mealsData,
    };
  }

  Map<String, dynamic> _calculateStatsForDateRange(DateTime startDate, DateTime endDate) {
    int totalItems = 0;
    int totalCalories = 0;
    Map<String, Map<String, dynamic>> mealsData = {};
    Map<String, Map<String, dynamic>> dailyData = {};

    for (var food in allUserSelectedFoods) {
      String foodDate = '';
      if (food.containsKey('consumptions') && food['consumptions'] != null && food['consumptions'].isNotEmpty) {
        foodDate = food['consumptions'][0]['date'].split('T')[0];
      }

      DateTime foodDateTime = DateTime.tryParse(foodDate) ?? DateTime.now();
      DateTime foodDateOnly = DateTime(foodDateTime.year, foodDateTime.month, foodDateTime.day);

      if (foodDateOnly.isAfter(startDate) && foodDateOnly.isBefore(endDate.add(const Duration(days: 1)))) {
        // Apply meal type filter
        String foodMealType = food['mealType'] ?? 'Meal 1';
        if (selectedIndex != 0) {
          String targetMealType = selectedIndex == 1 ? "Meal 1" : (selectedIndex == 2 ? "Meal 2" : "Meal 3");
          if (foodMealType != targetMealType) {
            continue;
          }
        }

        int qty = 1;
        if (food.containsKey('consumptions') && food['consumptions'] != null && food['consumptions'].isNotEmpty) {
          qty = int.tryParse(food['consumptions'][0]['foodQuantity'].toString()) ?? 1;
        }
        int kcal = int.tryParse(food['calories'].toString()) ?? 0;
        int totalKcal = qty * kcal;

        totalItems += qty;
        totalCalories += totalKcal;

        String dateKey = "${foodDateOnly.day}/${foodDateOnly.month}/${foodDateOnly.year}";
        if (!dailyData.containsKey(dateKey)) {
          dailyData[dateKey] = {
            'items': 0,
            'calories': 0,
            'date': foodDateOnly,
          };
        }
        dailyData[dateKey]!['items'] += qty;
        dailyData[dateKey]!['calories'] += totalKcal;

        if (!mealsData.containsKey(foodMealType)) {
          mealsData[foodMealType] = {
            'items': 0,
            'calories': 0,
          };
        }
        mealsData[foodMealType]!['items'] += qty;
        mealsData[foodMealType]!['calories'] += totalKcal;
      }
    }

    return {
      'totalItems': totalItems,
      'totalCalories': totalCalories,
      'mealsData': mealsData,
      'dailyData': dailyData,
    };
  }

  List<Map<String, dynamic>> getFilteredFoodsForDate(DateTime date) {
    List<Map<String, dynamic>> filteredFoods = [];

    for (var food in allUserSelectedFoods) {
      // Check if food belongs to this date
      int foodDay = food['day'] ?? -1;
      bool matchesDay = (foodDay == date.day);

      // Also check by date string if day field doesn't match
      if (!matchesDay && food.containsKey('consumptions') && food['consumptions'] != null && food['consumptions'].isNotEmpty) {
        String foodDate = food['consumptions'][0]['date'].split('T')[0];
        DateTime foodDateTime = DateTime.tryParse(foodDate) ?? DateTime.now();
        matchesDay = (foodDateTime.year == date.year && foodDateTime.month == date.month && foodDateTime.day == date.day);
      }

      if (matchesDay) {
        // Apply meal type filter
        if (selectedIndex != 0) {
          String targetMealType = selectedIndex == 1 ? "Meal 1" : (selectedIndex == 2 ? "Meal 2" : "Meal 3");
          String foodMealType = food['mealType'] ?? 'Meal 1';
          if (foodMealType != targetMealType) {
            continue;
          }
        }
        filteredFoods.add(food);
      }
    }

    // Sort by meal type
    filteredFoods.sort((a, b) {
      String mealA = a['mealType'] ?? 'Meal 1';
      String mealB = b['mealType'] ?? 'Meal 1';
      return mealA.compareTo(mealB);
    });

    return filteredFoods;
  }

  List<Map<String, dynamic>> getFilteredFoodsForDateRange(DateTime startDate, DateTime endDate) {
    List<Map<String, dynamic>> filteredFoods = [];

    for (var food in allUserSelectedFoods) {
      String foodDate = '';
      if (food.containsKey('consumptions') && food['consumptions'] != null && food['consumptions'].isNotEmpty) {
        foodDate = food['consumptions'][0]['date'].split('T')[0];
      }

      DateTime foodDateTime = DateTime.tryParse(foodDate) ?? DateTime.now();
      DateTime foodDateOnly = DateTime(foodDateTime.year, foodDateTime.month, foodDateTime.day);

      if (foodDateOnly.isAfter(startDate) && foodDateOnly.isBefore(endDate.add(const Duration(days: 1)))) {
        // Apply meal type filter
        if (selectedIndex != 0) {
          String targetMealType = selectedIndex == 1 ? "Meal 1" : (selectedIndex == 2 ? "Meal 2" : "Meal 3");
          String foodMealType = food['mealType'] ?? 'Meal 1';
          if (foodMealType != targetMealType) {
            continue;
          }
        }
        filteredFoods.add(food);
      }
    }

    // Sort by date and then by meal type
    filteredFoods.sort((a, b) {
      String dateA = a['consumptions']?[0]['date'] ?? '';
      String dateB = b['consumptions']?[0]['date'] ?? '';
      int dateCompare = dateB.compareTo(dateA); // Newest first
      if (dateCompare != 0) return dateCompare;

      String mealA = a['mealType'] ?? 'Meal 1';
      String mealB = b['mealType'] ?? 'Meal 1';
      return mealA.compareTo(mealB);
    });

    return filteredFoods;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00B712)),
          ),
        ),
      );
    }

    if (allUserSelectedFoods.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 15),
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios),
                  ),
                  const Spacer(),
                  const Text(
                    "Meals History",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
              const Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.history, size: 80, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        "No meals history found",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Start adding meals from your diet plan",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final beforeYesterdayStart = DateTime(2000, 1, 1);
    final beforeYesterdayEnd = yesterday.subtract(const Duration(days: 1));

    final todayFoods = getFilteredFoodsForDate(today);
    final yesterdayFoods = getFilteredFoodsForDate(yesterday);
    final beforeYesterdayFoods = getFilteredFoodsForDateRange(beforeYesterdayStart, beforeYesterdayEnd);

    // Get available meal types
    Set<String> availableMealTypes = {};
    for (var food in allUserSelectedFoods) {
      availableMealTypes.add(food['mealType'] ?? 'Meal 1');
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                      "Meals History",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),

                const SizedBox(height: 20),

                // Filter Buttons - Dynamic based on available meal types
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: const Color(0xFFE9FDE3),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterButton("All", 0),
                        if (availableMealTypes.contains("Meal 1"))
                          _buildFilterButton("Meal 1", 1),
                        if (availableMealTypes.contains("Meal 2"))
                          _buildFilterButton("Meal 2", 2),
                        if (availableMealTypes.contains("Meal 3"))
                          _buildFilterButton("Meal 3", 3),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Today's Section
                if (todayFoods.isNotEmpty)
                  _buildDateSection(
                    title: "Today's Meals",
                    date: today,
                    foods: todayFoods,
                    stats: todayStats,
                  ),

                // Yesterday's Section
                if (yesterdayFoods.isNotEmpty)
                  _buildDateSection(
                    title: "Yesterday's Meals",
                    date: yesterday,
                    foods: yesterdayFoods,
                    stats: yesterdayStats,
                  ),

                // Before Yesterday Section
                if (beforeYesterdayFoods.isNotEmpty)
                  _buildPreviousDaysSection(
                    title: "Previous Days",
                    foods: beforeYesterdayFoods,
                    stats: beforeYesterdayStats,
                  ),

                if (todayFoods.isEmpty && yesterdayFoods.isEmpty && beforeYesterdayFoods.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(50),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(Icons.fastfood, size: 60, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text(
                            selectedIndex == 0 ? "No meals found" : "No ${selectedIndex == 1 ? 'Meal 1' : (selectedIndex == 2 ? 'Meal 2' : 'Meal 3')} found",
                            style: const TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterButton(String title, int index) {
    bool isSelected = selectedIndex == index;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedIndex = index;
            calculateStatistics();
          });
        },
        child: Container(
          height: 35,
          width: title == "All" ? 50 : 70,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: isSelected
                ? const LinearGradient(
              colors: [Color(0xFF5AFF15), Color(0xFF00B712)],
            )
                : null,
            color: isSelected ? null : Colors.white,
          ),
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateSection({
    required String title,
    required DateTime date,
    required List<Map<String, dynamic>> foods,
    required Map<String, dynamic> stats,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with date
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFE9FDE3),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "${date.day}/${date.month}/${date.year}",
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF00B712),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // Summary Card
        if (stats.isNotEmpty && stats['totalItems'] > 0)
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF5AFF15), Color(0xFF00B712)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(
                      icon: Icons.food_bank,
                      label: "Total Items",
                      value: stats['totalItems'].toString(),
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: Colors.white.withOpacity(0.3),
                    ),
                    _buildStatItem(
                      icon: Icons.local_fire_department,
                      label: "Total Calories",
                      value: "${stats['totalCalories']} kcal",
                    ),
                  ],
                ),
                if (stats.containsKey('mealsData') && stats['mealsData'].isNotEmpty) ...[
                  const SizedBox(height: 8),
                  const Divider(color: Colors.white),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (var entry in stats['mealsData'].entries)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _getMealIcon(entry.key),
                              const SizedBox(width: 4),
                              Text(
                                "${entry.key}: ${entry.value['items']} items",
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),

        // Foods List
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: foods.length,
          itemBuilder: (context, index) {
            final food = foods[index];
            return _buildHistoryTile(food);
          },
        ),

        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildPreviousDaysSection({
    required String title,
    required List<Map<String, dynamic>> foods,
    required Map<String, dynamic> stats,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.black,
          ),
        ),

        const SizedBox(height: 8),

        // Overall Summary for all previous days
        if (stats.isNotEmpty && stats['totalItems'] > 0)
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF5AFF15), Color(0xFF00B712)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(
                      icon: Icons.food_bank,
                      label: "Total Items",
                      value: stats['totalItems'].toString(),
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: Colors.white.withOpacity(0.3),
                    ),
                    _buildStatItem(
                      icon: Icons.local_fire_department,
                      label: "Total Calories",
                      value: "${stats['totalCalories']} kcal",
                    ),
                  ],
                ),
                if (stats.containsKey('dailyData') && stats['dailyData'].isNotEmpty) ...[
                  const SizedBox(height: 8),
                  const Divider(color: Colors.white),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (var entry in stats['dailyData'].entries)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Text(
                                entry.key,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                "${entry.value['items']} items",
                                style: const TextStyle(
                                  fontSize: 9,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),

        // Foods List
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: foods.length,
          itemBuilder: (context, index) {
            final food = foods[index];
            return _buildHistoryTile(food);
          },
        ),

        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildStatItem({
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

  Widget _getMealIcon(String mealName) {
    switch (mealName.toLowerCase()) {
      case 'meal 1':
        return const Icon(Icons.brightness_5, size: 14, color: Colors.white);
      case 'meal 2':
        return const Icon(Icons.sunny, size: 14, color: Colors.white);
      case 'meal 3':
        return const Icon(Icons.nightlight_round, size: 14, color: Colors.white);
      default:
        return const Icon(Icons.restaurant, size: 14, color: Colors.white);
    }
  }

  Widget _buildHistoryTile(Map<String, dynamic> food) {
    // Get quantity and calories
    int qty = 1;
    if (food.containsKey('consumptions') && food['consumptions'] != null && food['consumptions'].isNotEmpty) {
      qty = int.tryParse(food['consumptions'][0]['foodQuantity'].toString()) ?? 1;
    }
    int kcal = int.tryParse(food['calories'].toString()) ?? 0;
    int totalKcal = qty * kcal;

    // Get date
    String dateStr = '';
    if (food.containsKey('consumptions') && food['consumptions'] != null && food['consumptions'].isNotEmpty) {
      DateTime date = DateTime.tryParse(food['consumptions'][0]['date']) ?? DateTime.now();
      dateStr = "${date.day}/${date.month}/${date.year}";
    }

    String mealType = food['mealType'] ?? 'Meal 1';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          // Food Image
          if (food['foodImageUrl'] != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                food['foodImageUrl'],
                height: 55,
                width: 55,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 55,
                    width: 55,
                    color: const Color(0xFFE9FDE3),
                    child: const Icon(Icons.food_bank, color: Color(0xFF00B712)),
                  );
                },
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
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE9FDE3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _getMealIcon(mealType),
                          const SizedBox(width: 4),
                          Text(
                            mealType,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF00B712),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "Qty: $qty",
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00B712).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "$totalKcal kcal",
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF00B712),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        dateStr,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}