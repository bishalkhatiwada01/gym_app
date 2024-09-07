import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResultScreen extends StatelessWidget {
  final double bmi;
  final double height;

  const ResultScreen({super.key, required this.bmi, required this.height});

  // Function to determine BMI classification text
  String getResultText() {
    if (bmi < 18.5) {
      return 'Underweight';
    } else if (bmi < 24.0) {
      return 'Normal';
    } else if (bmi < 28.0) {
      return 'Overweight';
    } else {
      return 'Obese';
    }
  }

  // Function to determine BMI classification color
  Color getResultColor() {
    if (bmi < 18.5) {
      return Colors.blue;
    } else if (bmi < 24.0) {
      return Colors.green;
    } else if (bmi < 28.0) {
      return Colors.yellow;
    } else {
      return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    String resultText = getResultText();
    Color resultColor = getResultColor();
    double heightInMeters = height / 100;
    double minWeight =
        18.5 * (heightInMeters * heightInMeters); // Minimum suggested weight
    double maxWeight =
        24.0 * (heightInMeters * heightInMeters); // Maximum suggested weight

    return Scaffold(
      backgroundColor: Colors.grey[100], // Background color for the screen
      appBar: AppBar(
        title: const Text('Your BMI Result'),
        backgroundColor: Colors.transparent, // App bar color
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Display BMI value

              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text(
                        bmi.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 64.0,
                          fontWeight: FontWeight.bold,
                          color: resultColor,
                        ),
                      ),
                      const Text(
                        'Body Mass Index',
                        style: TextStyle(fontSize: 18.0),
                      ),
                      const SizedBox(height: 20.0),
                      // Display BMI classification
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: resultColor.withOpacity(0.2),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        child: Text(
                          resultText,
                          style: TextStyle(fontSize: 24.0, color: resultColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              const Divider(),
              const SizedBox(height: 10.0),
              const Text(
                'Analysis',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10.0),
              // Display height and suggested weight range
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Height (cm)',
                              style: TextStyle(fontSize: 16.0)),
                          Text(height.toStringAsFixed(1),
                              style: const TextStyle(fontSize: 16.0)),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Suggested weight (kg)',
                              style: TextStyle(fontSize: 16.0)),
                          Text(
                              '${minWeight.toStringAsFixed(1)} ~ ${maxWeight.toStringAsFixed(1)}',
                              style: const TextStyle(fontSize: 16.0)),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 130),
                child: GestureDetector(
                  onTap: () {
                    // Navigator.of(context).push(MaterialPageRoute(
                    //     builder: (context) => WorkoutQuestionsPage()));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: EdgeInsets.all(16.sp),
                    child: Center(
                      child: Text(
                        "Next",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                            color: Colors.white),
                      ),
                    ),
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
