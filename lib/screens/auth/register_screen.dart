import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:anima_list/components/my_button.dart';
import 'package:anima_list/components/my_textfield.dart';
import 'package:anima_list/theme/colors.dart';
import 'package:anima_list/theme/text_styles.dart';
import 'package:anima_list/services/user_service.dart';
import 'package:anima_list/models/user_model.dart';

class RegisterScreen extends StatefulWidget {
  final Function()? onTap;
  const RegisterScreen({super.key, this.onTap});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final UserService _userService = UserService();

  void signUserUp() async {
    showDialog(context: context, builder: (context) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    });

    try {
      if (passwordController.text == confirmPasswordController.text) {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
              email: emailController.text,
              password: passwordController.text
        );

        User? user = userCredential.user;

        if (user != null) {
          Users newUser = Users(
            email: emailController.text,
            username: usernameController.text,
            createdAt: Timestamp.now(),
            updatedAt: Timestamp.now(),
          );

          await _userService.addUserToCollection(newUser, user.uid);
        }
      } else {
        showErrorMessage('Passwords do not match!');
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        Navigator.pop(context);
      }
      showErrorMessage(e.code);
    } finally {
      if (mounted) {
        Navigator.pop(context);
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
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  const Text(
                    'Register',
                    style: AppTextStyles.displayLarge,
                  ),

                  const SizedBox(height: 16),

                  Text(
                        'Let\'s create an account for you!',
                        style: AppTextStyles.titleLarge.copyWith(color: AppColors.onLightBackgroundColor)
                  ),

                  const SizedBox(height: 20),

                  MyTextField(
                      controller: usernameController,
                      hintText: 'Username',
                      obscureText: false
                  ),

                  const SizedBox(height: 12),

                  MyTextField(
                      controller: emailController,
                      hintText: 'Email',
                      obscureText: false
                  ),

                  const SizedBox(height: 12),

                  MyTextField(
                      controller: passwordController,
                      hintText: 'Password',
                      obscureText: true
                  ),

                  const SizedBox(height: 12),

                  MyTextField(
                      controller: confirmPasswordController,
                      hintText: 'Confirm Password',
                      obscureText: true
                  ),

                  const SizedBox(height: 24),
                  MyButton(
                      onTap: signUserUp,
                      text: 'Sign Up'
                  ),

                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an account?',
                        style: AppTextStyles.titleMedium,
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text(
                          'Login now!',
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
