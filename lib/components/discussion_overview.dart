import 'package:anima_list/models/thread_model.dart';
import 'package:anima_list/theme/colors.dart';
import 'package:anima_list/theme/text_styles.dart';
import 'package:flutter/material.dart';

class DiscussionOverview extends StatelessWidget {
  final Thread thread;
  final String author;

  const DiscussionOverview({super.key, required this.thread, required this.author});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            thread.title,
            style: AppTextStyles.titleLarge.copyWith(color: AppColors.lightPrimaryColor),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
          const SizedBox(height: 4),
          Text(
            'by - $author',
            style: AppTextStyles.bodyMedium,
          )
        ],
      ),
    );
  }
}