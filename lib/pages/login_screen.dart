import 'package:firebase_auth/firebase_auth.dart';
import 'package:anima_list/components/my_textfield.dart';
import 'package:flutter/material.dart';

import '../components/my_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

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
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
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
      backgroundColor: Colors.black87,
      body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                Image.asset('assets/fern.png', width:180, height: 180),

                const SizedBox(height: 20),

                Text(
                  'Welcome to AnimaList',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.red.shade900,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  'Please login to continue',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade400,
                  )
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
                              style: TextStyle(
                                  color: Colors.red.shade900
                              )
                          )
                      )
                    ],
                  ),
                ),

                MyButton(
                    onTap: signUserIn,
                    text: 'Sign In'
                ),
              ],
            )
          ),
          ),
    );
  }
}
