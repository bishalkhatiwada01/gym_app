import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResultScreen extends StatelessWidget {
  final double bmi;
  final double height;

  const ResultScreen({super.key, required this.bmi, required this.height});

  String getResultText() {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 24.0) return 'Normal';
    if (bmi < 28.0) return 'Overweight';
    return 'Obese';
  }

  Color getResultColor() {
    if (bmi < 18.5) return Colors.blue;
    if (bmi < 24.0) return Colors.green;
    if (bmi < 28.0) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    String resultText = getResultText();
    Color resultColor = getResultColor();
    double heightInMeters = height / 100;
    double minWeight = 18.5 * (heightInMeters * heightInMeters);
    double maxWeight = 24.0 * (heightInMeters * heightInMeters);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('BMI Result',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 20.h),
                _buildBMICard(resultColor, resultText),
                SizedBox(height: 20.h),
                _buildAnalysisCard(heightInMeters, minWeight, maxWeight),
                SizedBox(height: 20.h),
              ]
                  .animate(interval: 100.ms)
                  .fadeIn(duration: 500.ms)
                  .slideY(begin: 0.2, end: 0),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBMICard(Color resultColor, String resultText) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      child: Padding(
        padding: EdgeInsets.all(20.sp),
        child: Column(
          children: [
            Text(
              bmi.toStringAsFixed(1),
              style: TextStyle(
                fontSize: 72.sp,
                fontWeight: FontWeight.bold,
                color: resultColor,
              ),
            ),
            Text(
              'Body Mass Index',
              style: TextStyle(fontSize: 18.sp, color: Colors.grey[600]),
            ),
            SizedBox(height: 20.h),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                color: resultColor.withOpacity(0.2),
              ),
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
              child: Text(
                resultText,
                style: TextStyle(
                    fontSize: 24.sp,
                    color: resultColor,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalysisCard(
      double heightInMeters, double minWeight, double maxWeight) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      child: Padding(
        padding: EdgeInsets.all(20.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Analysis',
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15.h),
            _buildAnalysisRow('Height', '${height.toStringAsFixed(1)} cm'),
            SizedBox(height: 10.h),
            _buildAnalysisRow('Suggested weight',
                '${minWeight.toStringAsFixed(1)} - ${maxWeight.toStringAsFixed(1)} kg'),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalysisRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 16.sp, color: Colors.grey[600])),
        Text(value,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
