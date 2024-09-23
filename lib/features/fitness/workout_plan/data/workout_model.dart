// lib/features/fitness/workout_plan/models/workout_plan_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class WorkoutPlan {
  final String userId;
  final DateTime createdAt;
  final int age;
  final double weight;
  final double height;
  final String fitnessLevel;
  final String goal;
  final String gender;
  final double? targetWeight;
  final List<DailyWorkout> weeklyWorkout;

  WorkoutPlan({
    required this.userId,
    required this.createdAt,
    required this.age,
    required this.weight,
    required this.height,
    required this.fitnessLevel,
    required this.goal,
    required this.gender,
    this.targetWeight,
    required this.weeklyWorkout,
  });

  factory WorkoutPlan.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return WorkoutPlan(
      userId: data['userId'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      age: data['age'],
      weight: data['weight'].toDouble(),
      height: data['height'].toDouble(),
      fitnessLevel: data['fitnessLevel'],
      goal: data['goal'],
      gender: data['gender'],
      targetWeight: data['targetWeight']?.toDouble(),
      weeklyWorkout: (data['weeklyWorkout'] as List)
          .map((day) => DailyWorkout.fromMap(day))
          .toList(),
    );
  }
}

class DailyWorkout {
  final String day;
  final String focusArea;
  final int totalCalories;
  final List<Exercise> exercises;

  DailyWorkout({
    required this.day,
    required this.focusArea,
    required this.totalCalories,
    required this.exercises,
  });

  factory DailyWorkout.fromMap(Map<String, dynamic> map) {
    return DailyWorkout(
      day: map['day'],
      focusArea: map['focusArea'],
      totalCalories: map['totalCalories'],
      exercises: (map['exercises'] as List)
          .map((exercise) => Exercise.fromMap(exercise))
          .toList(),
    );
  }
}

class Exercise {
  final String name;
  final String instruction;
  final int sets;
  final int reps;
  final Duration duration;
  final double caloriesPerMinute;

  Exercise({
    required this.name,
    required this.instruction,
    required this.sets,
    required this.reps,
    required this.duration,
    required this.caloriesPerMinute,
  });

  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      name: map['name'],
      instruction: map['instruction'],
      sets: map['sets'],
      reps: map['reps'],
      duration: Duration(seconds: map['duration']),
      caloriesPerMinute: map['caloriesPerMinute'].toDouble(),
    );
  }
}
