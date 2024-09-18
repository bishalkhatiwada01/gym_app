import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymapp/features/bmi/screens/input_screen.dart';
import 'package:gymapp/features/auth/pages/login_page.dart';
import 'package:gymapp/features/fitness/common/input_page.dart';
import 'package:gymapp/features/payment/pages/khalti_payment_page.dart';
import 'package:gymapp/features/payment/pages/payment_history_page.dart';
import 'package:gymapp/features/profile/pages/profile_page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    super.key,
  });

  Future<bool> checkPaymentStatus() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final querySnapshot = await FirebaseFirestore.instance
            .collection('payments')
            .where('userId', isEqualTo: user.uid)
            .limit(1)
            .get();
        return querySnapshot.docs.isNotEmpty;
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print('Error checking payment status: $e');
      }
      return false;
    }
  }

  void showPaymentCompletedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Payment Already Completed'),
          content: const Text('You have already made a payment.'),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Future<String> userSignout() async {
      try {
        await FirebaseAuth.instance.signOut();
        return "Success";
      } on FirebaseAuthException catch (e) {
        return "${e.message}";
      }
    }

    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          // drawer header
          DrawerHeader(
            child: Icon(
              Icons.favorite,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),

          SizedBox(
            height: 15.h,
          ),

          // home tile
          Padding(
            padding: EdgeInsets.only(left: 20.w),
            child: ListTile(
              leading: const Icon(Icons.home),
              title: const Text(
                'HOME',
                style: TextStyle(fontSize: 14, letterSpacing: 4),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),

          // profile tile
          Padding(
            padding: EdgeInsets.only(left: 20.w),
            child: ListTile(
              leading: const Icon(Icons.person),
              title: const Text(
                'PROFILE',
                style: TextStyle(fontSize: 14, letterSpacing: 4),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
            ),
          ),

          // BMI Calculator tile
          Padding(
            padding: EdgeInsets.only(left: 20.w),
            child: ListTile(
              leading: const Icon(Icons.calculate),
              title: const Text(
                'BMI CALCULATOR',
                style: TextStyle(fontSize: 14, letterSpacing: 4),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => InputScreen()),
                );
              },
            ),
          ),

          // Workout Plan tile
          Padding(
            padding: EdgeInsets.only(left: 20.w),
            child: ListTile(
              leading: const Icon(Icons.fitness_center),
              title: const Text(
                'WORKOUT PLAN',
                style: TextStyle(fontSize: 14, letterSpacing: 4),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => InputPage()),
                );
              },
            ),
          ),

          // Payment tile
          Padding(
            padding: EdgeInsets.only(left: 20.w),
            child: ListTile(
              leading: const Icon(Icons.monetization_on),
              title: const Text(
                'PAYMENT',
                style: TextStyle(fontSize: 14, letterSpacing: 4),
              ),
              onTap: () async {
                Navigator.pop(context); // Close the drawer

                // Show loading indicator
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return const AlertDialog(
                      content: Center(child: CircularProgressIndicator()),
                    );
                  },
                );

                try {
                  bool paymentCompleted = await checkPaymentStatus();
                  Navigator.pop(context); // Close loading dialog

                  if (paymentCompleted) {
                    showPaymentCompletedDialog(context);
                  } else {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const PaymentPage()),
                    );
                  }
                } catch (e) {
                  Navigator.pop(context); // Close loading dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${e.toString()}')),
                  );
                }
              },
            ),
          ),

          Padding(
            padding: EdgeInsets.only(left: 20.w),
            child: ListTile(
              leading: const Icon(Icons.history),
              title: const Text(
                'PAYMENT HISTORY',
                style: TextStyle(fontSize: 14, letterSpacing: 4),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => PaymentHistoryPage()),
                );
              },
            ),
          ),

          // logout tile
          Padding(
            padding: EdgeInsets.only(left: 20.w),
            child: ListTile(
              leading: const Icon(Icons.logout),
              title: const Text(
                'LOGOUT',
                style: TextStyle(fontSize: 14, letterSpacing: 4),
              ),
              onTap: () async {
                String result = await userSignout();
                if (result == "Success") {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                } else {
                  if (kDebugMode) {
                    print('Logout Failed');
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
