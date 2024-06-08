import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_model.dart';

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<DocumentSnapshot?> getUserByEmail(String email) async {
    QuerySnapshot userQuerySnapshot = await _db
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    if (userQuerySnapshot.docs.isNotEmpty) {
      return userQuerySnapshot.docs.first;
    }
    return null;
  }

  Future<DocumentSnapshot> getUserByUuid(String uid) async {
    DocumentSnapshot userDocSnapshot = await _db.collection('users').doc(uid).get();

    if (userDocSnapshot.exists) {
      return userDocSnapshot;
    }
    throw Exception('User not found with uid $uid');
  }

  Future<void> addUserToCollection(Users user, String uid) async {
    try {
      await _db.collection('users').doc(uid).set({
        'email': user.email,
        'username': user.username,
        'createdAt': user.createdAt,
        'updatedAt': user.updatedAt,
      });
    } catch (e) {
      throw Exception('Error adding user to collection: $e');
    }
  }
}

// services/anime_service.dart
