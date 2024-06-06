import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ThreadService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final CollectionReference threadCollection = FirebaseFirestore.instance.collection('threads');

  Future<QuerySnapshot> getAllThreads() async {
    return threadCollection.get();
  }

  Future<Map<String, dynamic>> getThreadAndAuthorData(String threadId) async {
    try {
      DocumentSnapshot threadSnapshot = await _db.collection('threads').doc(threadId).get();
      Map<String, dynamic> threadData = threadSnapshot.data() as Map<String, dynamic>;

      String userId = threadData['userId'];
      DocumentSnapshot userSnapshot = await _db.collection('users').doc(userId).get();
      Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;

      return {
        'threadData': threadData,
        'userData': userData,
      };
    } catch (e) {
      print(e);
      return {'error': 'Error fetching thread and user data'};
    }
  }
}