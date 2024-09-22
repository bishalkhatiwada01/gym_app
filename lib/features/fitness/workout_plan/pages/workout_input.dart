import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
            opacity: 0,
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
                              'Your Nutrition Plan is Generated',
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

  @override
  void dispose() {
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _targetWeightController.dispose();
    super.dispose();
  }
}
