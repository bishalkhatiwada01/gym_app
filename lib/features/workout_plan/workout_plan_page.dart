import 'package:flutter/material.dart';
import 'package:gymapp/features/workout_plan/fitness_form.dart';
import 'package:gymapp/features/workout_plan/workout_plan.dart';

class InputWorkoutPlan extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Enter Information'),
        ),
        body: FitnessInputForm(
          onSubmit: (formData) {
            WorkoutPlan selectedPlan = selectWorkoutPlan(formData);
            // Navigate to a new screen to display the workout plan
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WorkoutPlanScreen(plan: selectedPlan),
              ),
            );
          },
        ),
      ),
    );
  }
}

class WorkoutPlanScreen extends StatelessWidget {
  final WorkoutPlan plan;

  WorkoutPlanScreen({required this.plan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Workout Plan'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                plan.name,
              ),
              SizedBox(height: 8),
              Text('Target: ${plan.target}'),
              Text('Goal: ${plan.goal}'),
              SizedBox(height: 16),
              Text(
                'Schedule:',
              ),
              ...plan.schedule
                  .map((day) => Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text('• $day'),
                      ))
                  .toList(),
            ],
          ),
        ),
      ),
    );
  }
}
