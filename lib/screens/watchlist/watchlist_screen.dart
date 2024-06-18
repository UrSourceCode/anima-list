import 'package:anima_list/components/watchlist/watchlist_card.dart';
import 'package:anima_list/models/anime_model.dart';
import 'package:anima_list/models/user_model.dart';
import 'package:anima_list/models/watchlist_model.dart';
import 'package:anima_list/services/activity_service.dart';
import 'package:anima_list/services/user_service.dart';
import 'package:anima_list/services/watchlist_service.dart';
import 'package:anima_list/theme/colors.dart';
import 'package:anima_list/theme/text_styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class WatchlistScreen extends StatefulWidget {
  const WatchlistScreen({super.key});

  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  final UserService userService = UserService();
  final WatchlistService watchlistService = WatchlistService();
  final ActivityService activityService = ActivityService();

  File? _image;
  bool _isLoading = false;

  Future<void> _pickAndUploadImage() async {
    final image = await userService.pickImage();
    if (image != null) {
      setState(() {
        _image = image;
        _isLoading = true;
      });
      final downloadUrl = await userService.uploadImage(image);
      if (downloadUrl != null) {
        await user.updatePhotoURL(downloadUrl);
        await userService.updateUserPhotoUrl(user.uid, downloadUrl);
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
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

                  StreamBuilder<DocumentSnapshot>(
                    stream: userService.getUserStreamByUuid(user.uid),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.hasError) {
                        return const Center(child: Text('Error loading profile data'));
                      }

                      final userDoc = snapshot.data!;
                      final userDetail = Users.fromDocument(userDoc.data() as Map<String, dynamic>);
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(2.0),
                                          child: Image.network(
                                            userDetail.photoUrl ?? 'https://ui-avatars.com/api/?name=${userDetail.username}&background=random&size=100&rounded=true',
                                            width: 100.0,
                                            height: 100.0,
                                            fit: BoxFit.cover,
                                            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child;
                                              }
                                              return Center(
                                                child: CircularProgressIndicator(
                                                  value: loadingProgress.expectedTotalBytes != null
                                                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                                      : null,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        if (_isLoading)
                                          const Opacity(
                                            opacity: 0.5,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 6,
                                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                            ),
                                          ),
                                        if (!_isLoading)
                                          Positioned(
                                            bottom: 0,
                                            right: 0,
                                            child: Material(
                                              color: Colors.transparent,
                                              child: Container(
                                                height: 36,
                                                width: 36,
                                                decoration: BoxDecoration(
                                                  color: Colors.white.withOpacity(0.7),
                                                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(2)),
                                                ),
                                                child: Center(
                                                  child: IconButton(
                                                    icon: const Icon(Icons.camera_alt),
                                                    onPressed: _pickAndUploadImage,
                                                    iconSize: 20,
                                                    color: AppColors.lightPrimaryColor,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    )
                                  ],
                                ),
                                const SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Hello, ${userDetail.username}!',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.lightPrimaryColor,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      userDetail.email,
                                      style: AppTextStyles.bodyMedium,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Joined ${userDetail.createdAt.toDate().toLocal().toString().split(' ')[0]}',
                                      style: AppTextStyles.bodyMedium,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
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
                            'Your Stats',
                            style: AppTextStyles.titleLarge.copyWith(
                              color: AppColors.lightPrimaryColor,
                            )
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
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
                        int totalEpisodes = 0;
                        int totalWatchedEpisodes = 0;
                        int totalRating = 0;

                        for (final item in watchlistAndAnimeData) {
                          final watchlistItem = WatchlistItem.fromDocument(item['watchlistItem'] as Map<String, dynamic>);
                          final anime = Anime.fromDocument(item['animeData'] as Map<String, dynamic>);
                          totalEpisodes += anime.episodes;
                          totalWatchedEpisodes += watchlistItem.watchedEpisodes;
                          totalRating += watchlistItem.rating;
                        }

                        final double progress = (totalWatchedEpisodes / totalEpisodes) * 100;
                        final double averageRating = totalRating / watchlistAndAnimeData.length;

                        return Column(
                          children: [
                            IntrinsicHeight(
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: AppColors.lightPrimaryColor),
                                ),
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 80,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                              '${watchlistAndAnimeData.length}',
                                              style: AppTextStyles.titleLarge.copyWith(
                                                color: AppColors.lightPrimaryColor,
                                                fontSize: 32,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                          ),
                                          const Text(
                                            'Anime in Watchlist',
                                            maxLines: 2,
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Average Rating: ${averageRating.toStringAsFixed(2)}',
                                            style: AppTextStyles.bodyMedium,
                                          ),
                                          const SizedBox(height: 8),
                                          LinearProgressIndicator(
                                            value: progress / 100,
                                            backgroundColor: AppColors.lightSurfaceBackgroundColor,
                                            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.lightPrimaryColor),
                                            minHeight: 10,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            '$totalWatchedEpisodes / $totalEpisodes episodes watched (${progress.toStringAsFixed(2)}%)',
                                            style: AppTextStyles.bodyMedium,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 20),

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
                            'Last Anime Updated',
                            style: AppTextStyles.titleLarge.copyWith(
                              color: AppColors.lightPrimaryColor,
                            )
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
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
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
