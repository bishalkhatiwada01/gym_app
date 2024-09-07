import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymapp/features/profile/model/user_model.dart';

final userProvider = FutureProvider.autoDispose<UserModel>((ref) async {
  final userService = UserService();
  return userService.getUserDetails();
});

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel> getUserDetails() async {
    final user = _auth.currentUser;
    if (user != null) {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      return UserModel.fromDocument(doc);
    } else {
      throw Exception('No current user');
    }
  }
}
