import 'package:anima_list/screens/anime/anime_detail_screen.dart';
import 'package:anima_list/theme/colors.dart';
import 'package:anima_list/theme/text_styles.dart';
import 'package:flutter/material.dart';

import 'package:anima_list/models/anime_model.dart';

class AnimeCard extends StatelessWidget {
  final Anime anime;
  final String animeId;

  const AnimeCard({super.key, required this.anime, required this.animeId});

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
        width: 130,
        height: 280,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.lightSurfaceBackgroundColor,
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
                        style: AppTextStyles.titleMedium,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      const Spacer(),
                      Text(
                        '${anime.type} - ${anime.status}',
                        style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.onLightSurfaceNonActive
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${anime.season} - ${anime.year}',
                        style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.onLightSurfaceNonActive
                        ),
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
    );
  }
}
