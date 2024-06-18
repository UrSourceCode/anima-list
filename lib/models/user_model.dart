import 'package:AnimaList/models/watchlist_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  final String email;
  final String username;
  final Timestamp createdAt;
  final Timestamp updatedAt;
  final String? photoUrl;

  Users({
    required this.email,
    required this.username,
    required this.createdAt,
    required this.updatedAt,
    required this.photoUrl,
  });

  factory Users.fromDocument(Map<String, dynamic> doc) {
    String baseUrl = 'https://ui-avatars.com/api/?name=';
    String username = doc['username'];
    String avatarUrl = baseUrl + Uri.encodeComponent(username);

  return Users(
    email: doc['email'],
    username: username,
    createdAt: doc['createdAt'],
    updatedAt: doc['updatedAt'],
    photoUrl: doc['photoUrl'] ?? avatarUrl,
  );
}
}
