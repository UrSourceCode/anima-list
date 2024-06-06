class Anime {
  final String pictureUrl;
  final String title;
  final String type;
  final String status;
  final String season;
  final String year;
  final String synopsis;
  final int episodes;
  final List<String> tags;

  Anime({
    required this.pictureUrl,
    required this.title,
    required this.type,
    required this.status,
    required this.season,
    required this.year,
    required this.synopsis,
    required this.episodes,
    required this.tags,

  });

  factory Anime.fromDocument(Map<String, dynamic> doc) {
    var animeSeason = doc['animeSeason'] as Map<String, dynamic>;
    return Anime(
      pictureUrl: doc['picture'],
      title: doc['title'],
      episodes: doc['episodes'],
      type: doc['type'],
      status: doc['status'],
      season: animeSeason['season'],
      year: animeSeason['year'].toString(),
      synopsis: doc.containsKey('synopsis') ? doc['synopsis'] : 'No synopsis provided',
      tags: List<String>.from(doc['tags']),
    );
  }
}
// Path: lib/models/anime_list_model.dart