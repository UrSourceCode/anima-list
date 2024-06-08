import 'package:anima_list/models/anime_model.dart';
import 'package:anima_list/theme/colors.dart';
import 'package:anima_list/theme/text_styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../services/anime_service.dart';

class AnimeDetailScreen extends StatefulWidget {
  final String animeId;

  const AnimeDetailScreen({
    required this.animeId,
    Key? key
  }) : super(key: key);

  @override
  State<AnimeDetailScreen> createState() => _AnimeDetailScreenState();
}

class _AnimeDetailScreenState extends State<AnimeDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final AnimeService animeService = AnimeService();

    return FutureBuilder<DocumentSnapshot>(
      future: animeService.getAnimeById(widget.animeId),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Error: ${snapshot.error}'),
            ),
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Loading...'),
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Anime not found'),
            ),
            body: const Center(child: Text('Anime not found')),
          );
        }

        final animeData = snapshot.data!.data() as Map<String, dynamic>;
        final Anime anime = Anime.fromDocument(animeData);

        return Scaffold(
          appBar: AppBar(
            title: Text(anime.title),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.network(
                          anime.pictureUrl,
                          fit: BoxFit.cover,
                          height: 135,
                        ),
                      ),
                      const SizedBox(width: 16, height: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          Text(anime.title, style: AppTextStyles.displayMedium.copyWith(
                            fontSize: 20,
                          )),
                          const SizedBox(height: 8),
                          Text('${anime.type} - ${anime.status}', style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.onLightBackgroundColor,
                          )),
                          const SizedBox(height: 4),
                          Text('${anime.season} - ${anime.year}', style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.onLightBackgroundColor,
                          )),
                          const SizedBox(height: 4),
                          Text('Episodes: ${anime.episodes}', style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.onLightBackgroundColor,
                          )),
                        ],
                      ),

                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                      anime.synopsis,
                      style: AppTextStyles.bodyMedium,
                      textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: anime.tags.map((tag) => Chip(
                      label: Text(tag),
                      backgroundColor: AppColors.lightSurfaceBackgroundColor,
                    )).toList(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}