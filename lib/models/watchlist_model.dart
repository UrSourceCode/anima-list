import 'package:cloud_firestore/cloud_firestore.dart';

class WatchlistItem {
  final String animeId;
  final int rating;
  final String listStatus;
  final Timestamp createdAt;
  final Timestamp updatedAt;
  final int watchedEpisodes;


  WatchlistItem({
    required this.animeId,
    required this.rating,
    required this.listStatus,
    required this.createdAt,
    required this.updatedAt,
    required this.watchedEpisodes,
  });

  factory WatchlistItem.fromDocument(Map<String, dynamic> doc) {
    return WatchlistItem(
      animeId: doc['animeId'] ?? '',
      listStatus: doc['listStatus'] ?? '',
      rating: doc['rating'] ?? 0,
      watchedEpisodes: doc['watchedEpisodes'] ?? 0,
      updatedAt: doc['updatedAt'] ?? Timestamp.now(),
      createdAt: doc['createdAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'animeId': animeId,
      'listStatus': listStatus,
      'rating': rating,
      'watchedEpisodes': watchedEpisodes,
      'updatedAt': updatedAt,
    };
  }
}

// Path: lib/models/watchlist_model.dart