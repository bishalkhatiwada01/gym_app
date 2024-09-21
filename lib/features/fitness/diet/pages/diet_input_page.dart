import 'package:flutter/material.dart';
import 'package:gymapp/features/fitness/common/user_model.dart';
import 'package:gymapp/features/fitness/diet/diet_recommendation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gymapp/features/fitness/nutrition/nutrition_input_page.dart';

class DietInputPage extends StatefulWidget {
  const DietInputPage({super.key});

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
        title: const Text('INPUT PHYSICAL STATUS'),
        centerTitle: true,
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
              child: const Text(
                'Generate Diet Plan and Continue',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () async {
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

                  // Generate diet recommendation
                  final dietRecommendation = DietRecommendation(userProfile);
                  final weeklyMealPlan =
                      dietRecommendation.generateWeeklyMealPlan();

                  final generalRecommendations =
                      dietRecommendation.generateNutritionalTips();

                  // Upload to Firebase
                  try {
                    await _uploadToFirebase(
                        userProfile, weeklyMealPlan, generalRecommendations);

                    // Navigate to NutritionInputPage
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NutritionInputPage(
                          age: _age,
                          weight: _weight,
                          height: _height,
                          fitnessLevel: _fitnessLevel,
                          goal: _goal,
                          gender: _gender,
                          targetWeight: _targetWeight,
                        ),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: ${e.toString()}')),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _uploadToFirebase(
    UserProfile userProfile,
    List<Map<String, dynamic>> weeklyMealPlan,
    List<String> generalRecommendations,
  ) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Get the current user's UID
      final userId = user.uid;

      // Reference to the diet_plans collection
      final dietPlansCollection =
          FirebaseFirestore.instance.collection('diet_plans');

      // Query to check if a diet plan already exists for the user
      final existingPlan = await dietPlansCollection
          .where('user_id', isEqualTo: userId)
          .limit(1)
          .get();

      if (existingPlan.docs.isNotEmpty) {
        // If a diet plan already exists, update the document with the new data
        await dietPlansCollection.doc(existingPlan.docs[0].id).update({
          'user_profile': userProfile.toMap(),
          'weekly_meal_plan': weeklyMealPlan,
          'nutrition_tips': generalRecommendations,
          'created_at': FieldValue.serverTimestamp(),
          // Update timestamp to reflect modification
        });
      } else {
        // If no plan exists, create a new document
        await dietPlansCollection.add({
          'user_id': userId,
          'user_profile': userProfile.toMap(),
          'weekly_meal_plan': weeklyMealPlan,
          'nutrition_tips': generalRecommendations,
          'created_at': FieldValue.serverTimestamp(),
        });
      }
    } else {
      // Handle case when user is not authenticated
      throw Exception('User not authenticated');
    }
  }
}
