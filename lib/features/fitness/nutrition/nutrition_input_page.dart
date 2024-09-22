import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymapp/features/fitness/common/user_model.dart';
import 'package:gymapp/features/fitness/workout_plan/pages/workout_input.dart';

class NutritionInputPage extends StatefulWidget {
  final String age;
  final String weight;
  final String height;
  final String fitnessLevel;
  final String goal;
  final String gender;
  final String targetWeight;

  const NutritionInputPage({
    super.key,
    required this.age,
    required this.weight,
    required this.height,
    required this.fitnessLevel,
    required this.goal,
    required this.gender,
    required this.targetWeight,
  });

  @override
  _NutritionInputPageState createState() => _NutritionInputPageState();
}

class _NutritionInputPageState extends State<NutritionInputPage> {
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
    _ageController = TextEditingController(text: widget.age);
    _weightController = TextEditingController(text: widget.weight);
    _heightController = TextEditingController(text: widget.height);
    _targetWeightController = TextEditingController(text: widget.targetWeight);
    _fitnessLevel = widget.fitnessLevel;
    _goal = widget.goal;
    _gender = widget.gender;
  }

  final _primaryColor = const Color.fromARGB(255, 155, 128, 194);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  _primaryColor,
                  const Color.fromARGB(255, 235, 176, 176)
                ],
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
            child: Container(
                color:
                    const Color.fromARGB(255, 251, 251, 251).withOpacity(0.3)),
          ),
          Opacity(
            opacity: 0.2,
            child: Form(
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
                    decoration:
                        const InputDecoration(labelText: 'Fitness Level'),
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
                      decoration: const InputDecoration(
                          labelText: 'Target Weight (kg)'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
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
                ],
              ),
            ),
          ),
          Positioned(
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.teal),
                            padding: const EdgeInsets.all(5.0),
                            height: 100.h,
                            alignment: Alignment.center,
                            width: double.infinity,
                            child: Text(
                              'Your Diet Plan is Generated',
                              style: TextStyle(
                                fontSize: 26.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _generateAndSubmitNutritionPlan(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Next',
                            style: TextStyle(
                              fontSize: 22.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Icon(
                            Icons.arrow_forward,
                            color: Colors.black,
                            size: 30.sp,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _generateAndSubmitNutritionPlan(BuildContext context) async {
    try {
      // Create UserProfile object
      UserProfile userProfile = UserProfile(
        age: int.parse(_ageController.text),
        weight: double.parse(_weightController.text),
        height: double.parse(_heightController.text),
        fitnessLevel: _fitnessLevel,
        goal: _goal,
        gender: _gender,
        targetWeight: _goal == 'Weight Loss'
            ? double.parse(_targetWeightController.text)
            : double.parse(_weightController.text),
      );

      // Generate nutrition plan
      Map<String, dynamic> nutritionPlan = _generateNutritionPlan(userProfile);

      // Upload to Firebase
      bool uploadSuccess = await _uploadToFirebase(userProfile, nutritionPlan);

      if (uploadSuccess) {
        // Navigate to WorkoutInputPage
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WorkoutInputPage(userProfile: userProfile),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Failed to upload data. Please try again.')),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error in _generateAndSubmitNutritionPlan: $e');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  Map<String, dynamic> _generateNutritionPlan(UserProfile userProfile) {
    int bmr = _calculateBMR(userProfile);
    int tdee = _calculateTDEE(bmr, userProfile.fitnessLevel);
    int targetCalories = _calculateTargetCalories(tdee, userProfile.goal);

    return {
      'calorie_breakdown': {
        'bmr': bmr,
        'tdee': tdee,
        'target_calories': targetCalories,
      },
      'macronutrient_breakdown':
          _generateMacronutrientBreakdown(targetCalories),
      'meal_plan': _generateMealPlan(targetCalories),
      'nutrient_recommendations': _generateNutrientRecommendations(),
      'hydration_guide': _generateHydrationGuide(userProfile.weight),
      'dietary_considerations': _generateDietaryConsiderations(),
    };
  }

  Future<bool> _uploadToFirebase(
    UserProfile userProfile,
    Map<String, dynamic> nutritionPlan,
  ) async {
    final user = FirebaseAuth.instance.currentUser;

    try {
      if (user != null) {
        final userId = user.uid;

        final nutritionPlansCollection =
            FirebaseFirestore.instance.collection('nutrition_plans');

        final existingPlan = await nutritionPlansCollection
            .where('user_id', isEqualTo: userId)
            .limit(1)
            .get();

        if (existingPlan.docs.isNotEmpty) {
          await nutritionPlansCollection.doc(existingPlan.docs[0].id).update({
            'user_profile': userProfile.toMap(),
            'nutrition_plan': nutritionPlan,
            'created_at': FieldValue.serverTimestamp(),
          });
        } else {
          await nutritionPlansCollection.add({
            'user_id': userId,
            'user_profile': userProfile.toMap(),
            'nutrition_plan': nutritionPlan,
            'created_at': FieldValue.serverTimestamp(),
          });
        }

        return true;
      } else {
        if (kDebugMode) {
          print('Error: User not authenticated');
        }
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading to Firebase: $e');
      }
      return false;
    }
  }

  int _calculateBMR(UserProfile profile) {
    // Mifflin-St Jeor Equation
    double bmr;
    if (profile.gender == 'Male') {
      bmr = 10 * profile.weight + 6.25 * profile.height - 5 * profile.age + 5;
    } else {
      bmr = 10 * profile.weight + 6.25 * profile.height - 5 * profile.age - 161;
    }
    return bmr.round();
  }

  int _calculateTDEE(int bmr, String fitnessLevel) {
    double activityFactor;
    switch (fitnessLevel) {
      case 'Beginner':
        activityFactor = 1.375;
        break;
      case 'Intermediate':
        activityFactor = 1.55;
        break;
      case 'Advanced':
        activityFactor = 1.725;
        break;
      default:
        activityFactor = 1.375;
    }
    return (bmr * activityFactor).round();
  }

  int _calculateTargetCalories(int tdee, String goal) {
    switch (goal) {
      case 'Weight Loss':
        return (tdee * 0.85).round(); // 15% calorie deficit
      case 'Muscle Gain':
        return (tdee * 1.1).round(); // 10% calorie surplus
      case 'General Fitness':
        return tdee;
      default:
        return tdee;
    }
  }

  Map<String, dynamic> _generateMacronutrientBreakdown(int targetCalories) {
    int proteinGrams = (targetCalories * 0.3 / 4).round();
    int carbGrams = (targetCalories * 0.4 / 4).round();
    int fatGrams = (targetCalories * 0.3 / 9).round();

    return {
      'protein': {
        'grams': proteinGrams,
        'calories': proteinGrams * 4,
        'percentage': 30
      },
      'carbohydrates': {
        'grams': carbGrams,
        'calories': carbGrams * 4,
        'percentage': 40
      },
      'fat': {'grams': fatGrams, 'calories': fatGrams * 9, 'percentage': 30},
    };
  }

  Map<String, dynamic> _generateMealPlan(int targetCalories) {
    return {
      'breakfast': {
        'calories': (targetCalories * 0.25).round(),
        'suggestions': [
          'Protein-rich option (e.g., eggs, Greek yogurt)',
          'Complex carbohydrates (e.g., oatmeal, whole grain toast)',
          'Healthy fats (e.g., avocado, nuts)',
          'Fruits for vitamins and fiber',
        ],
      },
      'lunch': {
        'calories': (targetCalories * 0.35).round(),
        'suggestions': [
          'Lean protein (e.g., chicken, fish, tofu)',
          'Complex carbohydrates (e.g., brown rice, quinoa)',
          'Large portion of vegetables',
          'Healthy fats (e.g., olive oil dressing)',
        ],
      },
      'dinner': {
        'calories': (targetCalories * 0.3).round(),
        'suggestions': [
          'Lean protein',
          'Complex carbohydrates',
          'Large portion of vegetables',
          'Healthy fats',
        ],
      },
      'snacks': {
        'calories': (targetCalories * 0.1).round(),
        'suggestions': [
          'Fruits, vegetables, nuts, or low-fat dairy',
        ],
      },
    };
  }

  Map<String, String> _generateNutrientRecommendations() {
    return {
      'fiber': '25-30g per day',
      'calcium': '1000-1200mg per day',
      'iron': '8-18mg per day (higher for menstruating women)',
      'vitamin_d': '600-800 IU per day',
      'omega_3': 'Include fatty fish 2-3 times per week',
    };
  }

  Map<String, dynamic> _generateHydrationGuide(double weight) {
    double waterIntake = weight * 0.03; // 30ml per kg of body weight
    return {
      'daily_water_intake_liters': waterIntake.toStringAsFixed(1),
      'glasses_of_water': (waterIntake * 1000 / 250).round(),
    };
  }

  List<String> _generateDietaryConsiderations() {
    return [
      'Choose whole, unprocessed foods when possible',
      'Limit added sugars and saturated fats',
      'Include a variety of colorful fruits and vegetables',
      'Opt for lean proteins and plant-based protein sources',
      'Choose whole grains over refined grains',
      'Consider timing of meals around your daily activities',
    ];
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
