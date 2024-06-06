import 'package:anima_list/services/anime_service.dart';
import 'package:anima_list/theme/colors.dart';
import 'package:anima_list/theme/text_styles.dart';
import 'package:flutter/material.dart';

import 'package:anima_list/models/anime_model.dart';

class AnimeCard extends StatelessWidget {
  final Anime anime;

  const AnimeCard({super.key, required this.anime});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 130,
      height: 280,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.lightSurfaceBackgroundColor,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Aligning content to the left
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
              padding: const EdgeInsets.symmetric(horizontal: 8), // Adding padding to the text
              child: SizedBox(
                height: 75, // Set a specific height
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Aligning text to the left
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
    );
  }
}
