import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:gymapp/features/fitness/workout_plan/data/workout_sample_data.dart';

class WorkoutPlanRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveWorkoutPlan({
    required String userId,
    required List<DailyWorkout> weeklyWorkout,
    required int age,
    required double weight,
    required double height,
    required String fitnessLevel,
    required String goal,
    required String gender,
    double? targetWeight,
  }) async {
    try {
      await _firestore.collection('workout_plans').add({
        'userId': userId,
        'createdAt': FieldValue.serverTimestamp(),
        'age': age,
        'weight': weight,
        'height': height,
        'fitnessLevel': fitnessLevel,
        'goal': goal,
        'gender': gender,
        'targetWeight': targetWeight,
        'weeklyWorkout': weeklyWorkout
            .map((dailyWorkout) => {
                  'day': dailyWorkout.day,
                  'focusArea': dailyWorkout.focusArea,
                  'totalCalories': dailyWorkout.totalCalories,
                  'exercises': dailyWorkout.exercises
                      .map((exercise) => {
                            'name': exercise.name,
                            'instruction': exercise.instruction,
                            'sets': exercise.sets,
                            'reps': exercise.reps,
                            'duration': exercise.duration.inSeconds,
                            'caloriesPerMinute': exercise.caloriesPerMinute,
                          })
                      .toList(),
                })
            .toList(),
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error saving workout plan: $e');
      }
      throw e;
    }
  }
}
