import 'package:AnimaList/models/thread_model.dart';
import 'package:AnimaList/screens/thread/thread_detail_screen.dart';
import 'package:AnimaList/theme/colors.dart';
import 'package:AnimaList/theme/text_styles.dart';
import 'package:flutter/material.dart';

class DiscussionOverview extends StatelessWidget {
  final Thread thread;
  final String threadId;
  final String author;
  final String avatarUrl;
  final int repliesCount;
  final String isLoggedIn;

  const DiscussionOverview({
    super.key,
    required this.thread,
    required this.threadId,
    required this.author,
    required this.avatarUrl,
    required this.repliesCount,
    required this.isLoggedIn,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ThreadDetailScreen(
              threadId: threadId,
              isLoggedIn: isLoggedIn,
              repliesCount: repliesCount,
            ),
          ),
        );
      },
      child: SizedBox(
        height: 54,
        width: MediaQuery.of(context).size.width,
        child: Row(
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    thread.title,
                    style: AppTextStyles.titleMedium.copyWith(color: AppColors.lightPrimaryColor),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'by - $author',
                        style: AppTextStyles.bodyMedium,
                      ),
                      Row(
                        children: [
                          const Icon(Icons.comment_rounded, size: 16, color: AppColors.lightPrimaryColor),
                          const SizedBox(width: 4),
                          Text(
                            repliesCount.toString(),
                            style: AppTextStyles.bodyMedium,
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}