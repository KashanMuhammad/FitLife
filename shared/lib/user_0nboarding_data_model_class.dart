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

  FirebaseDataModelClass({
     this.email,
     this.password,
     this.username,
     this.gender,
     this.height,
     this.weight,
     this.dateOfBirth,
     this.selectedDietHabits,
     this.selectedHealthIssues,
     this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'email' : email,
      'password' : password,
      'username': username,
      'gender': gender,
      'height': height,
      'weight': weight,
      'dateOfBirth': dateOfBirth,
      'selectedDietHabits': selectedDietHabits,
      'selectedHealthIssues': selectedHealthIssues,
    };
  }

  factory FirebaseDataModelClass.fromJson(Map<String, dynamic> json) {
    return FirebaseDataModelClass(
      userId: json['userId'],
      email: json['email'],
      password: json['password'],
      username: json['username'],
      gender: json['gender'],
      height: (json['height'] as num).toDouble(),
      weight: (json['weight'] as num).toDouble(),
      dateOfBirth: DateTime.parse(json['dateOfBirth']),
      selectedDietHabits: List<String>.from(json['selectedDietHabits']),
      selectedHealthIssues: List<String>.from(json['selectedHealthIssues']),
    );
  }

}
