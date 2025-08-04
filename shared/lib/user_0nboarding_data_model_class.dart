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

    );
  }

}
