import 'package:flutter/material.dart';

import '../../models/anime_model.dart';
import '../../screens/anime/anime_detail_screen.dart';
import '../../theme/colors.dart';
import '../../theme/text_styles.dart';


class AnimeCard extends StatelessWidget {
  final Anime anime;
  final String animeId;
  final bool isOnWatchlist;

  const AnimeCard({
    super.key,
    required this.anime,
    required this.animeId,
    required this.isOnWatchlist
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
      child: Stack(
        children: [
          SizedBox(
            width: 130,
            height: 280,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(4),
                    ),
                    child: Image.network(
                      anime.pictureUrl,
                      fit: BoxFit.cover,
                      height: 160,
                      width: 130,
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
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: SizedBox(
                      height: 75,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            anime.title,
                            style: AppTextStyles.bodyMedium,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    '${anime.type} - ${anime.status}',
                                    style: AppTextStyles.bodySmall.copyWith(
                                        color: AppColors.onLightSurfaceNonActive
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${anime.season} - ${anime.year}',
                                    style: AppTextStyles.bodySmall.copyWith(
                                        color: AppColors.onLightSurfaceNonActive
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              if (isOnWatchlist)
                                const Icon(
                                    Icons.bookmark_outlined,
                                    color: AppColors.lightPrimaryColor,
                                    size: 32
                                )
                            ],
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]
      ),
    );
  }
}
