import 'package:flutter/material.dart';

class MealDetailScreen extends StatelessWidget {
  final String mealType;
  final List<Map<String, dynamic>> meals;
  final int totalCalories;
  final int totalItems;

  const MealDetailScreen({
    super.key,
    required this.mealType,
    required this.meals,
    required this.totalCalories,
    required this.totalItems,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF5AFF15), Color(0xFF00B712)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                      const Spacer(),
                      Text(
                        mealType,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      const SizedBox(width: 48), // For balance
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Summary Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            const Icon(Icons.food_bank, color: Color(0xFF00B712), size: 28),
                            const SizedBox(height: 8),
                            Text(
                              totalItems.toString(),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const Text(
                              "Total Items",
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                        Container(
                          width: 1,
                          height: 50,
                          color: Colors.grey[300],
                        ),
                        Column(
                          children: [
                            const Icon(Icons.local_fire_department, color: Color(0xFF00B712), size: 28),
                            const SizedBox(height: 8),
                            Text(
                              "$totalCalories",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const Text(
                              "Total Calories",
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Meals List
            Expanded(
              child: meals.isEmpty
                  ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.fastfood, size: 80, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      "No meals found",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Add meals from your diet plan",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              )
                  : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: meals.length,
                itemBuilder: (context, index) {
                  final meal = meals[index];
                  return _buildMealCard(meal);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealCard(Map<String, dynamic> meal) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Food Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: meal['foodImageUrl'] != null && meal['foodImageUrl'].toString().isNotEmpty
                ? Image.network(
              meal['foodImageUrl'],
              height: 80,
              width: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 80,
                  width: 80,
                  color: const Color(0xFFE9FDE3),
                  child: const Icon(Icons.food_bank, color: Color(0xFF00B712), size: 40),
                );
              },
            )
                : Container(
              height: 80,
              width: 80,
              color: const Color(0xFFE9FDE3),
              child: const Icon(Icons.food_bank, color: Color(0xFF00B712), size: 40),
            ),
          ),
          const SizedBox(width: 12),

          // Food Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meal['foodName'] ?? 'Unknown Food',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                if (meal['foodDescription'] != null && meal['foodDescription'].toString().isNotEmpty)
                  Text(
                    meal['foodDescription'],
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildInfoChip(
                      Icons.restaurant,
                      "Qty: ${meal['quantity']}",
                    ),
                    _buildInfoChip(
                      Icons.local_fire_department,
                      "${meal['calories']} kcal/serving",
                    ),
                    _buildInfoChip(
                      Icons.calculate,
                      "Total: ${meal['totalCalories']} kcal",
                      isTotal: true,
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

  Widget _buildInfoChip(IconData icon, String label, {bool isTotal = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isTotal ? const Color(0xFF00B712).withOpacity(0.1) : const Color(0xFFE9FDE3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: isTotal ? const Color(0xFF00B712) : Colors.grey[600]),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal,
              color: isTotal ? const Color(0xFF00B712) : Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}