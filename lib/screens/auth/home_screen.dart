import 'dart:async';

import 'package:anima_list/components/anime/anime_card.dart';
import 'package:anima_list/components/discussion/discussion_overview.dart';
import 'package:anima_list/models/anime_model.dart';
import 'package:anima_list/models/thread_model.dart';
import 'package:anima_list/models/user_model.dart';
import 'package:anima_list/services/anime_service.dart';
import 'package:anima_list/services/thread_service.dart';
import 'package:anima_list/services/user_service.dart';
import 'package:anima_list/services/watchlist_service.dart';
import 'package:anima_list/theme/colors.dart';
import 'package:anima_list/theme/text_styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  final UserService userService = UserService();
  Users? loggedInUser;
  late final List<String> animeIds;

  final AnimeService animeService = AnimeService();
  final ThreadService threadService = ThreadService();
  final WatchlistService watchlistService = WatchlistService();

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

  void fetchAnimeIds() async {
    try {
      QuerySnapshot snapshot = await animeService.getAllAnime().first;
      setState(() {
        animeIds = snapshot.docs.map((doc) => doc.id).toList();
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
                    Text(
                      'Home Page',
                      style: AppTextStyles.displayLarge,
                    ),
                  ],
                ),
              ),

              StreamBuilder<QuerySnapshot>(
                stream: animeService.getAllAnime(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final List<DocumentSnapshot> docs = snapshot.data!.docs;
                  final List<String> animeIds = docs.map((doc) => doc.id).toList();

                  return StreamBuilder<Map<String, bool>>(
                    stream: watchlistService.getUserWatchlistStatus(user.uid, animeIds),
                    builder: (BuildContext context, AsyncSnapshot<Map<String, bool>> watchlistSnapshot) {
                      if (watchlistSnapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                      }

                      if (watchlistSnapshot.hasError) {
                      return Center(child: Text('Error: ${watchlistSnapshot.error}'));
                      }

                      final watchlistStatus = watchlistSnapshot.data ?? {};
                      print(watchlistStatus);

                      return Container(
                        color: AppColors.lightDividerBackgroundColor,
                        height: 280,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: docs.length,
                            itemBuilder: (BuildContext context, int index) {
                              final DocumentSnapshot doc = docs[index];
                              final Anime anime = Anime.fromDocument(doc.data() as Map<String, dynamic>);
                              final bool isOnWatchlist = watchlistStatus[doc.id] ?? false;

                              return Row(
                                children: [
                                  AnimeCard(
                                    anime: anime,
                                    animeId: doc.id,
                                    isOnWatchlist: isOnWatchlist,
                                  ),
                                  const SizedBox(width: 16),
                                ],
                              );
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),

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
                        return StreamBuilder<Map<String, dynamic>>(
                          stream: threadService.getThreadAndAuthorData(doc.id),
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

                            return StreamBuilder<QuerySnapshot>(
                              stream: threadService.getReplyStream(doc.id),
                              builder: (context, replySnapshot) {
                                if (replySnapshot.hasError) {
                                  return Center(child: Text('Error: ${replySnapshot.error}'));
                                }

                                if (replySnapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(child: CircularProgressIndicator());
                                }

                                final int repliesCount = replySnapshot.data?.docs.length ?? 0;

                                return Column(
                                  children: [
                                    DiscussionOverview(
                                      thread: thread,
                                      author: author.username,
                                      avatarUrl: author.photoUrl != null ? author.photoUrl! : 'https://ui-avatars.com/api/?name=${author.username}&background=random&size=100&rounded=true',
                                      repliesCount: repliesCount,
                                      threadId: doc.id,
                                      isLoggedIn: user.uid,
                                    ),
                                    const Divider(color: AppColors.onLightSurfaceNonActive),
                                  ],
                                );
                              },
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
