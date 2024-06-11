import 'package:anima_list/theme/colors.dart';
import 'package:anima_list/theme/text_styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:anima_list/components/misc/my_textfield.dart';
import 'package:flutter/material.dart';
import 'package:anima_list/components/misc/my_button.dart';

class LoginScreen extends StatefulWidget {
  final Function()? onTap;
  const LoginScreen({super.key, this.onTap});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void signUserIn() async {
    showDialog(context: context, builder: (context) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: usernameController.text,
          password: passwordController.text
      );
      if (mounted) {
        Navigator.pop(context);
      }

    } on FirebaseAuthException catch (e) {
      if (mounted){
        Navigator.pop(context);
      }
      if (e.code == 'user-not-found') {
        showErrorMessage('No user found for that email :(');
      } else if (e.code == 'wrong-password') {
        showErrorMessage('Wrong password provided for that user XD');
      }
    }
  }

  void showErrorMessage(String message) {
    showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: Text(message),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 60),
                  Image.asset('assets/fern.png', width:180, height: 180),

                  const SizedBox(height: 20),

                  const Text(
                    'Welcome to AnimaList',
                    style: AppTextStyles.displayLarge,
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    'Please login to continue!',
                    style: AppTextStyles.titleLarge,
                  ),

                  const SizedBox(height: 20),

                  MyTextField(
                      controller: usernameController,
                      hintText: 'Email',
                      obscureText: false
                  ),

                  const SizedBox(height: 16),

                  MyTextField(
                      controller: passwordController,
                      hintText: 'Password',
                      obscureText: true
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () {},
                            child: Text(
                                'Forgot Password?',
                                style: AppTextStyles.titleMedium.copyWith(color: AppColors.lightPrimaryColor, fontWeight: FontWeight.bold)

                            )
                        )
                      ],
                    ),
                  ),

                  MyButton(
                      onTap: signUserIn,
                      text: 'Sign In'
                  ),

                  const SizedBox(height: 24),

                  // not a member? register now
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Not a member?',
                        style: AppTextStyles.titleMedium,
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text(
                          'Register now',
                            style: AppTextStyles.titleMedium.copyWith(color: AppColors.lightPrimaryColor, fontWeight: FontWeight.bold)

                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ),
        ),
    );
  }
}
