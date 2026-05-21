// ✅ Firebase Data Model
class FirebaseDataModelClass {
  final String? userId;
  final String? username;
  final String? email;
  final String? password;
  final String? gender;
  final double? height;
  final String? heightUnit;
  final double? weight;
  final String? weightUnit;
  final DateTime? dateOfBirth;
  final List<String>? selectedDietHabits;
  final List<String>? selectedHealthIssues;
  final bool? privacyPolicyAccepted;
  final String? profileImageUrl;

  // Food fields
  final String? foodName;
  final String? foodDescription;
  final String? quantity;
  final String? caloriesPerServing;
  final String? protein;
  final String? carbohydrates;
  final String? fats;
  final String? tag;
  final String? selectedUnits;
  final String? selectedTag;
  final String? foodImageUrl;

  // Diet fields
  final String? dietTitle;
  final String? dietDescription;
  final String? selectedMealType;
  final String? day;
  final String? timeToEat;
  final List<String>? listOfFood;
  final String? duration;
  final String? suitableFor;
  final String? dietTag;
  final String? createdBy;
  final String? createdAt;
  final String? dietImageUrl;

  // Blog fields
  final String? blogTitle;
  final String? blogShortDescription;
  final String? blogFullContent;
  final String? blogAuthorName;
  final String? blogCategory;
  final String? blogImageUrl;

  // Assigned foods
  final List<FoodModel>? assignedFoods;
  final List<FoodModel>? userSelectedFood;

  FirebaseDataModelClass({
    this.userId,
    this.username,
    this.email,
    this.password,
    this.gender,
    this.height,
    this.heightUnit,
    this.weight,
    this.weightUnit,
    this.dateOfBirth,
    this.selectedDietHabits,
    this.selectedHealthIssues,
    this.privacyPolicyAccepted,
    this.profileImageUrl,
    this.foodName,
    this.foodDescription,
    this.quantity,
    this.caloriesPerServing,
    this.protein,
    this.carbohydrates,
    this.fats,
    this.tag,
    this.selectedUnits,
    this.selectedTag,
    this.dietTitle,
    this.dietDescription,
    this.selectedMealType,
    this.day,
    this.timeToEat,
    this.listOfFood,
    this.duration,
    this.suitableFor,
    this.dietTag,
    this.createdBy,
    this.createdAt,
    this.blogTitle,
    this.blogShortDescription,
    this.blogFullContent,
    this.blogAuthorName,
    this.blogCategory,
    this.assignedFoods,
    this.userSelectedFood,
    this.dietImageUrl,
    this.blogImageUrl,
    this.foodImageUrl,
  });

  factory FirebaseDataModelClass.fromJson(Map<String, dynamic> json) {
    List<String>? toList(dynamic value) {
      if (value == null) return null;
      if (value is String) return [value];
      if (value is Iterable) return value.map((e) => e.toString()).toList();
      return null;
    }

    return FirebaseDataModelClass(
      userId: json['userId']?.toString(),
      email: json['email']?.toString(),
      password: json['password']?.toString(),
      username: json['username']?.toString(),
      gender: json['gender']?.toString(),
      height: (json['height'] as num?)?.toDouble(),
      heightUnit: json['heightUnit']?.toString(),
      weight: (json['weight'] as num?)?.toDouble(),
      weightUnit: json['weightUnit']?.toString(),
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.tryParse(json['dateOfBirth'])
          : null,
      selectedDietHabits: toList(json['selectedDietHabits']),
      selectedHealthIssues: toList(json['selectedHealthIssues']),
      privacyPolicyAccepted: json['privacyPolicyAccepted'] as bool?,
      profileImageUrl: json['profileImageUrl']?.toString(),
      foodName: json['foodName']?.toString(),
      foodDescription: json['foodDescription']?.toString(),
      foodImageUrl: json['foodImageUrl']?.toString(),
      quantity: json['quantity']?.toString(),
      caloriesPerServing: json['caloriesPerServing']?.toString(),
      selectedUnits: json['selectedUnits']?.toString(),
      protein: json['protein']?.toString(),
      carbohydrates: json['carbohydrates']?.toString(),
      fats: json['fats']?.toString(),
      tag: json['tag']?.toString(),
      selectedTag: json['selectedTag']?.toString(),
      dietTitle: json['dietTitle']?.toString(),
      dietImageUrl: json['dietImageUrl']?.toString(),
      dietDescription: json['dietDescription']?.toString(),
      selectedMealType: json['selectedMealType']?.toString(),
      day: json['day']?.toString(),
      timeToEat: json['timeToEat']?.toString(),
      listOfFood: toList(json['listOfFood']),
      duration: json['duration']?.toString(),
      suitableFor: json['suitableFor']?.toString(),
      dietTag: json['dietTag']?.toString(),
      createdBy: json['createdBy']?.toString(),
      createdAt: json['createdAt']?.toString(),
      blogTitle: json['blogTitle']?.toString(),
      blogShortDescription: json['blogShortDescription']?.toString(),
      blogImageUrl: json['blogImageUrl']?.toString(),
      blogFullContent: json['blogFullContent']?.toString(),
      blogCategory: json['blogCategory']?.toString(),
      blogAuthorName: json['blogAuthorName']?.toString(),
      assignedFoods: (json['assignedFoods'] as List<dynamic>?)
          ?.map((item) => FoodModel.fromMap(Map<String, dynamic>.from(item)))
          .toList(),
      userSelectedFood: (json['userSelectedFood'] as List<dynamic>?)
          ?.map((item) => FoodModel.fromMap(Map<String, dynamic>.from(item)))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    void addIfNotNull(String key, dynamic value) {
      if (value != null) data[key] = value;
    }

    addIfNotNull('userId', userId);
    addIfNotNull('email', email);
    addIfNotNull('password', password);
    addIfNotNull('username', username);
    addIfNotNull('gender', gender);
    addIfNotNull('height', height);
    addIfNotNull('heightUnit', heightUnit);
    addIfNotNull('weight', weight);
    addIfNotNull('weightUnit', weightUnit);
    addIfNotNull('dateOfBirth', dateOfBirth?.toIso8601String());
    addIfNotNull('selectedDietHabits', selectedDietHabits);
    addIfNotNull('selectedHealthIssues', selectedHealthIssues);
    addIfNotNull('privacyPolicyAccepted', privacyPolicyAccepted);
    addIfNotNull('profileImageUrl', profileImageUrl);
    addIfNotNull('foodName', foodName);
    addIfNotNull('foodDescription', foodDescription);
    addIfNotNull('quantity', quantity);
    addIfNotNull('selectedUnits', selectedUnits);
    addIfNotNull('caloriesPerServing', caloriesPerServing);
    addIfNotNull('protein', protein);
    addIfNotNull('carbohydrates', carbohydrates);
    addIfNotNull('fats', fats);
    addIfNotNull('tag', tag);
    addIfNotNull('selectedTag', selectedTag);
    addIfNotNull('foodImageUrl', foodImageUrl);
    addIfNotNull('dietTitle', dietTitle);
    addIfNotNull('dietDescription', dietDescription);
    addIfNotNull('selectedMealType', selectedMealType);
    addIfNotNull('day', day); // ← included
    addIfNotNull('timeToEat', timeToEat);
    addIfNotNull('listOfFood', listOfFood);
    addIfNotNull('duration', duration);
    addIfNotNull('suitableFor', suitableFor);
    addIfNotNull('dietTag', dietTag);
    addIfNotNull('createdBy', createdBy);
    addIfNotNull('createdAt', createdAt);
    addIfNotNull('dietImageUrl', dietImageUrl);
    addIfNotNull('blogTitle', blogTitle);
    addIfNotNull('blogShortDescription', blogShortDescription);
    addIfNotNull('blogFullContent', blogFullContent);
    addIfNotNull('blogAuthorName', blogAuthorName);
    addIfNotNull('blogCategory', blogCategory);
    addIfNotNull('blogImageUrl', blogImageUrl);
    if (assignedFoods != null) {
      addIfNotNull('assignedFoods', assignedFoods!.map((f) => f.toJson()).toList());
    }
    if (userSelectedFood != null) {
      addIfNotNull('userSelectedFood', userSelectedFood!.map((f) => f.toJson()).toList());
    }

    return data;
  }
}

// ✅ Food Model
class FoodModel {
  final String foodName;
  final String calories;
  final String foodDescription;
  final List<ConsumptionEntry> consumptions;
  final String? quantity;
  final String? mealType;
  final String? foodImageUrl;
  final String? day; // ← added

