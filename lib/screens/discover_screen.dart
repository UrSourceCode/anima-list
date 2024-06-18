import 'package:AnimaList/models/anime_model.dart';
import 'package:AnimaList/models/user_model.dart';
import 'package:AnimaList/services/anime_service.dart';
import 'package:AnimaList/services/thread_service.dart';
import 'package:AnimaList/services/user_service.dart';
import 'package:AnimaList/services/watchlist_service.dart';
import 'package:AnimaList/theme/colors.dart';
import 'package:AnimaList/theme/text_styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/anime/anime_card.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
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
    fetchAnimeIds();
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: AppColors.lightSurfaceBackgroundColor,
                width: double.infinity,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'AnimaList',
                        style: AppTextStyles.displayLarge,
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(color: AppColors.lightBackgroundColor, height: 2),
              StreamBuilder<QuerySnapshot>(
                stream: animeService.getAllAnime(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container();
                  }

                  final List<DocumentSnapshot> docs = snapshot.data!.docs;
                  final List<String> animeIds = docs.map((doc) => doc.id).toList();

                  return StreamBuilder<Map<String, bool>>(
                    stream: watchlistService.getUserWatchlistStatus(user.uid, animeIds),
                    builder: (BuildContext context, AsyncSnapshot<Map<String, bool>> watchlistSnapshot) {
                      if (watchlistSnapshot.connectionState == ConnectionState.waiting) {
                        return Container();
                      }

                      if (watchlistSnapshot.hasError) {
                        return Center(child: Text('Error: ${watchlistSnapshot.error}'));
                      }

                      final watchlistStatus = watchlistSnapshot.data ?? {};

                      return Container(
                        color: AppColors.lightSurfaceBackgroundColor,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 4,
                                    height: 20,
                                    decoration: const BoxDecoration(
                                      color: AppColors.lightPrimaryColor,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Discover All Anime',
                                    style: AppTextStyles.titleLarge.copyWith(
                                      color: AppColors.lightPrimaryColor,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: docs.length,
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.66,
                                  mainAxisSpacing: 16.0,
                                  crossAxisSpacing: 8.0,
                                ),
                                itemBuilder: (context, index) {
                                  final doc = docs[index];
                                  final Anime anime = Anime.fromDocument(doc.data() as Map<String, dynamic>);
                                  final bool isOnWatchlist = watchlistStatus[doc.id] ?? false;

                                  return Flexible(
                                    child: AnimeCard(
                                      anime: anime,
                                      animeId: doc.id,
                                      isOnWatchlist: isOnWatchlist,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
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
