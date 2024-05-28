import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children:[
                  // SizedBox(height: 60),
                  Text(
                    'Profile Page',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.red.shade900,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),

                  // SizedBox(height: 20),
                ],
            ),
          )
      )
    );
  }
}
