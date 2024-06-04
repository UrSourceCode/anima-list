// anime_card.dart
import 'package:flutter/material.dart';

import '../screens/anime_detail_screen.dart';

class AnimeCard extends StatelessWidget {
  final String pictureUrl;
  final String title;
  final String type;
  final String status;
  final String season;
  final String year;
  final String synopsis;
  final bool isOnWatchlist;
  final String animeID;
  final VoidCallback fetchWatchlist;


  const AnimeCard({
    required this.pictureUrl,
    required this.title,
    required this.type,
    required this.status,
    required this.season,
    required this.year,
    required this.synopsis,
    required this.isOnWatchlist,
    required this.animeID,
    required this.fetchWatchlist,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AnimeDetailPage(
              pictureUrl: pictureUrl,
              title: title,
              type: type,
              status: status,
              season: season,
              year: year,
              synopsis: synopsis.isNotEmpty ? synopsis : 'No synopsis provided',
              isOnWatchlist: isOnWatchlist,
              animeID: animeID,
              fetchWatchlist: fetchWatchlist,
            ),
          ),
        );
      },
      child: Card(
        color: Colors.white10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  pictureUrl,
                  height: 140.0,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),

              const Spacer(),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$type - $status',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12.0,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        '$season $year',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                  isOnWatchlist
                      ? const Icon(Icons.bookmark, color: Colors.red)
                      : const Icon(Icons.bookmark_add, color: Colors.white12),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
