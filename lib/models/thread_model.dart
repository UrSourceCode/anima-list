class Thread {
  final String title;
  final String content;
  final String userId;

  Thread({
    required this.title,
    required this.content,
    required this.userId,
  });

  factory Thread.fromDocument(Map<String, dynamic> doc) {
    return Thread(
      title: doc['title'],
      content: doc['content'],
      userId: doc['userId'],
    );
  }
}

class Reply {
  final String reply;
  final String userId;

  Reply({
    required this.reply,
    required this.userId,
  });

  factory Reply.fromDocument(Map<String, dynamic> doc) {
    return Reply(
      reply: doc['reply'],
      userId: doc['userId'],
    );
  }
}