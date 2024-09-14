import 'package:flutter/material.dart';
import 'dart:math';

import 'package:gymapp/features/workout_plan/data/workout_sample_data.dart';
import 'package:gymapp/features/workout_plan/pages/workout_result.dart';

class LogicPage extends StatelessWidget {
  final int age;
  final double weight;
  final double height;
  final String fitnessLevel;
  final String goal;
  final String gender;
  final double? targetWeight;

  LogicPage({
    required this.age,
    required this.weight,
    required this.height,
    required this.fitnessLevel,
    required this.goal,
    required this.gender,
    this.targetWeight,
  });

  List<DailyWorkout> _getWeeklyWorkoutPlan() {
    List<DailyWorkout> weeklyPlan = [];
    List<String> daysOfWeek = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    Random random = Random();

    // Set target daily calorie burn
    double targetDailyCalorieBurn = 850; // Average of 800-900 range

    // Determine workout days based on fitness level
    int workoutDays = fitnessLevel == 'Beginner'
        ? 4
        : (fitnessLevel == 'Intermediate' ? 5 : 6);

    // Create a balanced workout plan
    List<String> workoutOrder = ['Cardio', 'Full Body', 'HIIT'];

    List<int> workoutIndices = List.generate(7, (index) => index)
      ..shuffle(random);
    workoutIndices = workoutIndices.sublist(0, workoutDays);

    for (int i = 0; i < 7; i++) {
      if (workoutIndices.contains(i)) {
        // Workout day
        String focusArea =
            workoutOrder[workoutIndices.indexOf(i) % workoutOrder.length];
        List<Exercise> baseExercises =
            List.from(sampleExercises[focusArea] ?? []);
        baseExercises.shuffle(random);

        // Start with a warm-up
        List<Exercise> dailyExercises = [
          Exercise(
            name: 'Warm-up',
            instruction: 'Light cardio and dynamic stretching',
            sets: 1,
            reps: 1,
            duration: Duration(minutes: 10),
            caloriesPerMinute: 5,
          )
        ];

        // Add main exercises
        int exerciseCount = 4; // Adjust based on fitness level if needed
        dailyExercises.addAll(baseExercises.take(exerciseCount));

        // Add a cool-down
        dailyExercises.add(Exercise(
          name: 'Cool-down',
          instruction: 'Light cardio and static stretching',
          sets: 1,
          reps: 1,
          duration: Duration(minutes: 10),
          caloriesPerMinute: 3,
        ));

        // Calculate current calorie burn
        double currentCalorieBurn = dailyExercises.fold(
            0.0, (sum, exercise) => sum + exercise.totalCalories);

        // Adjust workout to meet target calorie burn
        if (currentCalorieBurn < targetDailyCalorieBurn) {
          double remainingCalories =
              targetDailyCalorieBurn - currentCalorieBurn;
          Exercise additionalCardio = Exercise(
            name: 'Additional Cardio',
            instruction:
                'Choose any cardio exercise you enjoy (e.g., brisk walking, jogging, cycling)',
            sets: 1,
            reps: 1,
            duration: Duration(
                minutes: (remainingCalories / 8)
                    .round()), // Assuming 8 calories per minute for moderate cardio
            caloriesPerMinute: 8,
          );
          dailyExercises.add(additionalCardio);
        }

        weeklyPlan.add(DailyWorkout(
            day: daysOfWeek[i],
            exercises: dailyExercises,
            focusArea: focusArea));
      } else {
        // Rest day
        weeklyPlan.add(DailyWorkout(
          day: daysOfWeek[i],
          exercises: [
            Exercise(
              name: 'Active Recovery',
              instruction:
                  'Light walk, gentle yoga, or any low-intensity activity you enjoy',
              sets: 1,
              reps: 1,
              duration: Duration(minutes: 45),
              caloriesPerMinute: 4,
            )
          ],
          focusArea: 'Rest',
        ));
      }
    }

    return weeklyPlan;
  }

  @override
  Widget build(BuildContext context) {
    final weeklyWorkout = _getWeeklyWorkoutPlan();
    return ResultPage(
      weeklyWorkout: weeklyWorkout,
      age: age,
      weight: weight,
      height: height,
      fitnessLevel: fitnessLevel,
      goal: goal,
      gender: gender,
      targetWeight: targetWeight,
    );
  }
}
