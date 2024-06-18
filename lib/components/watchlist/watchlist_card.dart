import 'package:anima_list/components/watchlist/watchlist_dialog.dart';
import 'package:anima_list/enum/list_status_enum.dart';
import 'package:anima_list/models/anime_model.dart';
import 'package:anima_list/models/watchlist_model.dart';
import 'package:anima_list/theme/colors.dart';
import 'package:anima_list/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:anima_list/services/watchlist_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WatchlistCard extends StatelessWidget {
  final Anime anime;
  final WatchlistItem watchlistItem;
  final WatchlistService watchlistService = WatchlistService();
  final user = FirebaseAuth.instance.currentUser!;
  final String documentId;

  WatchlistCard({
    super.key,
    required this.anime,
    required this.watchlistItem,
    required this.documentId,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return WatchlistDialog(
              anime: anime,
              initialRating: watchlistItem.rating,
              initialWatchedEpisodes: watchlistItem.watchedEpisodes,
              initialListStatus: ListStatusExtension.fromString(watchlistItem.listStatus),
              onSave: (newRating, newWatchedEpisodes, newListStatus) {
                watchlistService.updateWatchlistItem(
                  user.uid,
                  documentId,
                  newListStatus,
                  newRating,
                  newWatchedEpisodes,
                );
              }
            );
          },
        );
      },
      child: Card(
        color: AppColors.lightSurfaceBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.network(
                            anime.pictureUrl,
                            fit: BoxFit.cover,
                            height: 60,
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

                        const SizedBox(width: 8),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                  anime.title,
                                  softWrap: true,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.titleMedium.copyWith(
                                    color: AppColors.lightPrimaryColor,
                                    fontWeight: FontWeight.bold,
                                  )
                              ),
                              const SizedBox(height: 4),
                              Text(
                                  'Rating: ${watchlistItem.rating}',
                                  style: AppTextStyles.bodyMedium
                              ),

                              const SizedBox(height: 4),
                              Text(
                                  'Episodes: ${watchlistItem.watchedEpisodes} / ${anime.episodes}',
                                  style: AppTextStyles.bodyMedium
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      showDialog(context: context, builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                              'Confirm Deletion',
                              style: AppTextStyles.titleLarge.copyWith(
                                color: Colors.red,
                                  fontWeight: FontWeight.bold
                              )
                          ),
                          content: RichText(
                            text: TextSpan(
                              style: AppTextStyles.bodyMedium,
                              children: [
                                const TextSpan(
                                  text: 'Are you sure you want to delete ',
                                ),
                                TextSpan(
                                  text: anime.title,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const TextSpan(
                                  text: ' from your watchlist?',
                                ),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                watchlistService.deleteWatchlistItem(user.uid, documentId);
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                'Delete',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        );
                      });
                    }, icon: const Icon(Icons.delete, color: AppColors.lightSurfaceBackgroundColor),
                  )
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}