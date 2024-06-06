import 'package:anima_list/models/watchlist_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  final String email;
  final String username;
  final Timestamp createdAt;
  final Timestamp updatedAt;

  Users({
    required this.email,
    required this.username,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Users.fromDocument(Map<String, dynamic> doc) {
    return Users(
      email: doc['email'],
      username: doc['username'],
      createdAt: doc['createdAt'],
      updatedAt: doc['updatedAt'],
    );
  }
}
