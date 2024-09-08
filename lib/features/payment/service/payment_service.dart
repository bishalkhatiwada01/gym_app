import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gymapp/features/payment/model/payment_model.dart';

// Provider to fetch payments for the current user
final paymentsProvider = StreamProvider.autoDispose<List<PaymentModel>>((ref) {
  final userId = FirebaseAuth.instance.currentUser?.uid;
  if (userId == null) {
    return Stream.value([]);
  } else {
    return FirebaseFirestore.instance
        .collection('payments')
        .where('userId', isEqualTo: userId)
        .orderBy('paymentDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => PaymentModel.fromDocument(doc))
            .toList());
  }
});

class PaymentDataSource {
  final paymentDb = FirebaseFirestore.instance.collection('payments');

  Future<String> createPayment({
    required String userId,
    required double amount,
    required String paymentType,
    required String transactionId,
    String? paymentImageUrl,
  }) async {
    try {
      final paymentId = paymentDb.doc().id;

      await paymentDb.doc(paymentId).set({
        'paymentId': paymentId,
        'userId': userId,
        'amount': amount,
        'paymentType': paymentType,
        'transactionId': transactionId,
        'paymentDate': DateTime.now().toIso8601String(),
      });

      return 'Payment Created';
    } on FirebaseException catch (err) {
      return '${err.message}';
    }
  }
}
