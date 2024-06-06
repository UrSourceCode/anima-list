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
      animeId: doc['animeId'],
      rating: doc['rating'],
      listStatus: doc['listStatus'],
      createdAt: doc['createdAt'],
      updatedAt: doc['updatedAt'],
      watchedEpisodes: doc['watchedEpisodes'],
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'animeId': animeId,
      'rating': rating,
      'listStatus': listStatus,
      'watchedEpisodes': watchedEpisodes,
    };
  }
}

// Path: lib/models/watchlist_model.dart