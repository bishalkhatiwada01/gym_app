import 'package:flutter/material.dart';

class PaymentButton extends StatelessWidget {
  final VoidCallback onPaymentPressed;

  const PaymentButton({
    required this.onPaymentPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPaymentPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Theme.of(context).colorScheme.onError,
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      child: Text(
        'Payment',
        style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
      ),
    );
  }
}
