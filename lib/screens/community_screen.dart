import 'package:AnimaList/components/review_overview.dart';
import 'package:AnimaList/services/anime_service.dart';
import 'package:AnimaList/services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../theme/colors.dart';
import '../theme/text_styles.dart';

class CommunityScreen extends StatefulWidget {
  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final AnimeService animeService = AnimeService();
  final UserService userService = UserService();

  @override
  Widget build(BuildContext context) {
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
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
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
                        'Latest Reviews',
                        style: AppTextStyles.titleLarge.copyWith(
                          color: AppColors.lightPrimaryColor,
                        )
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24),
                child: StreamBuilder<List<Map<String, dynamic>>>(
                  stream: animeService.streamAllAnime(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    final animes = snapshot.data ?? [];
                    if (animes.isEmpty) {
                      return const Center(child: Text('No animes found'));
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: animes.length,
                      itemBuilder: (context, index) {
                        final anime = animes[index];
                        return StreamBuilder<List<Map<String, dynamic>>>(
                          stream: animeService.getReviewsForAnime(anime['animeId']),
                          builder: (context, reviewSnapshot) {
                            if (reviewSnapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            if (reviewSnapshot.hasError) {
                              return Center(child: Text('Error: ${reviewSnapshot.error}'));
                            }

                            final reviews = reviewSnapshot.data ?? [];
                            if (reviews.isEmpty) {
                              return const SizedBox.shrink(); // Do not display anime without reviews
                            }

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: reviews.length,
                                  itemBuilder: (context, reviewIndex) {
                                    final review = reviews[reviewIndex];
                                    return StreamBuilder<DocumentSnapshot>(
                                      stream: userService.getUserStreamByUuid(review['userId']),
                                      builder: (context, userSnapshot) {
                                        if (userSnapshot.connectionState == ConnectionState.waiting) {
                                          return const Center(child: CircularProgressIndicator());
                                        }
                                        if (userSnapshot.hasError) {
                                          return Center(child: Text('Error: ${userSnapshot.error}'));
                                        }

                                        final userData = userSnapshot.data?.data() as Map<String, dynamic>?;
                                        final author = userData != null ? userData['username'] ?? 'Unknown Author' : 'Unknown Author';
                                        final content = review['review'] ?? 'No Content';
                                        return ReviewOverview(
                                          reviewContent: content,
                                          animeTitle: anime['title'] ?? 'Unknown Anime',
                                          author: author,
                                          avatarUrl: userData?['photoUrl'] ?? 'https://ui-avatars.com/api/?name=$author&background=random&size=100',
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
