import 'package:anima_list/components/watchlist_card.dart';
import 'package:anima_list/models/anime_model.dart';
import 'package:anima_list/models/user_model.dart';
import 'package:anima_list/models/watchlist_model.dart';
import 'package:anima_list/services/user_service.dart';
import 'package:anima_list/services/watchlist_service.dart';
import 'package:anima_list/theme/text_styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WatchlistScreen extends StatefulWidget {
  const WatchlistScreen({super.key});

  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Watchlist',
                      style: AppTextStyles.displayLarge,
                    ),
                    const SizedBox(height: 20),
                    StreamBuilder<QuerySnapshot>(
                      stream: watchlistService.getUserWatchlist(user.uid),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }

                        final List<DocumentSnapshot> docs = snapshot.data!.docs;
                        return Text('Number of items in watchlist: ${docs.length}');
                      },
                    ),

                    const SizedBox(height: 8),
                    StreamBuilder<List<Map<String, dynamic>>>(
                      stream: watchlistService.getAnimeFromWatchlistStream(user.uid),
                      builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }

                        final List<Map<String, dynamic>> watchlistAndAnimeData = snapshot.data!;
                        return ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: watchlistAndAnimeData.length,
                          itemBuilder: (BuildContext context, int index) {
                            return WatchlistCard(
                              watchlistItem: WatchlistItem.fromDocument(watchlistAndAnimeData[index]['watchlistItem'] as Map<String, dynamic>),
                              anime: Anime.fromDocument(watchlistAndAnimeData[index]['animeData'] as Map<String, dynamic>),
                              documentId: watchlistAndAnimeData[index]['documentId'] as String,
                            );
                          },
                        );
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}
