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


  FirebaseDataModelClass( {

    this.userId,
    this.username,
    this.email,
    this.password,
    this.gender,
    this.height,
    this.heightUnit, this.weightUnit,
    this.weight,
    this.dateOfBirth,
    this.selectedDietHabits,
    this.selectedHealthIssues,
    this.privacyPolicyAccepted
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (userId != null) data['userId'] = userId;
    if (email != null) data['email'] = email;
    if (password != null) data['password'] = password;
    if (username != null) data['username'] = username;
    if (gender != null) data['gender'] = gender;
    if (height != null) data['height'] = height;
    if (heightUnit != null) data['heightUnit'] = heightUnit;
    if (weight != null) data['weight'] = weight;
    if (weightUnit != null) data['weightUnit'] = weightUnit;
    if (dateOfBirth != null) data['dateOfBirth'] = dateOfBirth!.toIso8601String();
    if (selectedDietHabits != null) data['selectedDietHabits'] = selectedDietHabits;
    if (selectedHealthIssues != null) data['selectedHealthIssues'] = selectedHealthIssues;
    if (privacyPolicyAccepted != null) data['privacyPolicyAccepted'] = privacyPolicyAccepted;
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
      heightUnit: (json['heightUnit'] as String?),
      weight: (json['weight'] as num?)?.toDouble(),
      weightUnit: (json['weightUnit'] as String),
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.tryParse(json['dateOfBirth'])
          : null,
      selectedDietHabits: toList(json['selectedDietHabits']),
      selectedHealthIssues: toList(json['selectedHealthIssues']),
      privacyPolicyAccepted: json['privacyPolicyAccepted'] as bool?,

    );
  }

}
