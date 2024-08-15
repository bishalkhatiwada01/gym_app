// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:gymapp/features/dashboard/home_page.dart';

// class PhysicalConditionPage extends StatefulWidget {
//   const PhysicalConditionPage({super.key});

//   @override
//   State<PhysicalConditionPage> createState() => _PhysicalConditionPageState();
// }

// class _PhysicalConditionPageState extends State<PhysicalConditionPage> {
//   // Controllers for each question
//   final TextEditingController _weightController = TextEditingController();
//   final TextEditingController _heightController = TextEditingController();
//   final TextEditingController _dietRestrictionsController =
//       TextEditingController();

//   // Dropdown values
//   String? _selectedExerciseDays;
//   String? _selectedExerciseType;
//   String? _selectedDiet;
//   String? _selectedSleepHours;
//   String? _selectedStressLevel;
//   String? _selectedSittingHours;
//   String? _selectedPhysicalActivity;
//   bool _hasInjuries = false;
//   bool _hasMedicalConditions = false;

//   final List<String> _exerciseDaysOptions = ['1-2', '3-4', '5-6', '7'];
//   final List<String> _exerciseTypesOptions = [
//     'Cardio',
//     'Strength',
//     'Flexibility',
//     'Balance'
//   ];
//   final List<String> _dietOptions = ['Veg', 'Non-Veg', 'Vegan'];
//   final List<String> _sleepHoursOptions = [
//     '< 6 hours',
//     '6-7 hours',
//     '7-8 hours',
//     '> 8 hours'
//   ];
//   final List<String> _stressLevelsOptions = ['Low', 'Moderate', 'High'];
//   final List<String> _sittingHoursOptions = [
//     '< 4 hours',
//     '4-6 hours',
//     '6-8 hours',
//     '> 8 hours'
//   ];
//   final List<String> _physicalActivitiesOptions = [
//     'Walking',
//     'Biking',
//     'Swimming',
//     'None'
//   ];

//   // Function to store responses and navigate to the next page
//   void _submitResponses() {
//     // Store or process the data here
//     print("Exercise Days: $_selectedExerciseDays");
//     print("Exercise Type: $_selectedExerciseType");
//     print("Injuries: $_hasInjuries");
//     print("Medical Conditions: $_hasMedicalConditions");
//     print("Weight: ${_weightController.text}");
//     print("Height: ${_heightController.text}");
//     print("Diet: $_selectedDiet");
//     print("Diet Restrictions: ${_dietRestrictionsController.text}");
//     print("Sleep Hours: $_selectedSleepHours");
//     print("Stress Level: $_selectedStressLevel");
//     print("Sitting Hours: $_selectedSittingHours");
//     print("Physical Activity: $_selectedPhysicalActivity");

//     // Navigate to the next page or perform other actions
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Physical Condition")),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: ListView(
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text("How many days per week do you currently exercise?"),
//                 SizedBox(height: 10),
//                 DropdownButtonFormField<String>(
//                   value: _selectedExerciseDays,
//                   hint: Text("Select days"),
//                   items: _exerciseDaysOptions.map((option) {
//                     return DropdownMenuItem<String>(
//                       value: option,
//                       child: Text(option),
//                     );
//                   }).toList(),
//                   onChanged: (value) {
//                     setState(() {
//                       _selectedExerciseDays = value;
//                     });
//                   },
//                 ),
//               ],
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 130),
//               child: GestureDetector(
//                 onTap: () {
//                   Navigator.of(context).push(
//                       MaterialPageRoute(builder: (context) => HomePage()));
//                 },
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: Colors.black,
//                     borderRadius: BorderRadius.circular(25),
//                   ),
//                   padding: EdgeInsets.all(16.sp),
//                   child: Center(
//                     child: Text(
//                       "Next",
//                       style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16.sp,
//                           color: Colors.white),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
