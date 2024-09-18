import 'package:flutter/material.dart';
import 'package:gymapp/features/fitness/workout_plan/data/workout_sample_data.dart';

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
    required this.weeklyWorkout,
    required this.age,
    required this.weight,
    required this.height,
    required this.fitnessLevel,
    required this.goal,
    required this.gender,
    this.targetWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Weekly Workout Plan'),
      ),
      body: Column(
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
                  margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: ExpansionTile(
                    title: Text(
                      '${weeklyWorkout[dayIndex].day} - ${weeklyWorkout[dayIndex].focusArea}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Calories Burned: ${weeklyWorkout[dayIndex].totalCalories.toStringAsFixed(1)} kcal',
                      style: TextStyle(color: Colors.green),
                    ),
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: weeklyWorkout[dayIndex].exercises.length,
                        itemBuilder: (context, exerciseIndex) {
                          final exercise =
                              weeklyWorkout[dayIndex].exercises[exerciseIndex];
                          return Card(
                            margin: EdgeInsets.all(8.0),
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    exercise.name,
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                  SizedBox(height: 8),
                                  Text(exercise.instruction),
                                  SizedBox(height: 8),
                                  Text('Sets: ${exercise.sets}'),
                                  Text('Reps: ${exercise.reps}'),
                                  Text(
                                      'Duration: ${exercise.duration.inMinutes}m ${exercise.duration.inSeconds % 60}s'),
                                  Text(
                                    'Estimated Calories: ${exercise.totalCalories.toStringAsFixed(1)} kcal',
                                    style: TextStyle(
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
    );
  }
}
