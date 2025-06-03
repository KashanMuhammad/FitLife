class FirebaseDataModelClass {
  final String userId;
  final String username;
  final String gender;
  final double height;
  final double weight;
  final DateTime dateOfBirth;
  final List<String> selectedDietHabits;
  final List<String> selectedHealthIssues;

  FirebaseDataModelClass({
    required this.username,
    required this.gender,
    required this.height,
    required this.weight,
    required this.dateOfBirth,
    required this.selectedDietHabits,
    required this.selectedHealthIssues,
    required this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
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
