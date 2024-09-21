import 'dart:ui'; // Import for the BackdropFilter

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:gymapp/features/fitness/workout_plan/data/workout_repository.dart';
import 'package:gymapp/features/fitness/workout_plan/data/workout_sample_data.dart';
import 'package:gymapp/features/payment/pages/khalti_payment_page.dart';

class ResultPage extends StatelessWidget {
  final List<DailyWorkout> weeklyWorkout;
  final int age;
  final double weight;
  final double height;
  final String fitnessLevel;
  final String goal;
  final String gender;
  final double? targetWeight;

  ResultPage({
    super.key,
    required this.weeklyWorkout,
    required this.age,
    required this.weight,
    required this.height,
    required this.fitnessLevel,
    required this.goal,
    required this.gender,
    this.targetWeight,
  });

  final WorkoutPlanRepository _repository = WorkoutPlanRepository();

  Future<void> _saveWorkoutPlan(BuildContext context) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await _repository.saveWorkoutPlan(
          userId: user.uid,
          weeklyWorkout: weeklyWorkout,
          age: age,
          weight: weight,
          height: height,
          fitnessLevel: fitnessLevel,
          goal: goal,
          gender: gender,
          targetWeight: targetWeight,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Workout plan saved successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Please log in to save your workout plan.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Error saving workout plan. Please try again.')),
      );
    }
  }

  void _navigateToNextPage(BuildContext context) {
    // Implement navigation to the next page
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              const PaymentPage()), // Replace with your target screen
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background content
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  child: Text(
                    'Age: $age, Weight: ${weight}kg, Height: ${height}cm\n'
                    'Fitness Level: $fitnessLevel, Goal: $goal, Gender: $gender',
                    style: Theme.of(context).textTheme.titleSmall,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: weeklyWorkout.length,
                  itemBuilder: (context, dayIndex) {
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: ExpansionTile(
                        title: Text(
                          '${weeklyWorkout[dayIndex].day} - ${weeklyWorkout[dayIndex].focusArea}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'Calories Burned: ${weeklyWorkout[dayIndex].totalCalories.toStringAsFixed(1)} kcal',
                          style: const TextStyle(color: Colors.green),
                        ),
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: weeklyWorkout[dayIndex].exercises.length,
                            itemBuilder: (context, exerciseIndex) {
                              final exercise = weeklyWorkout[dayIndex]
                                  .exercises[exerciseIndex];
                              return Card(
                                margin: const EdgeInsets.all(8.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        exercise.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(exercise.instruction),
                                      const SizedBox(height: 8),
                                      Text('Sets: ${exercise.sets}'),
                                      Text('Reps: ${exercise.reps}'),
                                      Text(
                                          'Duration: ${exercise.duration.inMinutes}m ${exercise.duration.inSeconds % 60}s'),
                                      Text(
                                        'Estimated Calories: ${exercise.totalCalories.toStringAsFixed(1)} kcal',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Total Weekly Calories Burned: ${weeklyWorkout.fold(0.0, (sum, day) => sum + day.totalCalories).toStringAsFixed(1)} kcal',
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),

          Positioned(
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.teal),
                            padding: const EdgeInsets.all(5.0),
                            height: 100.h,
                            alignment: Alignment.center,
                            width: double.infinity,
                            child: Text(
                              'Your Workout Plan is Generated',
                              style: TextStyle(
                                fontSize: 26.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        await _saveWorkoutPlan(context);
                        _navigateToNextPage(context);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Next',
                            style: TextStyle(
                              fontSize: 22.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Icon(
                            Icons.arrow_forward,
                            color: Colors.black,
                            size: 30.sp,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
