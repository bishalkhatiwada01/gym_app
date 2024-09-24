import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymapp/common/widgets/my_drawer.dart';
import 'package:gymapp/features/fitness/common/fitness_page.dart';
import 'package:gymapp/features/fitness/diet/pages/diet_input_page.dart';

class CombinedPage extends ConsumerStatefulWidget {
  const CombinedPage({super.key});

  @override
  ConsumerState<CombinedPage> createState() => _CombinedPageState();
}

class _CombinedPageState extends ConsumerState<CombinedPage> {
  // Fetch the current user from FirebaseAuth
  User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  // Check if the payment exists for the current user
  Future<bool> _checkPaymentStatus() async {
    final user = getCurrentUser();
    if (user != null) {
      final paymentSnapshot = await FirebaseFirestore.instance
          .collection('payments')
          .where('userId', isEqualTo: user.uid)
          .get();

      return paymentSnapshot.docs.isNotEmpty;
    }
    return false;
  }

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
          child: GestureDetector(
            child: CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate([
                    _buildBanner(
                        context, 'Diet Plan', 'assets/diet.jpg', Colors.green),
                    _buildBanner(context, 'Nutrition Guide',
                        'assets/nutrition.jpg', Colors.orange),
                    _buildBanner(context, 'Workout Routine',
                        'assets/workout.jpg', Colors.red),
                  ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBanner(
      BuildContext context, String title, String imagePath, Color color) {
    return GestureDetector(
      onTap: () async {
        bool hasPaid = await _checkPaymentStatus();

        if (hasPaid) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FitnessPage()),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DietInputPage()),
          );
        }
      },
      child: Container(
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
      ),
    );
  }
}
