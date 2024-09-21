import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymapp/features/payment/model/user_model.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentPage extends ConsumerStatefulWidget {
  const PaymentPage({Key? key}) : super(key: key);

  @override
  ConsumerState<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends ConsumerState<PaymentPage> {
  final currentUser = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    final userDataAsyncValue = ref.watch(userProvider);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue[300]!,
              Colors.purple[300]!,
            ],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.transparent,
                expandedHeight: 80.0,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text('Premium Plans',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            blurRadius: 10.0,
                            color: Colors.black.withOpacity(0.3),
                            offset: const Offset(2.0, 2.0),
                          ),
                        ],
                      )),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  _buildBanner('Diet Plan', 'assets/diet.jpg', Colors.green),
                  _buildBanner(
                      'Nutrition Guide', 'assets/nutrition.jpg', Colors.orange),
                  _buildBanner(
                      'Workout Routine', 'assets/workout.jpg', Colors.red),
                  _buildSubscriptionCard(userDataAsyncValue),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBanner(String title, String imagePath, Color color) {
    return Container(
      height: 180,
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, color.withOpacity(0.8)],
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    blurRadius: 5.0,
                    color: Colors.black.withOpacity(0.5),
                    offset: const Offset(2.0, 2.0),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionCard(AsyncValue<UserModel?> userDataAsyncValue) {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Access All Plans',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.purple[700],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Get full access to diet, nutrition, and workout plans for just \$19.99/month',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 20),
            userDataAsyncValue.when(
              data: (userData) {
                if (userData != null) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Username: ${userData.username}',
                          style:
                              TextStyle(fontSize: 16, color: Colors.grey[800])),
                      const SizedBox(height: 5),
                      Text('Email: ${userData.email}',
                          style:
                              TextStyle(fontSize: 16, color: Colors.grey[800])),
                      if (userData.name != null) ...[
                        const SizedBox(height: 5),
                        Text('Name: ${userData.name}',
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey[800])),
                      ],
                      const SizedBox(height: 15),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple[700],
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Subscribe Now',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () => _initiatePayment(userData.username),
                      ),
                    ],
                  );
                } else {
                  return const Text('User data not available',
                      style: TextStyle(fontSize: 16, color: Colors.red));
                }
              },
              error: (error, _) => Text('Error: ${error.toString()}',
                  style: const TextStyle(fontSize: 16, color: Colors.red)),
              loading: () => const CircularProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }

  void _initiatePayment(String username) {
    const amount = 1999; // in Paisa
    KhaltiScope.of(context).pay(
      config: PaymentConfig(
        amount: amount,
        productIdentity: "User ID $currentUser",
        productName: "Premium Plans Subscription",
      ),
      preferences: [PaymentPreference.khalti],
      onSuccess: onSuccess,
      onFailure: onFailure,
      onCancel: onCancel,
    );
  }

  void onSuccess(PaymentSuccessModel success) {
    FirebaseFirestore.instance.collection('subscriptions').add({
      'userId': currentUser,
      'amount': success.amount / 100, // converted to Rs
      'transactionId': success.idx,
      'subscriptionDate': DateTime.now(),
      'paymentType': 'Khalti',
    }).then((_) {
      _showSuccessDialog();
    }).catchError((error) {
      print("Failed to add subscription: $error");
    });
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text("Subscription Successful",
            style: TextStyle(color: Colors.purple[700])),
        content: const Text("You now have access to all premium plans!"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text("OK", style: TextStyle(color: Colors.purple[700])),
          ),
        ],
      ),
    );
  }

  void onFailure(PaymentFailureModel failure) {
    if (kDebugMode) {
      print("Payment Failure: ${failure.message}");
    }
    // Show error message to user
  }

  void onCancel() {
    if (kDebugMode) {
      print("Payment Cancelled");
    }
    // Show cancellation message to user
  }
}
