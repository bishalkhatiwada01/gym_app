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
      // Query to check if the workout plan for the user already exists
      final querySnapshot = await _firestore
          .collection('workout_plans')
          .where('userId', isEqualTo: userId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // If the workout plan exists, update it
        final docId = querySnapshot.docs.first.id;
        await _firestore.collection('workout_plans').doc(docId).update({
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
      } else {
        // If no workout plan exists, create a new one
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
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error saving workout plan: $e');
      }
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getWorkoutPlan(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection('workout_plans')
          .where('userId', isEqualTo: userId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Return the first workout plan found
        return querySnapshot.docs.first.data();
      }
    } catch (e) {
      print('Error getting workout plan: $e');
    }
    return null;
  }
}
