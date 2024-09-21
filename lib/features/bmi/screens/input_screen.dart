import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import 'result_screen.dart';
import '../widgets/gender_selector.dart'; // Import the GenderSelector widget

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
  String gender = 'Male'; // Default gender

  void _calculateBMI(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      final weight = double.parse(weightController.text);
      final height = double.parse(heightController.text);
      final heightInMeters = height / 100; // Convert cm to meters
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
      backgroundColor: Colors.grey[200], // Background color for the screen
      appBar: AppBar(
        title: const Text('BMI Calculator'),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 20.0),
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: weightController,
                        label: 'Enter your weight (kg)',
                        keyboardType: TextInputType.number,

                        icon: Icons.fitness_center,
                        // No validator here
                      ),
                      const SizedBox(height: 20.0),
                      CustomTextField(
                        controller: heightController,
                        label: 'Enter your height (cm)',
                        keyboardType: TextInputType.number,
                        icon: Icons.height,
                        // No validator here
                      ),
                      const SizedBox(height: 20.0),
                      CustomTextField(
                        controller: ageController,
                        label: 'Enter your age',
                        keyboardType: TextInputType.number,
                        icon: Icons.cake,
                        // No validator here
                      ),
                      const SizedBox(height: 20.0),
                      GenderSelector(
                        selectedGender: gender,
                        onChanged: (value) {
                          setState(() {
                            gender = value;
                          });
                        },
                      ),
                      const SizedBox(height: 30.0),
                      CustomButton(
                        text: 'Calculate BMI',
                        onPressed: () => _calculateBMI(context),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
