import 'package:flutter/material.dart';
import 'package:AnimaList/theme/colors.dart';
import 'package:AnimaList/theme/text_styles.dart';

class ReviewOverview extends StatelessWidget {
  final String reviewContent;
  final String animeTitle;
  final String author;
  final String avatarUrl;

  const ReviewOverview({
    super.key,
    required this.reviewContent,
    required this.animeTitle,
    required this.author,
    required this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to a detailed review screen if needed
      },
      child: SizedBox(
        height: 70,
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: Image.network(
                avatarUrl,
                width: 48,
                height: 48,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '$author in $animeTitle',
                    style: AppTextStyles.titleMedium.copyWith(color: AppColors.lightPrimaryColor),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    reviewContent,
                    style: AppTextStyles.bodyMedium,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
