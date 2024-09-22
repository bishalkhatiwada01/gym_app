import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import 'result_screen.dart';
import '../widgets/gender_selector.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  String gender = 'Male';

  void _calculateBMI(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      final weight = double.parse(weightController.text);
      final height = double.parse(heightController.text);
      final heightInMeters = height / 100;
      final bmi = weight / (heightInMeters * heightInMeters);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            bmi: bmi,
            height: height,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue[300]!,
              Colors.purple[300]!,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 30),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 20),
                    const Text(
                      'BMI Calculator',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'Enter your details below',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 40.sp),
                    Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.blue[100]!,
                              Colors.purple[100]!,
                            ],
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.blue[100]!,
                                  Colors.purple[100]!,
                                ],
                              ),
                            ),
                            child: Column(
                              children: [
                                CustomTextField(
                                  controller: weightController,
                                  label: 'Weight (kg)',
                                  keyboardType: TextInputType.number,
                                  icon: Icons.fitness_center,
                                ),
                                const SizedBox(height: 20),
                                CustomTextField(
                                  controller: heightController,
                                  label: 'Height (cm)',
                                  keyboardType: TextInputType.number,
                                  icon: Icons.height,
                                ),
                                const SizedBox(height: 20),
                                CustomTextField(
                                  controller: ageController,
                                  label: 'Age',
                                  keyboardType: TextInputType.number,
                                  icon: Icons.cake,
                                ),
                                const SizedBox(height: 20),
                                GenderSelector(
                                  selectedGender: gender,
                                  onChanged: (value) {
                                    setState(() {
                                      gender = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomButton(
                          text: 'Calculate BMI',
                          onPressed: () => _calculateBMI(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 258),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
