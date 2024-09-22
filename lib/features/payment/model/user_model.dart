import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String email;
  final String? name;
  final String? profileImageUrl;
  final String token;
  final String username;

  UserModel({
    required this.email,
    this.name,
    this.profileImageUrl,
    required this.token,
    required this.username,
  });

  factory UserModel.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return UserModel(
      email: data['email'] ?? '',
      name: data['name'],
      profileImageUrl: data['profileImageUrl'],
      token: data['token'] ?? '',
      username: data['username'] ?? '',
    );
  }
}

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserModel?> getUserData() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final docSnapshot =
            await _firestore.collection('users').doc(user.uid).get();
        if (docSnapshot.exists) {
          return UserModel.fromDocument(docSnapshot);
        }
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching user data: $e');
      }
      return null;
    }
  }
}

final userServiceProvider = Provider<UserService>((ref) => UserService());

final userProvider = FutureProvider<UserModel?>((ref) async {
  final userService = ref.read(userServiceProvider);
  return await userService.getUserData();
});
