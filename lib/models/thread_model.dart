import 'package:cloud_firestore/cloud_firestore.dart';

class Thread {
  final String title;
  final String content;
  final String userId;
  final int likeCounter;
  final Timestamp createdAt;
  final Timestamp updatedAt;

  Thread({
    required this.title,
    required this.content,
    required this.userId,
    required this.likeCounter,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Thread.fromDocument(Map<String, dynamic> doc) {
    return Thread(
      title: doc['title'],
      content: doc['content'],
      userId: doc['userId'],
      likeCounter: doc['likeCounter'],
      createdAt: doc['createdAt'],
      updatedAt: doc['updatedAt'],
    );
  }
}

class Reply {
  final String reply;
  final String userId;
  final Timestamp createdAt;
  final Timestamp updatedAt;

  Reply({
    required this.reply,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Reply.fromDocument(Map<String, dynamic> doc) {
    return Reply(
      reply: doc['reply'],
      userId: doc['userId'],
      createdAt: doc['createdAt'],
      updatedAt: doc['updatedAt'],
    );
  }
}