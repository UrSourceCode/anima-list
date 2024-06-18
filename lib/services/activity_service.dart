import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class ActivityService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Map<String, dynamic>>> getUserActivityStream(String userId) {
    // Stream for reviews inside anime collection
    final reviewsStream = _db.collectionGroup('reviews')
        .where(FieldPath.documentId, isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      print('Fetched reviews');
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['documentId'] = doc.id;
        return data;
      }).toList();
    }).handleError((error) {
      print('Error fetching reviews: $error');
    });

    // Stream for threads collection
    final threadsStream = _db.collection('threads')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      print('Fetched threads');
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['documentId'] = doc.id;
        return data;
      }).toList();
    }).handleError((error) {
      print('Error fetching threads: $error');
    });

    // Stream for replies inside the threads collection
    final repliesStream = _db.collectionGroup('replies')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      print('Fetched replies');
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['documentId'] = doc.id;
        return data;
      }).toList();
    }).handleError((error) {
      print('Error fetching replies: $error');
    });

    // Stream for likes inside the threads collection
    final likesStream = _db.collectionGroup('likes')
        .where(FieldPath.documentId, isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      print('Fetched likes');
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['documentId'] = doc.id;
        return data;
      }).toList();
    }).handleError((error) {
      print('Error fetching likes: $error');
    });

    // Stream for watchlist inside the users collection
    final watchlistStream = _db.collection('users')
        .doc(userId)
        .collection('watchlist')
        .snapshots()
        .map((snapshot) {
      print('Fetched watchlist');
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['documentId'] = doc.id;
        return data;
      }).toList();
    }).handleError((error) {
      print('Error fetching watchlist: $error');
    });

    // Combine the streams and sort by updatedAt
    return Rx.combineLatest5(
      reviewsStream,
      threadsStream,
      repliesStream,
      likesStream,
      watchlistStream,
          (List<Map<String, dynamic>> reviews,
          List<Map<String, dynamic>> threads,
          List<Map<String, dynamic>> replies,
          List<Map<String, dynamic>> likes,
          List<Map<String, dynamic>> watchlist) {
        final List<Map<String, dynamic>> activities = [
          ...reviews,
          ...threads,
          ...replies,
          ...likes,
          ...watchlist,
        ];

        print('Combined activities');
        activities.sort((a, b) => (b['updatedAt'] as Timestamp).compareTo(a['updatedAt'] as Timestamp));
        return activities;
      },
    ).handleError((error) {
      print('Error combining streams: $error');
    });
  }
}
