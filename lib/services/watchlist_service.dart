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
  // Future<void> updateUserWatchlist(String userId, List<Map<String, dynamic>> watchlist) async {
  //   await _db.collection('users').doc(userId).update({'watchlist': watchlist});
  // }

  // Get watchlist collection inside the user document

  Future<QuerySnapshot> getUserWatchlist(String userId) async {
    return userCollection.doc(userId).collection('watchlist').get();
  }

  Future<List<Map<String, dynamic>>> getAnimeFromWatchlistData(String userId) async {
    try {
      QuerySnapshot watchlistSnapshot = await userCollection.doc(userId).collection('watchlist').get();
      List<DocumentSnapshot> watchlistDocs = watchlistSnapshot.docs;

      List<Map<String, dynamic>> watchlistAndAnimeData = [];

      for (var doc in watchlistDocs) {
        String animeId = doc['animeId'];
        DocumentSnapshot animeSnapshot = await _db.collection('anime').doc(animeId).get();

        if (animeSnapshot.exists) {
          Map<String, dynamic> animeData = animeSnapshot.data() as Map<String, dynamic>;
          watchlistAndAnimeData.add({
            'watchlistItem': doc.data(),
            'animeData': animeData,
          });
        } else {
          print('Anime document with id $animeId does not exist');
        }
      }

      print(watchlistAndAnimeData);

      return watchlistAndAnimeData;
    } catch (e) {
      print(e);
      return [];
    }
  }
  // Future<List<Map<String, dynamic>>> fetchWatchlist(String email) async {
  //   final userDoc = await _userService.getUserByEmail(email);
  //   if (userDoc != null) {
  //     final List<dynamic> watchlistData = userDoc['watchlist'] ?? [];
  //     return watchlistData.map((item) {
  //       return Map<String, dynamic>.from(item as Map);
  //     }).toList();
  //   } else {
  //     print('User not found with email $email');
  //     return [];
  //   }
  // }
  //
  // Future<void> deleteItemFromWatchlist(String email, String animeID) async {
  //   try {
  //     final userDoc = await _userService.getUserByEmail(email);
  //     if (userDoc != null) {
  //       List<Map<String, dynamic>> watchlist = List<Map<String, dynamic>>.from(userDoc['watchlist']);
  //
  //       int indexToDelete = watchlist.indexWhere((item) => item['animeID'] == animeID);
  //       if (indexToDelete != -1) {
  //         watchlist.removeAt(indexToDelete);
  //
  //         await updateUserWatchlist(userDoc.id, watchlist);
  //       } else {
  //         print('Item with animeID $animeID not found in watchlist.');
  //       }
  //     }
  //   } catch (error) {
  //     print('Error deleting item from watchlist: $error');
  //   }
  // }
  //
  // Future<void> saveRatingToFirestore(String email, String animeID, int newRating, ListStatus newListStatus) async {
  //   try {
  //     final userDoc = await _userService.getUserByEmail(email);
  //     if (userDoc != null) {
  //       List<Map<String, dynamic>> watchlist = List<Map<String, dynamic>>.from(userDoc['watchlist']);
  //
  //       for (var item in watchlist) {
  //         if (item['animeID'] == animeID) {
  //           item['rating'] = newRating;
  //           item['listStatus'] = newListStatus.toReadableString();
  //           break;
  //         }
  //       }
  //
  //       await updateUserWatchlist(userDoc.id, watchlist);
  //     }
  //   } catch (error) {
  //     print('Error saving rating: $error');
  //   }
  // }
  //
  // Future<void> addWatchlistToFirestore(
  //     String userEmail,
  //     String animeID,
  //     int rating,
  //     ListStatus listStatus,
  //     Function(bool) onUpdateIsOnWatchlist,
  //     VoidCallback onUpdateWatchlist,
  //     Function(String) onError,
  //     ) async {
  //   onUpdateIsOnWatchlist(true);
  //   try {
  //     final userDoc = await _userService.getUserByEmail(userEmail);
  //     if (userDoc != null) {
  //       List<Map<String, dynamic>> watchlist =
  //       List<Map<String, dynamic>>.from(userDoc['watchlist'] ?? []);
  //
  //       watchlist.add({
  //         'animeID': animeID,
  //         'rating': rating,
  //         'listStatus': listStatus.toFirestoreString(),
  //       });
  //
  //       await updateUserWatchlist(userDoc.id, watchlist);
  //
  //       onUpdateWatchlist();
  //     } else {
  //       onError('User not found with email $userEmail');
  //     }
  //   } catch (error) {
  //     onError('Error adding watchlist: $error');
  //   } finally {
  //     onUpdateIsOnWatchlist(false);
  //   }
  // }
}
