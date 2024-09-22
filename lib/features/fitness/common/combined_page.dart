import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymapp/common/widgets/my_drawer.dart';
import 'package:gymapp/features/fitness/diet/pages/diet_input_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CombinedPage extends ConsumerStatefulWidget {
  const CombinedPage({super.key});

  @override
  ConsumerState<CombinedPage> createState() => _CombinedPageState();
}

class _CombinedPageState extends ConsumerState<CombinedPage> {
  final currentUser = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[300]!,
        title: Text(
          "YOUR PLAN",
          style: TextStyle(
            letterSpacing: 2,
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 26.sp,
            shadows: [
              Shadow(
                blurRadius: 10.0,
                color: Colors.black.withOpacity(0.1),
                offset: const Offset(2.0, 2.0),
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      drawer: const MyDrawer(),
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
          child: InkWell(
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const DietInputPage())),
            child: CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate([
                    _buildBanner('Diet Plan', 'assets/diet.jpg', Colors.green),
                    _buildBanner('Nutrition Guide', 'assets/nutrition.jpg',
                        Colors.orange),
                    _buildBanner(
                        'Workout Routine', 'assets/workout.jpg', Colors.red)
                  ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBanner(String title, String imagePath, Color color) {
    return Container(
      height: 208,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, color.withOpacity(0.8)],
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 26.sp,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    blurRadius: 5.0,
                    color: Colors.black.withOpacity(0.5),
                    offset: const Offset(2.0, 2.0),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
