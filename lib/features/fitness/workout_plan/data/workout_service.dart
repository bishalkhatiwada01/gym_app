// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/foundation.dart';
// import 'package:gymapp/features/fitness/workout_plan/data/workout_model.dart';
// import 'package:gymapp/features/fitness/workout_plan/data/workout_sample_data.dart';

// class WorkoutPlanService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<WorkoutPlan?> getWorkoutPlan(String userId) async {
//     try {
//       // Query to get the workout plan for the user
//       final querySnapshot = await _firestore
//           .collection('workout_plans')
//           .where('userId', isEqualTo: userId)
//           .get();

//       if (querySnapshot.docs.isNotEmpty) {
//         // If the workout plan exists, parse and return it
//         final doc = querySnapshot.docs.first;
//         final data = doc.data();

//         return WorkoutPlan(
//           userId: data['userId'],
//           createdAt: (data['createdAt'] as Timestamp).toDate(),
//           age: data['age'],
//           weight: data['weight'],
//           height: data['height'],
//           fitnessLevel: data['fitnessLevel'],
//           goal: data['goal'],
//           gender: data['gender'],
//           targetWeight: data['targetWeight'],
//           weeklyWorkout: (data['weeklyWorkout'] as List)
//               .map((dailyWorkout) => DailyWorkout(
//                     day: dailyWorkout['day'],
//                     focusArea: dailyWorkout['focusArea'],
//                     totalCalories: dailyWorkout['totalCalories'],
//                     exercises: (dailyWorkout['exercises'] as List)
//                         .map((exercise) => Exercise(
//                               name: exercise['name'],
//                               instruction: exercise['instruction'],
//                               sets: exercise['sets'],
//                               reps: exercise['reps'],
//                               duration: Duration(seconds: exercise['duration']),
//                               caloriesPerMinute: exercise['caloriesPerMinute'],
//                             ))
//                         .toList(),
//                   ))
//               .toList(),
//         );
//       } else {
//         // If no workout plan exists, return null
//         return null;
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         print('Error fetching workout plan: $e');
//       }
//       rethrow;
//     }
//   }
// }
