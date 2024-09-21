class UserProfile {
  final int age;
  final double weight;
  final double height;
  final String fitnessLevel;
  final String goal;
  final String gender;
  final double? targetWeight;

  UserProfile({
    required this.age,
    required this.weight,
    required this.height,
    required this.fitnessLevel,
    required this.goal,
    required this.gender,
    this.targetWeight,
  });

  Map<String, dynamic> toMap() {
    return {
      'age': age,
      'weight': weight,
      'height': height,
      'fitnessLevel': fitnessLevel,
      'goal': goal,
      'gender': gender,
      'targetWeight': targetWeight,
    };
  }
}
