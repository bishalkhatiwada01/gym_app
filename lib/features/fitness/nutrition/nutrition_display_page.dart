import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymapp/common/widgets/common_app_bar.dart';

import 'package:gymapp/features/fitness/nutrition/data/nutrition_provider.dart';

class NutritionPlanDisplayPage extends ConsumerWidget {
  const NutritionPlanDisplayPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nutritionPlanAsync = ref.watch(nutritionProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CenteredAppBarWithBackButton(
        title: 'Your Nutrition Plan',
        onBackPressed: () => Navigator.pop(context),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.green[300]!,
              Colors.teal[300]!,
            ],
          ),
        ),
        child: nutritionPlanAsync.when(
          loading: () => const Center(
              child: CircularProgressIndicator(color: Colors.white)),
          error: (error, stackTrace) => Center(
            child: Text(
              'Error: $error',
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          data: (nutritionPlan) {
            if (nutritionPlan == null) {
              return const Center(
                child: Text(
                  'No nutrition plan available.',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              );
            }

            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    _buildCard(
                      'Calorie Breakdown',
                      Icons.local_fire_department,
                      Colors.orange[400]!,
                      [
                        'BMR: ${nutritionPlan.calorieBreakdown['bmr']} calories',
                        'TDEE: ${nutritionPlan.calorieBreakdown['tdee']} calories',
                        'Target Calories: ${nutritionPlan.calorieBreakdown['target_calories']} calories',
                      ],
                    ),
                    _buildCard(
                      'Macronutrient Breakdown',
                      Icons.pie_chart,
                      Colors.purple[300]!,
                      [
                        'Protein: ${nutritionPlan.macronutrientBreakdown['protein']['grams']}g (${nutritionPlan.macronutrientBreakdown['protein']['percentage']}%)',
                        'Carbohydrates: ${nutritionPlan.macronutrientBreakdown['carbohydrates']['grams']}g (${nutritionPlan.macronutrientBreakdown['carbohydrates']['percentage']}%)',
                        'Fat: ${nutritionPlan.macronutrientBreakdown['fat']['grams']}g (${nutritionPlan.macronutrientBreakdown['fat']['percentage']}%)',
                      ],
                    ),
                    _buildCard(
                      'Meal Plan',
                      Icons.restaurant_menu,
                      Colors.red[300]!,
                      nutritionPlan.mealPlan.entries.map((entry) {
                        return '${entry.key.capitalize()}: ${entry.value['calories']} calories\n'
                            '  ${entry.value['suggestions'].join('\n  ')}';
                      }).toList(),
                    ),
                    _buildCard(
                      'Nutrient Recommendation',
                      Icons.eco,
                      Colors.green[400]!,
                      nutritionPlan.nutrientRecommendations.entries
                          .map((entry) =>
                              '${entry.key.capitalize()}: ${entry.value}')
                          .toList(),
                    ),
                    _buildCard(
                      'Hydration Guide',
                      Icons.water_drop,
                      Colors.blue[300]!,
                      [
                        'Daily water intake: ${nutritionPlan.hydrationGuide['daily_water_intake_liters']} liters',
                        'Glasses of water: ${nutritionPlan.hydrationGuide['glasses_of_water']}',
                      ],
                    ),
                    _buildCard(
                      'Dietary Considerations',
                      Icons.list_alt,
                      Colors.amber[300]!,
                      nutritionPlan.dietaryConsiderations,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCard(
      String title, IconData icon, Color color, List<String> items) {
    return Card(
      elevation: 8,
      margin: const EdgeInsets.symmetric(vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color.withOpacity(0.1), color.withOpacity(0.3)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: color, size: 28),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: color.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
              const Divider(height: 24, thickness: 1, color: Colors.black12),
              ...items.map((item) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.arrow_right, color: color, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            item,
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey[800]),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
