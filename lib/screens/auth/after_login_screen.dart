import 'package:anima_list/models/user_model.dart';
import 'package:anima_list/services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AfterLoginScreen extends StatefulWidget {
  AfterLoginScreen({super.key});

  @override
  State<AfterLoginScreen> createState() => _AfterLoginScreenState();
}

class _AfterLoginScreenState extends State<AfterLoginScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  final UserService userService = UserService();
  Users? loggedInUser;

  @override
  void initState() {
    super.initState();
    getUserDetails();
  }

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  void getUserDetails() async {
    try {
      DocumentSnapshot<Object?> doc = await userService.getUserByUuid(user.uid);
      Users userDetail = Users.fromDocument(doc.data() as Map<String, dynamic>);
      setState(() {
        loggedInUser = userDetail;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loggedInUser == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: signUserOut,
          ),
        ],
      ),
      body: Center(
        child:
        Column(
          children: [
            const SizedBox(height: 60),

            Image.asset('assets/frieren.png', width: 180, height: 180),

            Text(
              "Welcome: \n${loggedInUser!.name}",
              style: TextStyle(
                fontSize: 24,
                color: Colors.grey[800],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

