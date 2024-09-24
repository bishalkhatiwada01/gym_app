import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

  final _primaryColor = const Color.fromARGB(255, 155, 128, 194);
  final _accentColor = const Color.fromARGB(255, 72, 141, 231);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_primaryColor, const Color.fromARGB(255, 235, 176, 176)],
          ),
        ),
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(15.0),
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        size: 30,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    const Spacer(),
                  ],
                ),
                const Text(
                  'Create Your Personalized Plan!',
                  style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 14),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color.fromARGB(255, 166, 145, 196),
                          Color.fromARGB(255, 222, 177, 177)
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          _buildInputField(
                              'Age', _age, (value) => _age = value),
                          _buildInputField('Weight (kg)', _weight,
                              (value) => _weight = value),
                          _buildInputField('Height (cm)', _height,
                              (value) => _height = value),
                          _buildDropdown(
                              'Fitness Level',
                              _fitnessLevel,
                              ['Beginner', 'Intermediate', 'Advanced'],
                              (value) =>
                                  setState(() => _fitnessLevel = value!)),
                          _buildDropdown(
                              'Your Goal',
                              _goal,
                              ['Weight Loss', 'Muscle Gain', 'General Fitness'],
                              (value) => setState(() => _goal = value!)),
                          if (_goal == 'Weight Loss')
                            _buildInputField(
                                'Target Weight (kg)',
                                _targetWeight,
                                (value) => _targetWeight = value),
                          _buildDropdown('Gender', _gender, ['Male', 'Female'],
                              (value) => setState(() => _gender = value!)),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 14.h),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: _accentColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _submitForm,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Text('Generate Diet Plan',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final userProfile = UserProfile(
        age: int.parse(_age),
        weight: double.parse(_weight),
        height: double.parse(_height),
        fitnessLevel: _fitnessLevel,
        goal: _goal,
        gender: _gender,
        targetWeight:
            _goal == 'Weight Loss' ? double.parse(_targetWeight) : null,
      );

      final dietRecommendation = DietRecommendation(userProfile);
      final weeklyMealPlan = dietRecommendation.generateWeeklyMealPlan();
      final generalRecommendations =
          dietRecommendation.generateNutritionalTips();

      try {
        await _uploadToFirebase(
            userProfile, weeklyMealPlan, generalRecommendations);
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
          SnackBar(
              content: Text('Error: ${e.toString()}'),
              backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _uploadToFirebase(
    UserProfile userProfile,
    List<Map<String, dynamic>> weeklyMealPlan,
    List<String> generalRecommendations,
  ) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userId = user.uid;
      final dietPlansCollection =
          FirebaseFirestore.instance.collection('diet_plans');
      final existingPlan = await dietPlansCollection
          .where('user_id', isEqualTo: userId)
          .limit(1)
          .get();

      if (existingPlan.docs.isNotEmpty) {
        await dietPlansCollection.doc(existingPlan.docs[0].id).update({
          'user_profile': userProfile.toMap(),
          'weekly_meal_plan': weeklyMealPlan,
          'nutrition_tips': generalRecommendations,
          'created_at': FieldValue.serverTimestamp(),
        });
      } else {
        await dietPlansCollection.add({
          'user_id': userId,
          'user_profile': userProfile.toMap(),
          'weekly_meal_plan': weeklyMealPlan,
          'nutrition_tips': generalRecommendations,
          'created_at': FieldValue.serverTimestamp(),
        });
      }
    } else {
      throw Exception('User not authenticated');
    }
  }

  Widget _buildInputField(
      String label, String? value, Function(String) onSaved) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: _primaryColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: _accentColor, width: 2),
          ),
        ),
        initialValue: value,
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
        onSaved: (value) => onSaved(value!),
      ),
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items,
      Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: _primaryColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: _accentColor, width: 2),
          ),
        ),
        items: items
            .map((item) => DropdownMenuItem(value: item, child: Text(item)))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}
