import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gymapp/features/fitness/common/user_model.dart';
import 'package:gymapp/features/fitness/workout_plan/pages/workout_input.dart';

class DetailedNutritionPage extends StatelessWidget {
  final UserProfile userProfile;

  const DetailedNutritionPage({super.key, required this.userProfile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Personalized Nutrition Plan'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCalorieBreakdown(),
            const SizedBox(height: 24),
            _buildMacronutrientBreakdown(),
            const SizedBox(height: 24),
            _buildMealPlan(),
            const SizedBox(height: 24),
            _buildNutrientRecommendations(),
            const SizedBox(height: 24),
            _buildHydrationGuide(),
            const SizedBox(height: 24),
            _buildDietaryConsiderations(),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => _submitNutritionPlan(context),
              child: const Text('Submit Nutrition Plan and Continue'),
            ),
          ],
        ),
      ),
    );
  }

  // ... (all existing build methods remain the same)

  Future<void> _submitNutritionPlan(BuildContext context) async {
    try {
      // Generate nutrition plan data
      Map<String, dynamic> nutritionPlan = {
        'calorie_breakdown': {
          'bmr': _calculateBMR(),
          'tdee': _calculateTDEE(_calculateBMR()),
          'target_calories':
              _calculateTargetCalories(_calculateTDEE(_calculateBMR())),
        },
        'macronutrient_breakdown': _generateMacronutrientBreakdown(),
        'meal_plan': _generateMealPlan(),
        'nutrient_recommendations': _generateNutrientRecommendations(),
        'hydration_guide': _generateHydrationGuide(),
        'dietary_considerations': _generateDietaryConsiderations(),
      };

      // Upload to Firebase
      await _uploadToFirebase(nutritionPlan);

      // Navigate to WorkoutInputPage
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WorkoutInputPage(userProfile: userProfile),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  Future<void> _uploadToFirebase(Map<String, dynamic> nutritionPlan) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').add({
        'user_profile':
            userProfile.toMap(), // Make sure UserProfile has a toMap() method
        'nutrition_plan': nutritionPlan,
        'created_at': FieldValue.serverTimestamp(),
      });
    } else {
      throw Exception('User not authenticated');
    }
  }

  Map<String, dynamic> _generateMacronutrientBreakdown() {
    int targetCalories =
        _calculateTargetCalories(_calculateTDEE(_calculateBMR()));
    int proteinGrams = (targetCalories * 0.3 / 4).round();
    int carbGrams = (targetCalories * 0.4 / 4).round();
    int fatGrams = (targetCalories * 0.3 / 9).round();

    return {
      'protein': {
        'grams': proteinGrams,
        'calories': proteinGrams * 4,
        'percentage': 30
      },
      'carbohydrates': {
        'grams': carbGrams,
        'calories': carbGrams * 4,
        'percentage': 40
      },
      'fat': {'grams': fatGrams, 'calories': fatGrams * 9, 'percentage': 30},
    };
  }

  Map<String, dynamic> _generateMealPlan() {
    int targetCalories =
        _calculateTargetCalories(_calculateTDEE(_calculateBMR()));

    return {
      'breakfast': {
        'calories': (targetCalories * 0.25).round(),
        'suggestions': [
          'Protein-rich option (e.g., eggs, Greek yogurt)',
          'Complex carbohydrates (e.g., oatmeal, whole grain toast)',
          'Healthy fats (e.g., avocado, nuts)',
          'Fruits for vitamins and fiber',
        ],
      },
      'lunch': {
        'calories': (targetCalories * 0.35).round(),
        'suggestions': [
          'Lean protein (e.g., chicken, fish, tofu)',
          'Complex carbohydrates (e.g., brown rice, quinoa)',
          'Large portion of vegetables',
          'Healthy fats (e.g., olive oil dressing)',
        ],
      },
      'dinner': {
        'calories': (targetCalories * 0.3).round(),
        'suggestions': [
          'Lean protein',
          'Complex carbohydrates',
          'Large portion of vegetables',
          'Healthy fats',
        ],
      },
      'snacks': {
        'calories': (targetCalories * 0.1).round(),
        'suggestions': [
          'Fruits, vegetables, nuts, or low-fat dairy',
        ],
      },
    };
  }

  Map<String, dynamic> _generateNutrientRecommendations() {
    return {
      'fiber': '25-30g per day',
      'calcium': '1000-1200mg per day',
      'iron': '8-18mg per day (higher for menstruating women)',
      'vitamin_d': '600-800 IU per day',
      'omega_3': 'Include fatty fish 2-3 times per week',
    };
  }

  Map<String, dynamic> _generateHydrationGuide() {
    double waterIntake =
        userProfile.weight * 0.03; // 30ml per kg of body weight
    return {
      'daily_water_intake_liters': waterIntake.toStringAsFixed(1),
      'glasses_of_water': (waterIntake * 1000 / 250).round(),
    };
  }

  List<String> _generateDietaryConsiderations() {
    return [
      'Choose whole, unprocessed foods when possible',
      'Limit added sugars and saturated fats',
      'Include a variety of colorful fruits and vegetables',
      'Opt for lean proteins and plant-based protein sources',
      'Choose whole grains over refined grains',
      'Consider timing of meals around your daily activities',
    ];
  }

  Widget _buildCalorieBreakdown() {
    int bmr = _calculateBMR();
    int tdee = _calculateTDEE(bmr);
    int targetCalories = _calculateTargetCalories(tdee);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Calorie Breakdown',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Basal Metabolic Rate (BMR): $bmr kcal'),
            Text('Total Daily Energy Expenditure (TDEE): $tdee kcal'),
            Text('Daily Calorie Target: $targetCalories kcal'),
            const SizedBox(height: 8),
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Macronutrient Breakdown',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
                'Protein: $proteinGrams g (${(proteinGrams * 4).round()} kcal, 30%)'),
            Text(
                'Carbohydrates: $carbGrams g (${(carbGrams * 4).round()} kcal, 40%)'),
            Text('Fat: $fatGrams g (${(fatGrams * 9).round()} kcal, 30%)'),
            const SizedBox(height: 8),
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Suggested Meal Plan',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Breakfast: ${(targetCalories * 0.25).round()} kcal'),
            const Text('  - Protein-rich option (e.g., eggs, Greek yogurt)'),
            const Text(
                '  - Complex carbohydrates (e.g., oatmeal, whole grain toast)'),
            const Text('  - Healthy fats (e.g., avocado, nuts)'),
            const Text('  - Fruits for vitamins and fiber'),
            const SizedBox(height: 8),
            Text('Lunch: ${(targetCalories * 0.35).round()} kcal'),
            const Text('  - Lean protein (e.g., chicken, fish, tofu)'),
            const Text('  - Complex carbohydrates (e.g., brown rice, quinoa)'),
            const Text('  - Large portion of vegetables'),
            const Text('  - Healthy fats (e.g., olive oil dressing)'),
            const SizedBox(height: 8),
            Text('Dinner: ${(targetCalories * 0.3).round()} kcal'),
            const Text('  - Lean protein'),
            const Text('  - Complex carbohydrates'),
            const Text('  - Large portion of vegetables'),
            const Text('  - Healthy fats'),
            const SizedBox(height: 8),
            Text('Snacks: ${(targetCalories * 0.1).round()} kcal'),
            const Text('  - Fruits, vegetables, nuts, or low-fat dairy'),
            const SizedBox(height: 8),
            const Text(
                'Note: Adjust portion sizes to meet calorie goals. Aim for a variety of foods to ensure a wide range of nutrients.'),
          ],
        ),
      ),
    );
  }

  Widget _buildNutrientRecommendations() {
    return const Card(
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Hydration Guide',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
                'Recommended daily water intake: ${waterIntake.toStringAsFixed(1)} liters'),
            Text(
                'This is approximately ${(waterIntake * 1000 / 250).round()} glasses of water.'),
            const SizedBox(height: 8),
            const Text(
                'Note: Increase intake during hot weather or intense physical activity.'),
          ],
        ),
      ),
    );
  }

  Widget _buildDietaryConsiderations() {
    return const Card(
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
