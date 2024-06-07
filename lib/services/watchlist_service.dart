import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:anima_list/services/user_service.dart';
import 'package:flutter/foundation.dart';

import '../enum/list_status_enum.dart';

class WatchlistService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final UserService _userService = UserService();
  final CollectionReference watchlistCollection = FirebaseFirestore.instance.collection('watchlist');
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
  final CollectionReference animeCollection = FirebaseFirestore.instance.collection('anime');

  Stream<QuerySnapshot> getUserWatchlist(String userId) {
    return userCollection.doc(userId).collection('watchlist').snapshots();
  }

  Stream<List<Map<String, dynamic>>> getAnimeFromWatchlistStream(String userId) {
    return _db.collection('users')
        .doc(userId)
        .collection('watchlist')
        .orderBy('updatedAt', descending: true)
        .snapshots().asyncMap((watchlistSnapshot) async {
      List<DocumentSnapshot> watchlistDocs = watchlistSnapshot.docs;

      List<Map<String, dynamic>> watchlistAndAnimeData = [];

      for (var doc in watchlistDocs) {
        String animeId = doc['animeId'];
        DocumentSnapshot animeSnapshot = await _db.collection('anime').doc(animeId).get();

        if (animeSnapshot.exists) {
          Map<String, dynamic> animeData = animeSnapshot.data() as Map<String, dynamic>;
          Map<String, dynamic> watchlistItemData = doc.data() as Map<String, dynamic>;

          Timestamp updatedAt = watchlistItemData['updatedAt'] ?? Timestamp.now();

          watchlistAndAnimeData.add({
            'watchlistItem': {
              ...watchlistItemData,
              'updatedAt': updatedAt,
            },
            'animeData': animeData,
            'documentId': doc.id,
          });
        } else {
          print('Anime document with id $animeId does not exist');
        }
      }

      return watchlistAndAnimeData;
    });
  }


  Future<void> updateWatchlistItem(String userId, String documentId, ListStatus listStatus, int rating, int watchedEpisodes) async {
    try {
      CollectionReference watchlistCollection = userCollection.doc(userId).collection('watchlist');
      DocumentSnapshot watchlistItemSnapshot = await watchlistCollection.doc(documentId).get();

      if (watchlistItemSnapshot.exists) {
        await watchlistCollection.doc(documentId).update({
          'listStatus': listStatus.toFirestoreString(),
          'rating': rating,
          'watchedEpisodes': watchedEpisodes,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      } else {
        await watchlistCollection.doc(documentId).set({
          'animeId': documentId,
          'listStatus': listStatus.toFirestoreString(),
          'rating': rating,
          'watchedEpisodes': watchedEpisodes,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print('Error updating watchlist item: $e');
    }
  }
}
