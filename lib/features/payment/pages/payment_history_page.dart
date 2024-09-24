// payment_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymapp/common/widgets/common_app_bar.dart';
import 'package:intl/intl.dart';

class Payment {
  final String id;
  final String userId;
  final double amount;
  final String transactionId;
  final DateTime paymentDate;

  Payment({
    required this.id,
    required this.userId,
    required this.amount,
    required this.transactionId,
    required this.paymentDate,
  });

  factory Payment.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Payment(
      id: doc.id,
      userId: data['userId'] ?? '',
      amount: (data['amount'] ?? 0.0).toDouble(),
      transactionId: data['transactionId'] ?? '',
      paymentDate: (data['paymentDate'] as Timestamp).toDate(),
    );
  }
}

class PaymentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<Payment>> getPaymentHistory() async {
    final currentUser = _auth.currentUser?.uid;
    if (currentUser == null) {
      throw Exception('User not authenticated');
    }

    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('payments')
          .where('userId', isEqualTo: currentUser)
          .orderBy('paymentDate', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => Payment.fromFirestore(doc))
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching payment history: $e');
      }
      rethrow;
    }
  }
}

final paymentServiceProvider =
    Provider<PaymentService>((ref) => PaymentService());

final paymentHistoryProvider = FutureProvider<List<Payment>>((ref) async {
  final paymentService = ref.read(paymentServiceProvider);
  return paymentService.getPaymentHistory();
});

class PaymentHistoryPage extends ConsumerWidget {
  const PaymentHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paymentHistoryAsyncValue = ref.watch(paymentHistoryProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CenteredAppBarWithBackButton(
        title: 'Your Diet Plan',
        onBackPressed: () => Navigator.pop(context),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 117, 175, 197),
              Color.fromARGB(255, 179, 111, 122),
            ],
          ),
        ),
        child: paymentHistoryAsyncValue.when(
          data: (payments) => _buildPaymentList(payments, context),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
        ),
      ),
    );
  }

  Widget _buildPaymentList(List<Payment> payments, BuildContext context) {
    return payments.isEmpty
        ? const Center(child: Text('No payment history available.'))
        : ListView.builder(
            itemCount: payments.length,
            itemBuilder: (context, index) {
              final payment = payments[index];
              return _buildPaymentCard(payment, context);
            },
          );
  }

  Widget _buildPaymentCard(Payment payment, BuildContext context) {
    return Column(
      children: [
        Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.indigo.shade400, Colors.indigo.shade700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${payment.amount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Paid',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Date: ${DateFormat('MMM d, yyyy').format(payment.paymentDate)}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Time: ${DateFormat('h:mm a').format(payment.paymentDate)}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Transaction ID: ${payment.transactionId}',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
