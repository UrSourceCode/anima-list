// services/anime_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:AnimaList/enum/list_status_enum.dart';

class AnimeService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final CollectionReference animeCollection = FirebaseFirestore.instance.collection('anime');

  Stream<QuerySnapshot> getAllAnime() {
    return animeCollection.orderBy('updatedAt', descending: true).snapshots();
  }

  Stream<QuerySnapshot> getPopularAnime() {
    return animeCollection
        .where(FieldPath.documentId, whereIn: ['U67mvv5MS77kRWmk6Z1i', 'acnW4zHU1TeC2ZcwVeY0', 'kHdRXJ2retRiyMmKy3s9'])
        .snapshots();
  }


  Stream<QuerySnapshot> getAllOngoingAnime() {
    return animeCollection.where('status', isEqualTo: 'ONGOING').snapshots();
  }

  Future<DocumentSnapshot> getAnimeById(String animeId) async {
    return await _db.collection('anime').doc(animeId).get();
  }

  Stream<List<Map<String, dynamic>>> streamAllAnime() {
    return _db.collection('anime')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
      final data = doc.data();
      data['animeId'] = doc.id;
      return data;
    }).toList());
  }

  Stream<List<Map<String, dynamic>>> getReviewsForAnime(String animeId) {
    return _db.collection('anime')
        .doc(animeId)
        .collection('reviews')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
      final data = doc.data();
      data['reviewId'] = doc.id;
      return data;
    }).toList());
  }
}
