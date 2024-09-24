import 'package:flutter/material.dart';
import 'package:gymapp/features/fitness/diet/pages/diet_display_page.dart';
import 'package:gymapp/features/fitness/nutrition/nutrition_display_page.dart';
import 'package:gymapp/features/fitness/workout_plan/pages/workout_display_page.dart';

class FitnessPage extends StatefulWidget {
  const FitnessPage({super.key});

  @override
  State<FitnessPage> createState() => _FitnessPageState();
}

class _FitnessPageState extends State<FitnessPage> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    const DietDisplayPage(),
    WorkoutPlanScreen(),
    const NutritionPlanDisplayPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'Diet Plan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Workout',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.apple),
            label: 'Nutrition',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.purple[300],
        onTap: _onItemTapped,
      ),
    );
  }
}
