import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymapp/features/dashboard/physical_condition_page.dart';

class WorkoutQuestionsPage extends StatefulWidget {
  const WorkoutQuestionsPage({super.key});

  @override
  State<WorkoutQuestionsPage> createState() => _WorkoutQuestionsPageState();
}

class _WorkoutQuestionsPageState extends State<WorkoutQuestionsPage> {
  // Create controllers for each option
  final TextEditingController _loseWeightController = TextEditingController();
  final TextEditingController _buildMuscleController = TextEditingController();
  final TextEditingController _keepFitController = TextEditingController();

  // Variable to track the selected goal
  String _selectedGoal = '';

  // Function to update the selected goal
  void _selectGoal(String goal, TextEditingController controller) {
    setState(() {
      _selectedGoal = goal;
      controller.text = goal;
      // You can also save the selected goal to a database or use it in your app logic
      print('Selected goal: ${controller.text}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Column(
            children: [
              Stack(
                children: [
                  Image.asset(
                    "assets/ques_back.jpg",
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 85, left: 20),
                        child: GestureDetector(
                          onTap: () {
                            _selectGoal("Lose Weight", _loseWeightController);
                          },
                          child: Container(
                            height: 150, // Adjust height as needed
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: _selectedGoal == "Lose Weight"
                                    ? Colors.black26
                                    : Colors
                                        .transparent, // Show border if selected
                                width: 2, // Border width
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: GestureDetector(
                          onTap: () {
                            _selectGoal("Build Muscle", _buildMuscleController);
                          },
                          child: Container(
                            height: 150, // Adjust height as needed
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: _selectedGoal == "Build Muscle"
                                    ? Colors.black26
                                    : Colors
                                        .transparent, // Show border if selected
                                width: 2, // Border width
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: GestureDetector(
                          onTap: () {
                            _selectGoal("Keep Fit", _keepFitController);
                          },
                          child: Container(
                            height: 140, // Adjust height as needed
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: _selectedGoal == "Keep Fit"
                                    ? Colors.black26
                                    : Colors
                                        .transparent, // Show border if selected
                                width: 2, // Border width
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 130),
                        child: GestureDetector(
                          onTap: () {
                            // Navigator.of(context).push(MaterialPageRoute(
                            //     builder: (context) => PhysicalConditionPage()));
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
