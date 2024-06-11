import 'package:anima_list/models/thread_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ThreadService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final CollectionReference threadCollection = FirebaseFirestore.instance.collection('threads');

  Future<QuerySnapshot> getAllThreads() async {
    return threadCollection.get();
  }

  Future<Thread> getThread(String threadId) async {
    final threadDoc = await _db.collection('threads').doc(threadId).get();
    if (threadDoc.exists) {
      return Thread.fromDocument(threadDoc.data() as Map<String, dynamic>);
    } else {
      throw Exception("Thread not found");
    }
  }

  Stream<QuerySnapshot> getReplyStream(String threadId) {
    return threadCollection.doc(threadId).collection('replies').snapshots();
  }

  Stream<Map<String, dynamic>> getThreadAndAuthorData(String threadId) {
    return _db.collection('threads').doc(threadId).snapshots().map((threadSnapshot) {
      Map<String, dynamic> threadData = threadSnapshot.data() as Map<String, dynamic>;

      String userId = threadData['userId'];

      return _db.collection('users').doc(userId).snapshots().map((userSnapshot) {
        Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;

        return {
          'threadData': threadData,
          'userData': userData,
        };
      });
    }).asyncExpand((i) => i);
  }

  Stream<Map<String, dynamic>> getReplyAndAuthorData(String threadId, String replyId) {
    return _db.collection('threads').doc(threadId).collection('replies').doc(replyId).snapshots().map((replySnapshot) {
      Map<String, dynamic> replyData = replySnapshot.data() as Map<String, dynamic>;

      String userId = replyData['userId'];

      return _db.collection('users').doc(userId).snapshots().map((userSnapshot) {
        Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;

        return {
          'replyData': replyData,
          'userData': userData,
        };
      });
    }).asyncExpand((i) => i);
  }

  Stream<QuerySnapshot> getUpvoteStream(String threadId) {
    return threadCollection.doc(threadId).collection('likes').snapshots();
  }

  Future<bool> isLoggedInUserUpvote(String threadId) async {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;

    if (user == null) {
      return false;
    }

    final upvoteDoc = await _db.collection('threads').doc(threadId).collection('likes').doc(user.uid).get();

    return upvoteDoc.exists;
  }

  Future<void> addThreadUpvote(String threadId, String userId) async {
    final threadRef = threadCollection.doc(threadId);
    final upvoteDoc = await threadRef.collection('likes').doc(userId).get();

    if (!upvoteDoc.exists) {
      await threadRef.collection('likes').doc(userId).set({
        'likedAt': FieldValue.serverTimestamp(),
      });

      await threadRef.update({
        'likeCounter': FieldValue.increment(1),
      });
    }
  }

  Future<void> removeThreadUpvote(String threadId, String userId) async {
    final threadRef = threadCollection.doc(threadId);
    final upvoteDoc = await threadRef.collection('likes').doc(userId).get();

    if (upvoteDoc.exists) {
      await threadRef.collection('likes').doc(userId).delete();

      await threadRef.update({
        'likeCounter': FieldValue.increment(-1),
      });
    }
  }
}