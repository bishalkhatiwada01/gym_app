import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymapp/common/widgets/my_button.dart';
import 'package:gymapp/common/widgets/my_password_textfield.dart';
import 'package:gymapp/common/widgets/my_textfield.dart';
import 'package:gymapp/features/auth/pages/login_page.dart';
import 'package:gymapp/features/auth/services/auth_service.dart';
import 'package:gymapp/features/auth/services/status_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({
    super.key,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final AuthService _authService = AuthService();

  // text controller
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPwController = TextEditingController();

  Future<void> _register() async {
    await _authService.register(
      emailController.text,
      passwordController.text,
      usernameController.text,
    );
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const StatusPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => LoginPage()));
          },
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.transparent,
            ),
            padding: EdgeInsets.all(10.sp),
            child: Icon(
              Icons.arrow_back,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.sp),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Icon
                Icon(
                  Icons.person,
                  size: 80,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),

                // name of app
                Text(
                  '''Let's Get Started!!!''',
                  style: TextStyle(
                    fontSize: 20.sp,
                  ),
                ),
                SizedBox(height: 25.h),

                // username textfield
                MyTextField(
                  hintText: 'Username',
                  obscureText: false,
                  controller: usernameController,
                ),
                SizedBox(height: 10.h),

                // email textfield
                MyTextField(
                  hintText: 'Email',
                  obscureText: false,
                  controller: emailController,
                ),
                SizedBox(height: 10.h),

                // password textfield

                MyPasswordTextField(
                  hintText: 'Password',
                  obscureText: true,
                  controller: passwordController,
                ),

                SizedBox(height: 10.h),

                // confirm password textfield
                MyPasswordTextField(
                  hintText: 'Confirm Password',
                  obscureText: true,
                  controller: confirmPwController,
                ),
                SizedBox(height: 10.h),

                // register button
                MyButton(
                  text: 'Register',
                  onTap: _register,
                ),
                SizedBox(height: 25.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()));
                      },
                      child: const Text('Login Here',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
