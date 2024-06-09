import 'package:anima_list/components/watchlist/watchlist_dialog.dart';
import 'package:anima_list/models/anime_model.dart';
import 'package:anima_list/theme/colors.dart';
import 'package:anima_list/theme/text_styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:anima_list/services/anime_service.dart';
import 'package:anima_list/services/watchlist_service.dart';
import 'package:anima_list/enum/list_status_enum.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AnimeDetailScreen extends StatefulWidget {
  final String animeId;

  const AnimeDetailScreen({
    required this.animeId,
    Key? key,
  }) : super(key: key);

  @override
  State<AnimeDetailScreen> createState() => _AnimeDetailScreenState();
}

class _AnimeDetailScreenState extends State<AnimeDetailScreen> {
  final WatchlistService watchlistService = WatchlistService();
  Anime? anime;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAnimeDetails();
  }

  Future<void> _fetchAnimeDetails() async {
    final AnimeService animeService = AnimeService();
    DocumentSnapshot animeDoc = await animeService.getAnimeById(widget.animeId);
    setState(() {
      anime = Anime.fromDocument(animeDoc.data() as Map<String, dynamic>);
      isLoading = false;
    });
  }

  void _showWatchlistDialog(bool isOnWatchlist) async {
    if (isOnWatchlist) {
      DocumentSnapshot watchlistItem = await watchlistService.getWatchlistStream(
        FirebaseAuth.instance.currentUser!.uid,
        widget.animeId,
      ).first;
      int initialRating = watchlistItem['rating'];
      int initialWatchedEpisodes = watchlistItem['watchedEpisodes'];
      ListStatus initialListStatus = ListStatusExtension.fromString(watchlistItem['listStatus']);

      _openWatchlistDialog(
        anime!,
        initialRating,
        initialWatchedEpisodes,
        initialListStatus,
        true,
      );
    } else {
      _openWatchlistDialog(
        anime!,
        0,
        0,
        ListStatus.planToWatch,
        false,
      );
    }
  }

  void _openWatchlistDialog(Anime anime, int initialRating, int initialWatchedEpisodes, ListStatus initialListStatus, bool isInWatchlist) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return WatchlistDialog(
          anime: anime,
          initialRating: initialRating,
          initialWatchedEpisodes: initialWatchedEpisodes,
          initialListStatus: initialListStatus,
          onSave: (newRating, newWatchedEpisodes, newListStatus) {
            if (isInWatchlist) {
              watchlistService.updateWatchlistItem(
                FirebaseAuth.instance.currentUser!.uid,
                widget.animeId,
                newListStatus,
                newRating,
                newWatchedEpisodes,
              );
            } else {
              watchlistService.addWatchlistItem(
                FirebaseAuth.instance.currentUser!.uid,
                widget.animeId,
                newListStatus,
                newRating,
                newWatchedEpisodes,
              );
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Loading...'),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (anime == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Anime not found'),
        ),
        body: const Center(child: Text('Anime not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(anime!.title),
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
                      anime!.pictureUrl,
                      fit: BoxFit.cover,
                      height: 135,
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
                  const SizedBox(width: 16, height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      Text(
                          anime!.title,
                          style: AppTextStyles.displayMedium.copyWith(
                        fontSize: 20,
                      ),
                          softWrap: true,
                          maxLines: 3
                      ),
                      const SizedBox(height: 8),
                      Text('${anime!.type} - ${anime!.status}', style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.onLightBackgroundColor,
                      )),
                      const SizedBox(height: 4),
                      Text('${anime!.season} - ${anime!.year}', style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.onLightBackgroundColor,
                      )),
                      const SizedBox(height: 4),
                      Text('Episodes: ${anime!.episodes}', style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.onLightBackgroundColor,
                      )),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                anime!.synopsis,
                style: AppTextStyles.bodyMedium,
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: anime!.tags.map((tag) => Chip(
                  label: Text(tag),
                  backgroundColor: AppColors.lightSurfaceBackgroundColor,
                )).toList(),
              ),
              const SizedBox(height: 16),
              StreamBuilder<DocumentSnapshot>(
                stream: watchlistService.getWatchlistStream(
                  FirebaseAuth.instance.currentUser!.uid,
                  widget.animeId,
                ),
                builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  bool isInWatchlist = snapshot.hasData && snapshot.data!.exists;

                  return ElevatedButton(
                    onPressed: () => _showWatchlistDialog(isInWatchlist),
                    child: Text(isInWatchlist ? 'Update Watchlist' : 'Add to Watchlist'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
