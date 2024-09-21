import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const BottomNavBar(
      {super.key, required this.selectedIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      elevation: 0,
      backgroundColor: const Color.fromARGB(255, 230, 240, 255),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color.fromARGB(255, 81, 140, 153),
      unselectedItemColor: Theme.of(context).colorScheme.inversePrimary,
      currentIndex: selectedIndex,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: 'Home'),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.post_add_outlined,
          ),
          label: 'Post',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.person_2_outlined,
          ),
          label: 'Profile',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.fitness_center_outlined,
          ),
          label: 'Workout',
        ),
      ],
    );
  }
}
