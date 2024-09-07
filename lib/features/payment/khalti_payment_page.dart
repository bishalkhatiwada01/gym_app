import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymapp/features/payment/payment_button.dart';
import 'package:gymapp/features/profile/data/user_service.dart';
import 'package:khalti_flutter/khalti_flutter.dart';

class PaymentPage extends ConsumerStatefulWidget {
  const PaymentPage({super.key});

  @override
  ConsumerState<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends ConsumerState<PaymentPage> {
  @override
  Widget build(BuildContext context) {
    final userDataAsyncValue = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      body: Column(
        children: [
          PaymentButton(
            onPaymentPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  final TextEditingController amountController =
                      TextEditingController();
                  return AlertDialog(
                    title: Text(
                      'Enter amount to pay',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                    content: TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                        ),
                        labelText: 'Enter amount',
                        labelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      userDataAsyncValue.when(
                        data: (userData) {
                          final username = userData.username ?? 'Unknown User';
                          return TextButton(
                            child: Text(
                              'Pay',
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                              ),
                            ),
                            onPressed: () {
                              final amountString = amountController.text;
                              if (amountString.isNotEmpty) {
                                final amount = int.parse(amountString);
                                payWithKhaltiInApp(amount, username);
                              } else {
                                // Handle empty amount
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Please enter an amount.'),
                                  ),
                                );
                              }
                            },
                          );
                        },
                        error: (error, stackTrace) {
                          return Text('Error: ${error.toString()}');
                        },
                        loading: () => const CircularProgressIndicator(),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  final currentUser = FirebaseAuth.instance.currentUser!.uid;

  void payWithKhaltiInApp(int amount, String username) {
    KhaltiScope.of(context).pay(
      config: PaymentConfig(
        amount: amount * 100, // Khalti expects amount in paisa
        productIdentity: "User ID $currentUser",
        productName: "User Name $username",
      ),
      preferences: [
        PaymentPreference.khalti,
      ],
      onSuccess: onSuccess,
      onFailure: onFailure,
      onCancel: onCancel,
    );
  }

  void onSuccess(PaymentSuccessModel success) {
    final firestoreInstance = FirebaseFirestore.instance;

    firestoreInstance.collection('payments').add({
      'userId': currentUser,
      'amount': success.amount / 100, // Convert back to proper currency unit
      'transactionId': success.idx,
      'paymentDate': DateTime.now(),
      'paymentType': 'Khalti',
    }).then((value) {
      if (kDebugMode) {
        print("Payment Added");
      }
    }).catchError((error) {
      if (kDebugMode) {
        print("Failed to add payment: $error");
      }
    });

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Success"),
          content: const Text("Payment successful"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                Navigator.pop(context); // Close the payment page
              },
              child: const Text("OK"),
            )
          ],
        );
      },
    );
  }

  void onFailure(PaymentFailureModel failure) {
    debugPrint("Failure: ${failure.message}");
  }

  void onCancel() {
    debugPrint("Cancelled");
  }
}
