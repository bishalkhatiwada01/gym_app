import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymapp/features/bmi/screens/input_screen.dart';
import 'package:gymapp/features/auth/pages/login_page.dart';
import 'package:gymapp/features/payment/pages/payment_history_page.dart';
import 'package:gymapp/features/profile/data/user_service.dart';
import 'package:gymapp/main.dart';

class MyDrawer extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final userDataAsyncValue = ref.watch(userProvider);

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
      child: Container(
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
        child: Column(
          children: [
            SizedBox(
              height: 20.h,
            ),

            userDataAsyncValue.when(
              data: (userData) {
                return DrawerHeader(
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.black,
                        child: userData.profileImageUrl == null
                            ? const CircleAvatar(
                                radius: 50,
                                backgroundImage: AssetImage("assets/user.png"),
                              )
                            : CircleAvatar(
                                radius: 50,
                                backgroundImage: NetworkImage(
                                  userData.profileImageUrl!,
                                ),
                              ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userData.username,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 25.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              userData.email,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
              error: (error, stackTrace) {
                return Center(child: Text('Error: $error'));
              },
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
            ),
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
                  ref.read(selectedIndexProvider.notifier).state =
                      2; // Assuming ProfilePage is at index 2
                  Navigator.pop(context);
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
                  style: TextStyle(
                    fontSize: 14,
                    letterSpacing: 4,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const InputScreen()),
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
                  'MY PLANS',
                  style: TextStyle(fontSize: 14, letterSpacing: 4),
                ),
                onTap: () {
                  // Update the selected index to show the CombinedPage
                  ref.read(selectedIndexProvider.notifier).state =
                      3; // Assuming CombinedPage is at index 3
                  Navigator.pop(context); // Close the drawer
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
                    MaterialPageRoute(
                        builder: (context) => const PaymentHistoryPage()),
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
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
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
      ),
    );
  }
}
