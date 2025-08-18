class FirebaseDataModelClass {
  final String? userId;
  final String? username;
  final String? email;
  final String? password;
  final String? gender;
  final double? height;
  final double? weight;
  final DateTime? dateOfBirth;
  final List<String>? selectedDietHabits;
  final List<String>? selectedHealthIssues;
  final bool? privacyPolicyAccepted;

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

  final String? blogTitle;
  final String? blogShortDescription;
  final String? blogFullContent;
  final String? blogAuthorName;
  final String? blogCategory;

  FirebaseDataModelClass({
    this.userId,
    this.username,
    this.email,
    this.password,
    this.gender,
    this.height,
    this.weight,
    this.dateOfBirth,
    this.selectedDietHabits,
    this.selectedHealthIssues,
    this.privacyPolicyAccepted,


    this.foodName,
    this.foodDescription,
    this.quantity,
    this.selectedUnits,
    this.caloriesPerServing,
    this.protein,
    this.carbohydrates,
    this.fats,
    this.tag,
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
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (userId != null) data['userId'] = userId;
    if (email != null) data['email'] = email;
    if (password != null) data['password'] = password;
    if (username != null) data['username'] = username;
    if (gender != null) data['gender'] = gender;
    if (height != null) data['height'] = height;
    if (weight != null) data['weight'] = weight;
    if (dateOfBirth != null) data['dateOfBirth'] = dateOfBirth!.toIso8601String();
    if (selectedDietHabits != null) data['selectedDietHabits'] = selectedDietHabits;
    if (selectedHealthIssues != null) data['selectedHealthIssues'] = selectedHealthIssues;
    if (privacyPolicyAccepted != null) data['privacyPolicyAccepted'] = privacyPolicyAccepted;

    if (foodName != null) data['foodName'] = foodName;
    if (foodDescription != null) data['foodDescription'] = foodDescription;
    if (quantity != null) data['quantity'] = quantity;
    if (selectedUnits != null) data['selectedUnits'] = selectedUnits;
    if (caloriesPerServing != null) data['caloriesPerServing'] = caloriesPerServing;
    if (protein != null) data['protein'] = protein;
    if (carbohydrates != null) data['carbohydrates'] = carbohydrates;
    if (fats != null) data['fats'] = fats;
    if (tag != null) data['tag'] = tag;
    if (selectedTag != null) data['selectedTag'] = selectedTag;

    if (dietTitle != null) data['dietTitle'] = dietTitle;
    if (dietDescription != null) data['dietDescription'] = dietDescription;
    if (selectedMealType != null) data['selectedMealType'] = selectedMealType;
    if (day != null) data['day'] = day;
    if (timeToEat != null) data['timeToEat'] = timeToEat;
    if (listOfFood != null) data['listOfFood'] = listOfFood;
    if (duration != null) data['duration'] = duration;
    if (suitableFor  != null) data['suitableFor'] = suitableFor;
    if (dietTag != null) data['dietTag'] = dietTag;
    if (createdBy != null) data['createdBy'] = createdBy;
    if (createdAt != null) data['createdAt'] = createdAt;

    if (blogTitle != null) data['blogTitle'] = blogTitle;
    if (blogShortDescription != null) data['blogShortDescription'] = blogShortDescription;
    if (blogFullContent != null) data['blogFullContent'] = blogFullContent;
    if (blogCategory != null) data['blogCategory'] = blogCategory;
    if (blogAuthorName != null) data['blogAuthorName'] = blogAuthorName;

    return data;
  }

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
      weight: (json['weight'] as num?)?.toDouble(),
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
    );
  }

}
