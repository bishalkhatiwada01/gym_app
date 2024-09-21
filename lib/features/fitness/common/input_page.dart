import 'package:flutter/material.dart';
import 'package:gymapp/features/fitness/workout_plan/data/workout_recommendation.dart';

class InputPage extends StatefulWidget {
  const InputPage({super.key});

  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  final _formKey = GlobalKey<FormState>();
  String _age = '';
  String _weight = '';
  String _height = '';
  String _fitnessLevel = 'Beginner';
  String _goal = 'Weight Loss';
  String _gender = 'Male';
  String _targetWeight = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Input Physical Status'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your age';
                }
                return null;
              },
              onSaved: (value) => _age = value!,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Weight (kg)'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your weight';
                }
                return null;
              },
              onSaved: (value) => _weight = value!,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Height (cm)'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your height';
                }
                return null;
              },
              onSaved: (value) => _height = value!,
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
                decoration:
                    const InputDecoration(labelText: 'Target Weight (kg)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your target weight';
                  }
                  return null;
                },
                onSaved: (value) => _targetWeight = value!,
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
              child: const Text('Get Workout Plan'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LogicPage(
                        age: int.parse(_age),
                        weight: double.parse(_weight),
                        height: double.parse(_height),
                        fitnessLevel: _fitnessLevel,
                        goal: _goal,
                        gender: _gender,
                        targetWeight: _goal == 'Weight Loss'
                            ? double.parse(_targetWeight)
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
}
