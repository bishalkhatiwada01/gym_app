import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gymapp/features/fitness/diet/data/diet_model.dart';

final dietPlanProvider = FutureProvider<DietPlan?>((ref) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final userId = user.uid;
    final dietPlansCollection =
        FirebaseFirestore.instance.collection('diet_plans');
    final existingPlan = await dietPlansCollection
        .where('user_id', isEqualTo: userId)
        .limit(1)
        .get();

    if (existingPlan.docs.isNotEmpty) {
      return DietPlan.fromMap(existingPlan.docs[0].data());
    } else {
      return null;
    }
  } else {
    throw Exception('User not authenticated');
  }
});
