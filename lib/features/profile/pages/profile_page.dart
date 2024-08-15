import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymapp/features/auth/pages/login_page.dart';
import 'package:gymapp/features/profile/data/user_service.dart';
import 'package:gymapp/features/profile/widgets/my_card_profile.dart';
import 'package:share_plus/share_plus.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  Future<String> userSignout() async {
    try {
      await FirebaseAuth.instance.signOut();
      return "Success";
    } on FirebaseAuthException catch (e) {
      return "${e.message}";
    }
  }

  @override
  Widget build(BuildContext context) {
    final userDataAsyncValue = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'PROFILE',
          style: TextStyle(
              color: Theme.of(context).colorScheme.inversePrimary,
              letterSpacing: 4),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.background,
        centerTitle: true,
        iconTheme:
            IconThemeData(color: Theme.of(context).colorScheme.inversePrimary),
      ),
      body: userDataAsyncValue.when(
        data: (userData) {
          final Map<String, dynamic> user = userData.data()!;
          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 25.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: const CircleAvatar(
                        maxRadius: 65,
                        backgroundImage: AssetImage("assets/6195145.jpg"),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage("assets/download.png"),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    CircleAvatar(
                      backgroundImage:
                          AssetImage("assets/GooglePlus-logo-red.png"),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    CircleAvatar(
                      backgroundImage: AssetImage(
                          "assets/1_Twitter-new-icon-mobile-app.jpg"),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    CircleAvatar(
                      backgroundImage:
                          AssetImage("assets/600px-LinkedIn_logo_initials.png"),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      user['email'],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  margin: const EdgeInsets.only(left: 12, right: 12),
                  child: Column(
                    children: [
                      SizedBox(height: 6.h),
                      MyCardProfile(
                        onPressed: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => DonationHistoryPage(),
                          //   ),
                          // );
                        },
                        title: 'Payment History',
                        leading: const Icon(
                          Icons.history_edu,
                          color: Colors.black54,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      SizedBox(height: 6.h),
                      MyCardProfile(
                        onPressed: () {
                          Share.share('https://gymapp.com');
                        },
                        title: 'Invite a Friend',
                        leading: const Icon(
                          Icons.add_reaction_sharp,
                          color: Colors.black54,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      MyCardProfile(
                        onPressed: () async {
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
                        title: 'Logout',
                        leading: const Icon(
                          Icons.logout,
                          color: Colors.black54,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      const SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
        error: (error, stackTrace) {
          return null;
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
