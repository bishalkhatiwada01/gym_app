class NutritionPlan {
  final Map<String, dynamic> calorieBreakdown;
  final Map<String, dynamic> macronutrientBreakdown;
  final Map<String, dynamic> mealPlan;
  final Map<String, String> nutrientRecommendations;
  final Map<String, dynamic> hydrationGuide;
  final List<String> dietaryConsiderations;

  NutritionPlan({
    required this.calorieBreakdown,
    required this.macronutrientBreakdown,
    required this.mealPlan,
    required this.nutrientRecommendations,
    required this.hydrationGuide,
    required this.dietaryConsiderations,
  });

  factory NutritionPlan.fromMap(Map<String, dynamic> map) {
    return NutritionPlan(
      calorieBreakdown: map['nutrition_plan']['calorie_breakdown'],
      macronutrientBreakdown: map['nutrition_plan']['macronutrient_breakdown'],
      mealPlan: map['nutrition_plan']['meal_plan'],
      nutrientRecommendations: Map<String, String>.from(
          map['nutrition_plan']['nutrient_recommendations']),
      hydrationGuide: map['nutrition_plan']['hydration_guide'],
      dietaryConsiderations:
          List<String>.from(map['nutrition_plan']['dietary_considerations']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nutrition_plan': {
        'calorie_breakdown': calorieBreakdown,
        'macronutrient_breakdown': macronutrientBreakdown,
        'meal_plan': mealPlan,
        'nutrient_recommendations': nutrientRecommendations,
        'hydration_guide': hydrationGuide,
        'dietary_considerations': dietaryConsiderations,
      },
    };
  }
}
