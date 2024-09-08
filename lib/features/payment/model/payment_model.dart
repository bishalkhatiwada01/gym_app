import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentModel {
  final String id;
  final String userId;
  final double amount;
  final String transactionId;
  final String paymentDate;
  final String paymentType;

  PaymentModel({
    required this.id,
    required this.userId,
    required this.amount,
    required this.transactionId,
    required this.paymentDate,
    required this.paymentType,
  });

  factory PaymentModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return PaymentModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      amount: (data['amount'] as num).toDouble(),
      transactionId: data['transactionId'] ?? '',
      paymentDate: data['paymentDate'] ?? '',
      paymentType: data['paymentType'] ?? '',
    );
  }
}
