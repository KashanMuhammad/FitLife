class FoodModel {
  final String foodName;
  final String calories;
  final String quantity;

  FoodModel({
    required this.foodName,
    required this.calories,
    required this.quantity,
  });

  factory FoodModel.fromMap(Map<String, dynamic> data) {
    return FoodModel(
      foodName: data['foodName'] ?? '',
      calories: data['caloriesPerServing'] ?? '0',
      quantity: data['quantity'] ?? '0',
    );
  }
}
