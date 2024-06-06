import 'package:anima_list/components/anime_card.dart';
import 'package:anima_list/components/discussion_overview.dart';
import 'package:anima_list/models/anime_model.dart';
import 'package:anima_list/models/thread_model.dart';
import 'package:anima_list/models/user_model.dart';
import 'package:anima_list/services/anime_service.dart';
import 'package:anima_list/services/thread_service.dart';
import 'package:anima_list/services/user_service.dart';
import 'package:anima_list/theme/colors.dart';
import 'package:anima_list/theme/text_styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  final UserService userService = UserService();
  Users? loggedInUser;

  final AnimeService animeService = AnimeService();

  final ThreadService threadService = ThreadService();

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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //const SizedBox(height: 60),
                    Text(
                      'Home Page',
                      style: AppTextStyles.displayLarge,
                    ),
                  ],
                ),
              ),

              FutureBuilder<QuerySnapshot>(
                future: animeService.getAllAnime(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final List<DocumentSnapshot> docs = snapshot.data!.docs;

                  return Container(
                    color: AppColors.lightDividerBackgroundColor,
                    height: 280,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Row(
                            children: [
                                AnimeCard(
                                  anime: Anime.fromDocument(docs[index].data() as Map<String, dynamic>),
                                ),
                              const SizedBox(width: 16),
                            ],
                          );
                        },
                      ),
                    ),
                  );
                },
              ),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('This is a text'),
                  ],
                ),
              ),

              // Fetch threads
              FutureBuilder<QuerySnapshot>(
                future: threadService.getAllThreads(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final List<DocumentSnapshot> docs = snapshot.data!.docs;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
                    child: Column(
                      children: docs.map((doc) {
                        return FutureBuilder<Map<String, dynamic>>(
                          future: threadService.getThreadAndAuthorData(doc.id),
                          builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
                            if (snapshot.hasError) {
                              return Center(child: Text('Error: ${snapshot.error}'));
                            }

                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            }

                            final Map<String, dynamic> data = snapshot.data!;
                            final Thread thread = Thread.fromDocument(data['threadData'] as Map<String, dynamic>);
                            final Users author = Users.fromDocument(data['userData'] as Map<String, dynamic>);

                            return DiscussionOverview(
                              thread: thread,
                              author: author.username,
                            );
                          },
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
