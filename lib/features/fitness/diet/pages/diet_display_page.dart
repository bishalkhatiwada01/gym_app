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
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF6DD5FA),
              Color(0xFFFF758C),
            ],
          ),
        ),
        child: dietPlanAsyncValue.when(
          data: (dietPlan) {
            if (dietPlan == null) {
              return Center(
                child: Text(
                  'No diet plan found.',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold),
                ),
              );
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
                  _buildHeader('Nutrition Tips'),
                  SizedBox(height: 16.h),
                  _buildNutritionTips(context, nutritionTips),
                ],
              ),
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          error: (error, stack) => Center(
            child: Text(
              'Error: $error',
              style: TextStyle(color: Colors.white, fontSize: 18.sp),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 24.sp,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [
            Shadow(
                offset: const Offset(1, 1),
                blurRadius: 3,
                color: Colors.black.withOpacity(0.3))
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyMealPlan(
      BuildContext context, List<Map<String, dynamic>> weeklyMealPlan) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: weeklyMealPlan.length,
      itemBuilder: (context, index) {
        final dayPlan = weeklyMealPlan[index];
        return Card(
          margin: EdgeInsets.only(bottom: 16.h),
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          color: Colors.white.withOpacity(0.9),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              title: Text(
                dayPlan['day'],
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF333333),
                ),
              ),
              children: dayPlan['meals']
                  .map<Widget>((meal) => ListTile(
                        title: Text(
                          meal['meal'],
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF444444),
                              fontSize: 18.sp),
                        ),
                        subtitle: Text(
                          meal['name'],
                          style: TextStyle(
                              color: const Color(0xFF666666), fontSize: 16.sp),
                        ),
                        leading: Container(
                          padding: EdgeInsets.all(8.r),
                          decoration: BoxDecoration(
                            color: _getMealColor(meal['meal']),
                            borderRadius: BorderRadius.circular(12.r),
                            boxShadow: [
                              BoxShadow(
                                color: _getMealColor(meal['meal'])
                                    .withOpacity(0.5),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Icon(
                            _getMealIcon(meal['meal']),
                            color: Colors.white,
                            size: 24.r,
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNutritionTips(BuildContext context, List<String> nutritionTips) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white.withOpacity(0.9),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...nutritionTips.map(
              (tip) => Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.r),
                      decoration: BoxDecoration(
                        color: _getRandomColor(),
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(Icons.lightbulb,
                          color: Colors.white, size: 24.r),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Text(
                        tip,
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: const Color(0xFF333333),
                        ),
                      ),
                    ),
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

  Color _getMealColor(String meal) {
    switch (meal.toLowerCase()) {
      case 'breakfast':
        return const Color(0xFF3498DB);
      case 'lunch':
        return const Color(0xFF2ECC71);
      case 'dinner':
        return const Color(0xFFE74C3C);
      case 'snack':
        return const Color(0xFFF39C12);
      default:
        return const Color(0xFF9B59B6);
    }
  }

  Color _getRandomColor() {
    final colors = [
      const Color(0xFFFF6B6B),
      const Color(0xFF4ECDC4),
      const Color(0xFFFFD93D),
      const Color(0xFF6A0572),
      const Color(0xFF4CB8C4),
    ];
    return colors[DateTime.now().microsecond % colors.length];
  }
}
