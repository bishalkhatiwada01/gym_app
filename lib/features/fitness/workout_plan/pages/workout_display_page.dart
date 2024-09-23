import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gymapp/common/widgets/common_app_bar.dart';
import 'package:gymapp/features/fitness/workout_plan/data/workout_repository.dart';

class WorkoutPlanScreen extends StatelessWidget {
  WorkoutPlanScreen({super.key});

  final currentUser = FirebaseAuth.instance.currentUser;
  final WorkoutPlanRepository _repository = WorkoutPlanRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CenteredAppBarWithBackButton(
        title: 'Your Workout Plan',
        onBackPressed: () => Navigator.pop(context),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.orange[300]!,
              Colors.red[300]!,
            ],
          ),
        ),
        child: SafeArea(
          child: FutureBuilder<Map<String, dynamic>?>(
            future: _repository.getWorkoutPlan(currentUser!.uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(color: Colors.white));
              } else if (snapshot.hasError) {
                return const Center(
                    child: Text('Error fetching workout plan.',
                        style: TextStyle(color: Colors.white)));
              } else if (!snapshot.hasData || snapshot.data == null) {
                return const Center(
                    child: Text('No workout plan found.',
                        style: TextStyle(color: Colors.white)));
              } else {
                final workoutPlan = snapshot.data!;
                return CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionTitle(context, 'User Details'),
                            _buildUserDetailsCard(context, workoutPlan),
                            SizedBox(height: 20),
                            _buildSectionTitle(context, 'Weekly Workout Plan'),
                          ],
                        ),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final dailyWorkout =
                              workoutPlan['weeklyWorkout'][index];
                          return _buildWorkoutCard(context, dailyWorkout);
                        },
                        childCount: workoutPlan['weeklyWorkout'].length,
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .headlineSmall
            ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildUserDetailsCard(
      BuildContext context, Map<String, dynamic> workoutPlan) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildDetailRow('Age', '${workoutPlan['age']} years'),
            _buildDetailRow('Weight', '${workoutPlan['weight']} kg'),
            _buildDetailRow('Height', '${workoutPlan['height']} cm'),
            _buildDetailRow('Fitness Level', workoutPlan['fitnessLevel']),
            _buildDetailRow('Goal', workoutPlan['goal']),
            _buildDetailRow('Gender', workoutPlan['gender']),
            _buildDetailRow(
                'Target Weight', '${workoutPlan['targetWeight']} kg'),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildWorkoutCard(
      BuildContext context, Map<String, dynamic> dailyWorkout) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          collapsedIconColor: Colors.orange,
          title: Text('${dailyWorkout['day']}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          subtitle: Text('Focus Area: ${dailyWorkout['focusArea']}',
              style: TextStyle(color: Colors.grey[600])),
          leading: Icon(Icons.fitness_center, color: Colors.orange),
          children: [
            Container(
              padding: EdgeInsets.all(16),
              color: Colors.grey[100],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Exercises',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  SizedBox(height: 8),
                  ...(dailyWorkout['exercises'] as List)
                      .map((exercise) => Card(
                            margin: EdgeInsets.symmetric(vertical: 8),
                            child: Padding(
                              padding: EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(exercise['name'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16)),
                                  SizedBox(height: 4),
                                  Text(exercise['instruction'],
                                      style:
                                          TextStyle(color: Colors.grey[600])),
                                  SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      _buildExerciseDetail(Icons.repeat,
                                          '${exercise['sets']} sets'),
                                      _buildExerciseDetail(Icons.fitness_center,
                                          '${exercise['reps']} reps'),
                                      _buildExerciseDetail(Icons.timer,
                                          '${exercise['duration'] ?? 'N/A'}'),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ))
                      .toList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseDetail(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        SizedBox(width: 4),
        Text(text, style: TextStyle(color: Colors.grey[600])),
      ],
    );
  }
}
