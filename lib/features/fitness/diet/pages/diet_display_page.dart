// ignore_for_file: unnecessary_to_list_in_spreads

import 'package:flutter/material.dart';
import 'package:gymapp/features/fitness/common/user_model.dart';
import 'package:gymapp/features/fitness/diet/diet_recommendation.dart';

class DietRecommendationPage extends StatelessWidget {
  final UserProfile userProfile;

  const DietRecommendationPage({
    super.key,
    required this.userProfile,
  });

  @override
  Widget build(BuildContext context) {
    final dietRecommendation = DietRecommendation(userProfile);
    final weeklyMealPlan = dietRecommendation.generateWeeklyMealPlan();
    final nutritionalTips = dietRecommendation.generateNutritionalTips();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Weekly Diet Plan'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Text(
              'Macronutrient Breakdown:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
                'Protein: ${dietRecommendation.macronutrients['protein']!.round()}g'),
            Text(
                'Carbs: ${dietRecommendation.macronutrients['carbs']!.round()}g'),
            Text(
                'Fats: ${dietRecommendation.macronutrients['fats']!.round()}g'),
            const SizedBox(height: 24),
            Text(
              'Weekly Meal Plan:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            ...weeklyMealPlan
                .map((dayPlan) => _buildDayMealPlan(context, dayPlan))
                .toList(),
            const SizedBox(height: 24),
            Text(
              'Nutritional Tips for Nepali Diet:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            ...nutritionalTips
                .map((tip) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text('• $tip'),
                    ))
                .toList(),
            const SizedBox(height: 24),
            Text(
              'Note: This meal plan is a suggestion based on Nepali market availability. '
              'Please consult with a nutritionist for a personalized diet plan.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayMealPlan(BuildContext context, Map<String, dynamic> dayPlan) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        title:
            Text(dayPlan['day'], style: Theme.of(context).textTheme.titleLarge),
        children: dayPlan['meals']
            .map<Widget>((meal) => _buildMealCard(context, meal))
            .toList(),
      ),
    );
  }

  Widget _buildMealCard(BuildContext context, Map<String, dynamic> meal) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${meal['meal']} (${meal['calories']} kcal)',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              meal['name'],
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            const Text(
              'Ingredients:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ...meal['ingredients']
                .map((ingredient) => Text('• $ingredient'))
                .toList(),
            const SizedBox(height: 8),
            const Text(
              'Instructions:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(meal['instructions']),
          ],
        ),
      ),
    );
  }
}