  FoodModel({
    required this.foodName,
    required this.calories,
    required this.foodDescription,
    required this.consumptions,
    required this.quantity,
    required this.mealType,
    this.foodImageUrl,
    this.day, // ← added
  });

  factory FoodModel.fromMap(Map<String, dynamic> data) {
    String name = '';
    String calories = '0';
    String description = '';
    String? imageUrl;
    String? mealType;
    String? quantity;
    String? day;

    if (data['foodName'] is Map) {
      final nested = Map<String, dynamic>.from(data['foodName']);
      name = nested['foodName'] ?? '';
      calories = nested['caloriesPerServing'] ?? '0';
      description = nested['foodDescription'] ?? '';
      imageUrl = nested['imageUrl'];
      mealType = data['mealType'] ?? data['selectedMealType'] ?? nested['meal'];
      quantity = data['quantity'] ?? nested['servingSize'];
      day = data['day'] ?? nested['day'] ?? "Day 1";
    } else {
      name = data['foodName'] ?? '';
      calories = data['caloriesPerServing'] ?? '0';
      description = data['foodDescription'] ?? '';
      imageUrl = data['foodImageUrl'] ?? data['imageUrl'];
      mealType = data['mealType'] ?? data['selectedMealType'] ?? '';
      quantity = data['quantity']?.toString();
      day = data['day'] ?? "Day 1";
    }

    return FoodModel(
      foodName: name,
      calories: calories,
      foodDescription: description,
      quantity: quantity,
      mealType: mealType,
      foodImageUrl: imageUrl,
      day: day, // ← added
      consumptions: (data['consumptions'] as List<dynamic>? ?? [])
          .map((e) => ConsumptionEntry.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'foodName': foodName,
      'caloriesPerServing': calories,
      'foodDescription': foodDescription,
      'mealType': mealType,
      'foodImageUrl': foodImageUrl,
      'day': day, // ← included
      'consumptions': consumptions.map((e) => e.toJson()).toList(),
      'quantity': quantity,
    };
  }
}

// ✅ Consumption Entry
class ConsumptionEntry {
  final String day; // ← already exists
  final String date;
  final String foodQuantity;
  final String mealType;

  ConsumptionEntry({
    required this.day,
    required this.date,
    required this.foodQuantity,
    required this.mealType,
  });

  factory ConsumptionEntry.fromMap(Map<String, dynamic> data) {
    return ConsumptionEntry(
      day: data['day'] ?? "Day 1",
      date: data['date'] ?? '',
      foodQuantity: data['foodQuantity'] ?? '0',
      mealType: data['mealType'] ?? 'Unknown',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "day": day,
      'date': date,
      'foodQuantity': foodQuantity,
      'mealType': mealType,
    };
  }
}