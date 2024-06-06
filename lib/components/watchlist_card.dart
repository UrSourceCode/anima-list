import 'package:anima_list/models/anime_model.dart';
import 'package:anima_list/models/watchlist_model.dart';
import 'package:anima_list/theme/colors.dart';
import 'package:anima_list/theme/text_styles.dart';
import 'package:flutter/material.dart';

class WatchlistCard extends StatelessWidget {
  final Anime anime;
  final WatchlistItem watchlistItem;

  const WatchlistCard({super.key, required this.anime, required this.watchlistItem});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.lightDividerBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.network(
                    anime.pictureUrl,
                    fit: BoxFit.cover,
                    height: 60,
                  ),
                ),

                const SizedBox(width: 8),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      anime.title,
                      style: AppTextStyles.titleLarge.copyWith(
                        color: AppColors.lightPrimaryColor,
                        fontWeight: FontWeight.bold,
                      )
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Rating: ${watchlistItem.rating}',
                      style: AppTextStyles.titleMedium
                    ),

                    const SizedBox(height: 4),
                    Text(
                      'Episodes: ${watchlistItem.watchedEpisodes} / ${anime.episodes}',
                      style: AppTextStyles.titleMedium
                    ),
                  ],
                )
              ],

            ),

          ],
        ),
      ),
    );
  }
}
