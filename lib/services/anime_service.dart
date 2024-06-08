// services/anime_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:anima_list/enum/list_status_enum.dart';

class AnimeService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final CollectionReference animeCollection = FirebaseFirestore.instance.collection('anime');

  Stream<QuerySnapshot> getAllAnime() {
    return animeCollection.orderBy('updatedAt', descending: true).snapshots();
  }

  Future<DocumentSnapshot> getAnimeById(String animeId) async {
    return await _db.collection('anime').doc(animeId).get();
  }
}
