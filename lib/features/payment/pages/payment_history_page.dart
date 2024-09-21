import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymapp/common/functions/date.dart'; // For date formatting
import 'package:gymapp/features/payment/pages/payment_detail_page.dart';
import 'package:gymapp/features/payment/service/payment_service.dart';

class PaymentHistoryPage extends ConsumerWidget {
  const PaymentHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paymentsAsyncValue = ref.watch(paymentsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment History'),
      ),
      body: paymentsAsyncValue.when(
        data: (payments) {
          if (payments.isEmpty) {
            return const Center(child: Text('No payments found'));
          }
          return ListView.builder(
            itemCount: payments.length,
            itemBuilder: (context, index) {
              final payment = payments[index];

              return ListTile(
                title:
                    Text('Payment of Rs. ${payment.amount.toStringAsFixed(2)}'),
                subtitle: Text(
                  "Posted ${timeAgo(DateTime.parse(payment.paymentDate))}",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentDetailPage(payment: payment),
                    ),
                  );
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text("error: $error")),
      ),
    );
  }
}
