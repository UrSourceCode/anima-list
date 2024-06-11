import 'package:anima_list/components/watchlist/watchlist_card.dart';
import 'package:anima_list/models/anime_model.dart';
import 'package:anima_list/models/user_model.dart';
import 'package:anima_list/models/watchlist_model.dart';
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24),
                child: Column(
                  children: [
                    const Text(
                      'Profile',
                      style: AppTextStyles.displayLarge,
                    ),
                    const SizedBox(height: 20),
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
                        return Column(
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
                            const SizedBox(height: 20),
                            Text(
                              'Username: ${userDetail.username}',
                              style: AppTextStyles.titleLarge,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Email: ${userDetail.email}',
                              style: AppTextStyles.titleLarge,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Account created on: ${userDetail.createdAt.toDate().toLocal().toString().split(' ')[0]}',
                              style: AppTextStyles.titleLarge,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Last updated on: ${userDetail.updatedAt.toDate().toLocal().toString().split(' ')[0]}',
                              style: AppTextStyles.titleLarge,
                            ),
                            const SizedBox(height: 30),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
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
                        print(docs);
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
