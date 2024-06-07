// services/anime_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:anima_list/enum/list_status_enum.dart';

class AnimeService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final CollectionReference animeCollection = FirebaseFirestore.instance.collection('anime');

  Stream<QuerySnapshot> getAllAnime() {
    return animeCollection.orderBy('updatedAt', descending: true).snapshots();
  }

  Future<DocumentSnapshot> getAnimeById(String animeID) async {
    return await _db.collection('anime').doc(animeID).get();
  }

  Future<List<Map<String, dynamic>>> fetchAnimeData(List<Map<String, dynamic>> watchlist) async {
    List<Map<String, dynamic>> fetchedAnimeData = [];

    for (var item in watchlist) {
      String animeID = item['animeID'];
      try {
        DocumentSnapshot animeDocSnapshot = await getAnimeById(animeID);

        if (animeDocSnapshot.exists) {
          final animeData = animeDocSnapshot.data() as Map<String, dynamic>;
          fetchedAnimeData.add({
            'animeID': animeID,
            'rating': item['rating'],
            'title': animeData['title'],
            'pictureUrl': animeData['picture'],
            'status': animeData['status'],
            'listStatus': ListStatusExtension.fromString(item['listStatus']),
          });
        }
      } catch (error) {
        print('Error fetching anime with ID $animeID: $error');
      }
    }

    return fetchedAnimeData;
  }
}
