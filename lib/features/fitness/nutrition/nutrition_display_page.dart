import 'package:flutter/material.dart';

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
}

class DetailedNutritionPage extends StatelessWidget {
  final UserProfile userProfile;

  DetailedNutritionPage({required this.userProfile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Personalized Nutrition Plan'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCalorieBreakdown(),
            SizedBox(height: 24),
            _buildMacronutrientBreakdown(),
            SizedBox(height: 24),
            _buildMealPlan(),
            SizedBox(height: 24),
            _buildNutrientRecommendations(),
            SizedBox(height: 24),
            _buildHydrationGuide(),
            SizedBox(height: 24),
            _buildDietaryConsiderations(),
          ],
        ),
      ),
    );
  }

  Widget _buildCalorieBreakdown() {
    int bmr = _calculateBMR();
    int tdee = _calculateTDEE(bmr);
    int targetCalories = _calculateTargetCalories(tdee);

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Calorie Breakdown',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Basal Metabolic Rate (BMR): $bmr kcal'),
            Text('Total Daily Energy Expenditure (TDEE): $tdee kcal'),
            Text('Daily Calorie Target: $targetCalories kcal'),
            SizedBox(height: 8),
            Text(
                'Note: This calorie target is adjusted based on your goal of ${userProfile.goal}.'),
          ],
        ),
      ),
    );
  }

  Widget _buildMacronutrientBreakdown() {
    int targetCalories =
        _calculateTargetCalories(_calculateTDEE(_calculateBMR()));
    int proteinGrams = (targetCalories * 0.3 / 4).round();
    int carbGrams = (targetCalories * 0.4 / 4).round();
    int fatGrams = (targetCalories * 0.3 / 9).round();

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Macronutrient Breakdown',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(
                'Protein: $proteinGrams g (${(proteinGrams * 4).round()} kcal, 30%)'),
            Text(
                'Carbohydrates: $carbGrams g (${(carbGrams * 4).round()} kcal, 40%)'),
            Text('Fat: $fatGrams g (${(fatGrams * 9).round()} kcal, 30%)'),
            SizedBox(height: 8),
            Text('Note: This breakdown is optimized for ${userProfile.goal}.'),
          ],
        ),
      ),
    );
  }

  Widget _buildMealPlan() {
    int targetCalories =
        _calculateTargetCalories(_calculateTDEE(_calculateBMR()));

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Suggested Meal Plan',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Breakfast: ${(targetCalories * 0.25).round()} kcal'),
            Text('  - Protein-rich option (e.g., eggs, Greek yogurt)'),
            Text(
                '  - Complex carbohydrates (e.g., oatmeal, whole grain toast)'),
            Text('  - Healthy fats (e.g., avocado, nuts)'),
            Text('  - Fruits for vitamins and fiber'),
            SizedBox(height: 8),
            Text('Lunch: ${(targetCalories * 0.35).round()} kcal'),
            Text('  - Lean protein (e.g., chicken, fish, tofu)'),
            Text('  - Complex carbohydrates (e.g., brown rice, quinoa)'),
            Text('  - Large portion of vegetables'),
            Text('  - Healthy fats (e.g., olive oil dressing)'),
            SizedBox(height: 8),
            Text('Dinner: ${(targetCalories * 0.3).round()} kcal'),
            Text('  - Lean protein'),
            Text('  - Complex carbohydrates'),
            Text('  - Large portion of vegetables'),
            Text('  - Healthy fats'),
            SizedBox(height: 8),
            Text('Snacks: ${(targetCalories * 0.1).round()} kcal'),
            Text('  - Fruits, vegetables, nuts, or low-fat dairy'),
            SizedBox(height: 8),
            Text(
                'Note: Adjust portion sizes to meet calorie goals. Aim for a variety of foods to ensure a wide range of nutrients.'),
          ],
        ),
      ),
    );
  }

  Widget _buildNutrientRecommendations() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Key Nutrient Recommendations',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Fiber: 25-30g per day'),
            Text('Calcium: 1000-1200mg per day'),
            Text('Iron: 8-18mg per day (higher for menstruating women)'),
            Text('Vitamin D: 600-800 IU per day'),
            Text('Omega-3 fatty acids: Include fatty fish 2-3 times per week'),
            SizedBox(height: 8),
            Text(
                'Note: These are general recommendations. Consult a healthcare provider for personalized advice.'),
          ],
        ),
      ),
    );
  }

  Widget _buildHydrationGuide() {
    double waterIntake =
        userProfile.weight * 0.03; // 30ml per kg of body weight

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hydration Guide',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(
                'Recommended daily water intake: ${waterIntake.toStringAsFixed(1)} liters'),
            Text(
                'This is approximately ${(waterIntake * 1000 / 250).round()} glasses of water.'),
            SizedBox(height: 8),
            Text(
                'Note: Increase intake during hot weather or intense physical activity.'),
          ],
        ),
      ),
    );
  }

  Widget _buildDietaryConsiderations() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Dietary Considerations',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('- Choose whole, unprocessed foods when possible'),
            Text('- Limit added sugars and saturated fats'),
            Text('- Include a variety of colorful fruits and vegetables'),
            Text('- Opt for lean proteins and plant-based protein sources'),
            Text('- Choose whole grains over refined grains'),
            Text('- Consider timing of meals around your daily activities'),
            SizedBox(height: 8),
            Text(
                'Note: These are general guidelines. Adapt them to your personal preferences and any dietary restrictions.'),
          ],
        ),
      ),
    );
  }

  int _calculateBMR() {
    // Mifflin-St Jeor Equation
    double bmr;
    if (userProfile.gender == 'Male') {
      bmr = 10 * userProfile.weight +
          6.25 * userProfile.height -
          5 * userProfile.age +
          5;
    } else {
      bmr = 10 * userProfile.weight +
          6.25 * userProfile.height -
          5 * userProfile.age -
          161;
    }
    return bmr.round();
  }

  int _calculateTDEE(int bmr) {
    double activityFactor;
    switch (userProfile.fitnessLevel) {
      case 'Beginner':
        activityFactor = 1.375;
        break;
      case 'Intermediate':
        activityFactor = 1.55;
        break;
      case 'Advanced':
        activityFactor = 1.725;
        break;
      default:
        activityFactor = 1.375;
    }
    return (bmr * activityFactor).round();
  }

  int _calculateTargetCalories(int tdee) {
    switch (userProfile.goal) {
      case 'Weight Loss':
        return (tdee * 0.85).round(); // 15% calorie deficit
      case 'Muscle Gain':
        return (tdee * 1.1).round(); // 10% calorie surplus
      case 'General Fitness':
        return tdee;
      default:
        return tdee;
    }
  }
}
