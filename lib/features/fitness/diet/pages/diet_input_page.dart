import 'package:flutter/material.dart';
import 'package:gymapp/features/fitness/nutrition/nutrition_display_page.dart';

class DietInputPage extends StatefulWidget {
  @override
  _DietInputPageState createState() => _DietInputPageState();
}

class _DietInputPageState extends State<DietInputPage> {
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
        title: Text('Input Physical Status'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: 'Age'),
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
              decoration: InputDecoration(labelText: 'Weight (kg)'),
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
              decoration: InputDecoration(labelText: 'Height (cm)'),
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
              decoration: InputDecoration(labelText: 'Fitness Level'),
              items: ['Beginner', 'Intermediate', 'Advanced']
                  .map((label) => DropdownMenuItem(
                        child: Text(label),
                        value: label,
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
              decoration: InputDecoration(labelText: 'Your Goal'),
              items: ['Weight Loss', 'Muscle Gain', 'General Fitness']
                  .map((label) => DropdownMenuItem(
                        child: Text(label),
                        value: label,
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
                decoration: InputDecoration(labelText: 'Target Weight (kg)'),
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
              decoration: InputDecoration(labelText: 'Gender'),
              items: ['Male', 'Female']
                  .map((label) => DropdownMenuItem(
                        child: Text(label),
                        value: label,
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _gender = value!;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Get Nutrition Plan'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  final userProfile = UserProfile(
                    age: int.parse(_age),
                    weight: double.parse(_weight),
                    height: double.parse(_height),
                    fitnessLevel: _fitnessLevel,
                    goal: _goal,
                    gender: _gender,
                    targetWeight: _goal == 'Weight Loss'
                        ? double.parse(_targetWeight)
                        : null,
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DetailedNutritionPage(userProfile: userProfile),
                    ),
                  );
                }
              },
            ),
            //
            // ElevatedButton(
            //   child: Text('Get Diet Plan'),
            //   onPressed: () {
            //     if (_formKey.currentState!.validate()) {
            //       _formKey.currentState!.save();
            //       final userProfile = UserProfile(
            //         age: int.parse(_age),
            //         weight: double.parse(_weight),
            //         height: double.parse(_height),
            //         fitnessLevel: _fitnessLevel,
            //         goal: _goal,
            //         gender: _gender,
            //         targetWeight: _goal == 'Weight Loss'
            //             ? double.parse(_targetWeight)
            //             : null,
            //       );
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //           builder: (context) =>
            //               DietRecommendationPage(userProfile: userProfile),
            //         ),
            //       );
            //     }
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
