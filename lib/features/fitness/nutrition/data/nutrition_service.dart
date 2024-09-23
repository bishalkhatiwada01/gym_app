import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gymapp/features/fitness/nutrition/data/nutrition_model.dart';

class NutritionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> saveNutritionPlan(NutritionPlan nutritionPlan) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('User not authenticated');

    final nutritionPlansCollection = _firestore.collection('nutrition_plans');

    final existingPlan = await nutritionPlansCollection
        .where('user_id', isEqualTo: userId)
        .limit(1)
        .get();

    if (existingPlan.docs.isNotEmpty) {
      await nutritionPlansCollection.doc(existingPlan.docs[0].id).update({
        'user_id': userId,
        ...nutritionPlan.toMap(),
        'updated_at': FieldValue.serverTimestamp(),
      });
    } else {
      await nutritionPlansCollection.add({
        'user_id': userId,
        ...nutritionPlan.toMap(),
        'created_at': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<NutritionPlan?> getNutritionPlan() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('User not authenticated');

    final nutritionPlansCollection = _firestore.collection('nutrition_plans');

    final querySnapshot = await nutritionPlansCollection
        .where('user_id', isEqualTo: userId)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return NutritionPlan.fromMap(querySnapshot.docs[0].data());
    }

    return null;
  }
}
