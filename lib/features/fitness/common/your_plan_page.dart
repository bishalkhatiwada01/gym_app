import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gymapp/features/fitness/diet/pages/diet_display_page.dart';
import 'package:gymapp/features/fitness/nutrition/nutrition_display_page.dart';
import 'package:gymapp/features/fitness/workout_plan/pages/workout_display_page.dart';

// Main widget to handle navigation
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

// Workout Plan Page
class WorkoutPlanPage extends StatelessWidget {
  const WorkoutPlanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Your Workout Plan',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.orange[300]!,
              Colors.red[300]!,
            ],
          ),
        ),
        child: Center(
          child: Text(
            'Workout Plan Content\nComing Soon!',
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
