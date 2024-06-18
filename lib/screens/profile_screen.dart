import 'package:anima_list/models/user_model.dart';
import 'package:anima_list/services/user_service.dart';
import 'package:anima_list/services/watchlist_service.dart';
import 'package:anima_list/theme/text_styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  final UserService userService = UserService();
  final WatchlistService watchlistService = WatchlistService();
  Users? loggedInUser;

  @override
  void initState() {
    super.initState();
    getUserDetails();
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

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    if (loggedInUser == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Profile',
                  style: AppTextStyles.displayLarge,
                ),
                const SizedBox(height: 20),
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: signUserOut,
                ),
                const SizedBox(height: 20),
                Text(
                  'Username: ${loggedInUser?.username ?? ''}',
                  style: AppTextStyles.displayMedium,
                ),
                const SizedBox(height: 10),
                Text(
                  'Email: ${loggedInUser?.email ?? ''}',
                  style: AppTextStyles.displayMedium,
                ),
                const SizedBox(height: 10),
                Text(
                  'Account created on: ${loggedInUser?.createdAt.toDate().toLocal().toString().split(' ')[0] ?? ''}',
                  style: AppTextStyles.displayMedium,
                ),
                const SizedBox(height: 10),
                Text(
                  'Last updated on: ${loggedInUser?.updatedAt.toDate().toLocal().toString().split(' ')[0] ?? ''}',
                  style: AppTextStyles.displayMedium,
                ),
                const SizedBox(height: 30), // Add watchlist items here
              ],
            ),
          ),
        ),
      ),
    );
  }
}