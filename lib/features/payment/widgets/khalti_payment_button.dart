import 'package:flutter/material.dart';
import 'package:khalti_flutter/khalti_flutter.dart';

class KhaltiPaymentButton extends StatelessWidget {
  final PaymentConfig config;
  final List<PaymentPreference> preferences;
  final ValueChanged<PaymentSuccessModel> onSuccess;
  final ValueChanged<PaymentFailureModel> onFailure;
  final VoidCallback onCancel;

  const KhaltiPaymentButton({
    Key? key,
    required this.config,
    required this.preferences,
    required this.onSuccess,
    required this.onFailure,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Full width button
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: () {
          KhaltiScope.of(context).pay(
            config: config,
            preferences: preferences,
            onSuccess: (success) {
              onSuccess(success);
            },
            onFailure: (failure) {
              onFailure(failure);
            },
            onCancel: () {
              onCancel();
            },
          );
        },
        child: const Text(
          'Pay with Khalti',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
