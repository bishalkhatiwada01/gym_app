import 'package:flutter/material.dart';
import 'package:gymapp/features/fitness/workout_plan/data/workout_recommendation.dart';
import 'package:gymapp/features/fitness/common/user_model.dart';

class WorkoutInputPage extends StatefulWidget {
  final UserProfile userProfile;

  const WorkoutInputPage({super.key, required this.userProfile});

  @override
  _WorkoutInputPageState createState() => _WorkoutInputPageState();
}

class _WorkoutInputPageState extends State<WorkoutInputPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _ageController;
  late TextEditingController _weightController;
  late TextEditingController _heightController;
  late TextEditingController _targetWeightController;
  late String _fitnessLevel;
  late String _goal;
  late String _gender;

  @override
  void initState() {
    super.initState();
    _ageController =
        TextEditingController(text: widget.userProfile.age.toString());
    _weightController =
        TextEditingController(text: widget.userProfile.weight.toString());
    _heightController =
        TextEditingController(text: widget.userProfile.height.toString());
    _targetWeightController = TextEditingController(
        text: widget.userProfile.targetWeight?.toString() ?? '');
    _fitnessLevel = widget.userProfile.fitnessLevel;
    _goal = widget.userProfile.goal;
    _gender = widget.userProfile.gender;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm Workout Details'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            TextFormField(
              controller: _ageController,
              decoration: const InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your age';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _weightController,
              decoration: const InputDecoration(labelText: 'Weight (kg)'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your weight';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _heightController,
              decoration: const InputDecoration(labelText: 'Height (cm)'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your height';
                }
                return null;
              },
            ),
            DropdownButtonFormField<String>(
              value: _fitnessLevel,
              decoration: const InputDecoration(labelText: 'Fitness Level'),
              items: ['Beginner', 'Intermediate', 'Advanced']
                  .map((label) => DropdownMenuItem(
                        value: label,
                        child: Text(label),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _fitnessLevel = value!;
                });
              },
            ),
            DropdownButtonFormField<String>(
              value: _goal,
              decoration: const InputDecoration(labelText: 'Your Goal'),
              items: ['Weight Loss', 'Muscle Gain', 'General Fitness']
                  .map((label) => DropdownMenuItem(
                        value: label,
                        child: Text(label),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _goal = value!;
                });
              },
            ),
            if (_goal == 'Weight Loss')
              TextFormField(
                controller: _targetWeightController,
                decoration:
                    const InputDecoration(labelText: 'Target Weight (kg)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (_goal == 'Weight Loss' &&
                      (value == null || value.isEmpty)) {
                    return 'Please enter your target weight';
                  }
                  return null;
                },
              ),
            DropdownButtonFormField<String>(
              value: _gender,
              decoration: const InputDecoration(labelText: 'Gender'),
              items: ['Male', 'Female']
                  .map((label) => DropdownMenuItem(
                        value: label,
                        child: Text(label),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _gender = value!;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Generate Workout Plan'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LogicPage(
                        age: int.parse(_ageController.text),
                        weight: double.parse(_weightController.text),
                        height: double.parse(_heightController.text),
                        fitnessLevel: _fitnessLevel,
                        goal: _goal,
                        gender: _gender,
                        targetWeight: _goal == 'Weight Loss'
                            ? double.parse(_targetWeightController.text)
                            : null,
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _targetWeightController.dispose();
    super.dispose();
  }
}
