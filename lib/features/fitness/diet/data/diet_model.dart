class DietPlan {
  final Map<String, dynamic> userProfile;
  final List<Map<String, dynamic>> weeklyMealPlan;
  final List<String> nutritionTips;

  DietPlan({
    required this.userProfile,
    required this.weeklyMealPlan,
    required this.nutritionTips,
  });

  factory DietPlan.fromMap(Map<String, dynamic> data) {
    return DietPlan(
      userProfile: data['user_profile'],
      weeklyMealPlan: List<Map<String, dynamic>>.from(data['weekly_meal_plan']),
      nutritionTips: List<String>.from(data['nutrition_tips']),
    );
  }
}
