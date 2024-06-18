import 'package:AnimaList/screens/anime/anime_detail_screen.dart';
import 'package:AnimaList/theme/colors.dart';
import 'package:AnimaList/theme/text_styles.dart';
import 'package:flutter/material.dart';

import 'package:AnimaList/models/anime_model.dart';

class TopAnime extends StatelessWidget {
  final Anime anime;
  final String animeId;
  final bool isOnWatchlist;
  final String ranking;
  final double rating;

  const TopAnime({
    super.key,
    required this.anime,
    required this.animeId,
    required this.isOnWatchlist,
    required this.ranking,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AnimeDetailScreen(animeId: animeId),
          ),
        );
      },
      child: SizedBox(
        width: double.infinity,
        height: 70, // Adjust the height if necessary
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  bottomLeft: Radius.circular(4),
                ),
                child: Image.network(
                  anime.pictureUrl,
                  fit: BoxFit.cover,
                  height: 70,
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
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$ranking - ${anime.title}',
                                style: AppTextStyles.bodyMedium,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${anime.type} - ${anime.status}',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.onLightSurfaceNonActive,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${anime.season} - ${anime.year}',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.onLightSurfaceNonActive,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              const Icon(Icons.star, color: AppColors.lightPrimaryColor, size: 24),
                              Text(
                                '$rating',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.onLightSurfaceNonActive,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Spacer(),
                      if (isOnWatchlist)
                        const Icon(
                          Icons.bookmark_outlined,
                          color: AppColors.lightPrimaryColor,
                          size: 32,
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}