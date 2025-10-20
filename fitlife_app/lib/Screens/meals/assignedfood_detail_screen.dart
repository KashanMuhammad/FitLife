import 'package:flutter/material.dart';
import 'package:shared/user_0nboarding_data_model_class.dart';


class AssignedFoodDetailScreen extends StatefulWidget {
  final List<FoodModel> assignedFoods;
  final int initialIndex;

  const AssignedFoodDetailScreen({
    super.key,
    required this.assignedFoods,
    this.initialIndex = 0,
  });

  @override
  State<AssignedFoodDetailScreen> createState() => _AssignedFoodDetailScreenState();
}

class _AssignedFoodDetailScreenState extends State<AssignedFoodDetailScreen> {
  late PageController _pageController;
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget buildFoodDetails(FoodModel food) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (food.foodImageUrl != null)
              Center(
                child: Image.network(
                  food.foodImageUrl!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 20),
            Text(food.foodName, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text("Calories: ${food.calories}", style: const TextStyle(fontSize: 16)),
            Text("Meal Type: ${food.mealType ?? '-'}", style: const TextStyle(fontSize: 16)),
            if (food.quantity != null)
              Text("Quantity: ${food.quantity}", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text("Description:", style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(food.foodDescription),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final foods = widget.assignedFoods;

    return Scaffold(
      appBar: AppBar(
        title: Text("${currentIndex + 1}/${foods.length}"),
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: foods.length,
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        itemBuilder: (context, index) {
          final food = foods[index]; // <-- make sure this gets the correct food
          return buildFoodDetails(food);
        },
      ),
    );
  }
}
