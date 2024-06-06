import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: signUserOut,
          ),
        ],
      ),
      backgroundColor: Colors.black,
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
