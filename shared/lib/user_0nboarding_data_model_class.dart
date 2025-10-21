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

  // ✅ Assigned foods list
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

  // ✅ Convert object to JSON (only non-null fields)
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    void addIfNotNull(String key, dynamic value) {
      if (value != null) data[key] = value;
    }

    // --- USER INFO ---
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

    // --- FOOD INFO ---
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

    // --- DIET INFO ---
    addIfNotNull('dietTitle', dietTitle);
    addIfNotNull('dietDescription', dietDescription);
    addIfNotNull('selectedMealType', selectedMealType);
    addIfNotNull('day', day);
    addIfNotNull('timeToEat', timeToEat);
    addIfNotNull('listOfFood', listOfFood);
    addIfNotNull('duration', duration);
    addIfNotNull('suitableFor', suitableFor);
    addIfNotNull('dietTag', dietTag);
    addIfNotNull('createdBy', createdBy);
    addIfNotNull('createdAt', createdAt);
    addIfNotNull('dietImageUrl', dietImageUrl);

    // --- BLOG INFO ---
    addIfNotNull('blogTitle', blogTitle);
    addIfNotNull('blogShortDescription', blogShortDescription);
    addIfNotNull('blogFullContent', blogFullContent);
    addIfNotNull('blogAuthorName', blogAuthorName);
    addIfNotNull('blogCategory', blogCategory);
    addIfNotNull('blogImageUrl', blogImageUrl);

    // --- FOODS ---
    if (assignedFoods != null) {
      addIfNotNull('assignedFoods', assignedFoods!.map((f) => f.toJson()).toList());
    }

    if (userSelectedFood != null) {
      addIfNotNull('userSelectedFood', userSelectedFood!.map((f) => f.toJson()).toList());
    }

    return data;
  }

  // ✅ Factory to create from JSON
  factory FirebaseDataModelClass.fromJson(Map<String, dynamic> json) {
    List<String>? toList(dynamic value) {
      if (value == null) return null;
      if (value is String) return [value];
      if (value is Iterable) return List<String>.from(value);
      return null;
    }

    return FirebaseDataModelClass(
      userId: json['userId'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String?,
      username: json['username'] as String?,
      gender: json['gender'] as String?,
      height: (json['height'] as num?)?.toDouble(),
      heightUnit: json['heightUnit'] as String?,
      weight: (json['weight'] as num?)?.toDouble(),
      weightUnit: json['weightUnit'] as String?,
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.tryParse(json['dateOfBirth'])
          : null,
      selectedDietHabits: toList(json['selectedDietHabits']),
      selectedHealthIssues: toList(json['selectedHealthIssues']),
      privacyPolicyAccepted: json['privacyPolicyAccepted'] as bool?,
      profileImageUrl: json['profileImageUrl'] as String?,
      foodName: json['foodName'] as String?,
      foodDescription: json['foodDescription'] as String?,
      foodImageUrl: json['foodImageUrl'] as String?,
      quantity: json['quantity'] as String?,
      caloriesPerServing: json['caloriesPerServing'] as String?,
      selectedUnits: json['selectedUnits'] as String?,
      protein: json['protein'] as String?,
      carbohydrates: json['carbohydrates'] as String?,
      fats: json['fats'] as String?,
      tag: json['tag'] as String?,
      selectedTag: json['selectedTag'] as String?,
      dietTitle: json['dietTitle'] as String?,
      dietImageUrl: json['dietImageUrl'] as String?,
      dietDescription: json['dietDescription'] as String?,
      selectedMealType: json['selectedMealType'] as String?,
      day: json['day'] as String?,
      timeToEat: json['timeToEat'] as String?,
      listOfFood: toList(json['listOfFood']),
      duration: json['duration'] as String?,
      suitableFor: json['suitableFor'] as String?,
      dietTag: json['dietTag'] as String?,
      createdBy: json['createdBy'] as String?,
      createdAt: json['createdAt'] as String?,
      blogTitle: json['blogTitle'] as String?,
      blogShortDescription: json['blogShortDescription'] as String?,
      blogImageUrl: json['blogImageUrl'] as String?,
      blogFullContent: json['blogFullContent'] as String?,
      blogCategory: json['blogCategory'] as String?,
      blogAuthorName: json['blogAuthorName'] as String?,
      assignedFoods: (json['assignedFoods'] as List<dynamic>?)
          ?.map((item) => FoodModel.fromMap(item))
          .toList(),
      userSelectedFood: (json['userSelectedFood'] as List<dynamic>?)
          ?.map((item) => FoodModel.fromMap(item))
          .toList(),
    );
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

  FoodModel({
    required this.foodName,
    required this.calories,
    required this.foodDescription,
    required this.consumptions,
    required this.quantity,
    required this.mealType,
    this.foodImageUrl,
  });

  factory FoodModel.fromMap(Map<String, dynamic> data) {
    return FoodModel(
      foodName: data['foodName'] ?? '',
      calories: data['caloriesPerServing'] ?? '0',
      foodDescription: data['foodDescription'] ?? '',
      quantity: data['quantity'],
      foodImageUrl: data['foodImageUrl'],
      mealType: data['mealType'] ?? data['selectedMealType'] ?? '',
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
      'consumptions': consumptions.map((e) => e.toJson()).toList(),
    };
  }
}

// ✅ Consumption Entry Model
class ConsumptionEntry {
  final String date;
  final String foodQuantity;
  final String mealType;

  ConsumptionEntry({
    required this.date,
    required this.foodQuantity,
    required this.mealType,
  });

  factory ConsumptionEntry.fromMap(Map<String, dynamic> data) {
    return ConsumptionEntry(
      date: data['date'] ?? '',
      foodQuantity: data['foodQuantity'] ?? '0',
      mealType: data['mealType'] ?? 'Unknown',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'foodQuantity': foodQuantity,
      'mealType': mealType,
    };
  }
}
