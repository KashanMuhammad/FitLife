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

  // Blog fields
  final String? blogTitle;
  final String? blogShortDescription;
  final String? blogFullContent;
  final String? blogAuthorName;
  final String? blogCategory;

  // ✅ Assigned foods list
  final List<FoodModel>? assignedFoods;

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
  });

  // ✅ Convert object to JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['userId'] = userId;
    data['email'] = email;
    data['password'] = password;
    data['username'] = username;
    data['gender'] = gender;
    data['height'] = height;
    data['heightUnit'] = heightUnit;
    data['weight'] = weight;
    data['weightUnit'] = weightUnit;
    if (dateOfBirth != null) {
      data['dateOfBirth'] = dateOfBirth!.toIso8601String();
    }
    data['selectedDietHabits'] = selectedDietHabits;
    data['selectedHealthIssues'] = selectedHealthIssues;
    data['privacyPolicyAccepted'] = privacyPolicyAccepted;

    data['foodName'] = foodName;
    data['foodDescription'] = foodDescription;
    data['quantity'] = quantity;
    data['selectedUnits'] = selectedUnits;
    data['caloriesPerServing'] = caloriesPerServing;
    data['protein'] = protein;
    data['carbohydrates'] = carbohydrates;
    data['fats'] = fats;
    data['tag'] = tag;
    data['selectedTag'] = selectedTag;

    data['dietTitle'] = dietTitle;
    data['dietDescription'] = dietDescription;
    data['selectedMealType'] = selectedMealType;
    data['day'] = day;
    data['timeToEat'] = timeToEat;
    data['listOfFood'] = listOfFood;
    data['duration'] = duration;
    data['suitableFor'] = suitableFor;
    data['dietTag'] = dietTag;
    data['createdBy'] = createdBy;
    data['createdAt'] = createdAt;

    data['blogTitle'] = blogTitle;
    data['blogShortDescription'] = blogShortDescription;
    data['blogFullContent'] = blogFullContent;
    data['blogCategory'] = blogCategory;
    data['blogAuthorName'] = blogAuthorName;

    if (assignedFoods != null) {
      data['assignedFoods'] =
          assignedFoods!.map((f) => f.toJson()).toList();
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
      foodName: json['foodName'] as String?,
      foodDescription: json['foodDescription'] as String?,
      quantity: json['quantity'] as String?,
      caloriesPerServing: json['caloriesPerServing'] as String?,
      selectedUnits: json['selectedUnits'] as String?,
      protein: json['protein'] as String?,
      carbohydrates: json['carbohydrates'] as String?,
      fats: json['fats'] as String?,
      tag: json['tag'] as String?,
      selectedTag: json['selectedTag'] as String?,
      dietTitle: json['dietTitle'] as String?,
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
      blogFullContent: json['blogFullContent'] as String?,
      blogCategory: json['blogCategory'] as String?,
      blogAuthorName: json['blogAuthorName'] as String?,
      assignedFoods: (json['assignedFoods'] as List<dynamic>?)
          ?.map((item) => FoodModel.fromMap(item))
          .toList(),
    );
  }
}

class FoodModel {
  final String foodName;
  final String calories;
  final String quantity;
  final String foodDescription;
  FoodModel( {
    required this.foodDescription,
    required this.foodName,
    required this.calories,
    required this.quantity,
  });

  factory FoodModel.fromMap(Map<String, dynamic> data) {
    return FoodModel(
      foodName: data['foodName'] ?? '',
      calories: data['caloriesPerServing'] ?? '0',
      quantity: data['quantity'] ?? '0',
      foodDescription: data['foodDescription'] ,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'foodName': foodName,
      'caloriesPerServing': calories,
      'quantity': quantity,
      'foodDescription': foodDescription
    };
  }
}
