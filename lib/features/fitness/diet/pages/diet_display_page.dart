import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymapp/common/widgets/common_app_bar.dart';
import 'package:gymapp/features/fitness/diet/data/get_diet_service.dart';

class DietDisplayPage extends ConsumerWidget {
  const DietDisplayPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dietPlanAsyncValue = ref.watch(dietPlanProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CenteredAppBarWithBackButton(
        title: 'Your Diet Plan',
        onBackPressed: () => Navigator.pop(context),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue[300]!,
              Colors.purple[300]!,
            ],
          ),
        ),
        child: dietPlanAsyncValue.when(
          data: (dietPlan) {
            if (dietPlan == null) {
              return const Center(
                  child: Text('No diet plan found.',
                      style: TextStyle(color: Colors.white)));
            }
            final weeklyMealPlan = dietPlan.weeklyMealPlan;
            final nutritionTips = dietPlan.nutritionTips;

            return SingleChildScrollView(
              padding:
                  EdgeInsets.fromLTRB(16.w, kToolbarHeight + 16.h, 16.w, 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildWeeklyMealPlan(context, weeklyMealPlan),
                  SizedBox(height: 24.h),
                  _buildNutritionTips(context, nutritionTips),
                ],
              ),
            );
          },
          loading: () => const Center(
              child: CircularProgressIndicator(color: Colors.white)),
          error: (error, stack) => Center(
              child: Text('Error: $error',
                  style: const TextStyle(color: Colors.white))),
        ),
      ),
    );
  }

  Widget _buildWeeklyMealPlan(
      BuildContext context, List<Map<String, dynamic>> weeklyMealPlan) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: weeklyMealPlan.map<Widget>((dayPlan) {
        return Card(
          margin: EdgeInsets.only(bottom: 16.h),
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              title: Text(
                dayPlan['day'],
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              children: dayPlan['meals']
                  .map<Widget>((meal) => ListTile(
                        title: Text(
                          meal['meal'],
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(meal['name']),
                        leading: CircleAvatar(
                          backgroundColor:
                              Theme.of(context).primaryColor.withOpacity(0.1),
                          child: Icon(
                            _getMealIcon(meal['meal']),
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildNutritionTips(BuildContext context, List<String> nutritionTips) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Diet Tips',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(height: 16.h),
            ...nutritionTips.map(
              (tip) => Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 12.r,
                      backgroundColor: Colors.amber,
                      child: Icon(Icons.lightbulb,
                          color: Colors.white, size: 16.r),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(child: Text(tip)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getMealIcon(String meal) {
    switch (meal.toLowerCase()) {
      case 'breakfast':
        return Icons.breakfast_dining;
      case 'lunch':
        return Icons.lunch_dining;
      case 'dinner':
        return Icons.dinner_dining;
      case 'snack':
        return Icons.apple;
      default:
        return Icons.restaurant;
    }
  }
}
