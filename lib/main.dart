import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymapp/api/firebase_options.dart';
import 'package:gymapp/common/themes/dark_theme.dart';
import 'package:gymapp/common/themes/light_theme.dart';
import 'package:gymapp/common/widgets/my_bottom_navbar.dart';
import 'package:gymapp/features/auth/services/status_page.dart';
import 'package:gymapp/features/workout_plan/fitness_form.dart';
import 'package:gymapp/features/dashboard/home_page.dart';
import 'package:gymapp/features/dashboard/workout_question_page.dart';
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
      // designSize: const Size(430, 932),
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
                title: 'Charity Management App',
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
      child: StatusPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _pages = [
    const HomePage(),
    PostPage(),
    const ProfilePage(),
    WorkoutQuestionsPage(),
  ];

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      body: _pages[_selectedIndex],
    );
  }
}
