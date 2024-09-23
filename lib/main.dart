import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymapp/api/firebase_options.dart';
import 'package:gymapp/common/themes/dark_theme.dart';
import 'package:gymapp/common/themes/light_theme.dart';
import 'package:gymapp/common/widgets/my_bottom_navbar.dart';
import 'package:gymapp/features/auth/services/status_page.dart';
import 'package:gymapp/features/dashboard/home_page.dart';
import 'package:gymapp/features/fitness/common/combined_page.dart';
import 'package:gymapp/features/posts/pages/post_page.dart';
import 'package:gymapp/features/profile/pages/profile_page.dart';
import 'package:khalti_flutter/khalti_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 900),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return SafeArea(
          child: KhaltiScope(
            publicKey: 'test_public_key_49536e9f1a424b6fa5c79d0b85b765f6',
            enabledDebugging: true,
            builder: (context, navigatorKey) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Gym App',
                theme: lightMode,
                darkTheme: darkMode,
                home: child,
                supportedLocales: const [
                  Locale('en', 'US'),
                  Locale('ne', 'NP'),
                ],
                localizationsDelegates: const [
                  KhaltiLocalizations.delegate,
                ],
                navigatorKey: navigatorKey,
              );
            },
          ),
        );
      },
      child: const StatusPage(),
    );
  }
}

final selectedIndexProvider = StateProvider<int>((ref) => 0);

class MainPage extends ConsumerWidget {
  MainPage({super.key});

  final List<Widget> _pages = [
    const HomePage(),
    const PostPage(),
    const ProfilePage(),
    const CombinedPage(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(selectedIndexProvider);

    return Scaffold(
      bottomNavigationBar: BottomNavBar(
        selectedIndex: selectedIndex,
        onTap: (index) =>
            ref.read(selectedIndexProvider.notifier).state = index,
      ),
      body: _pages[selectedIndex],
    );
  }
}
