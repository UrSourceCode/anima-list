// anime_detail_page.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../components/rating_dialog.dart';
import '../enum/list_status_enum.dart';

class AnimeDetailPage extends StatefulWidget {
  final String pictureUrl;
  final String title;
  final String type;
  final String status;
  final String season;
  final String year;
  final String synopsis;
  bool isOnWatchlist;
  final String animeID;
  final VoidCallback fetchWatchlist;

  AnimeDetailPage({
    required this.pictureUrl,
    required this.title,
    required this.type,
    required this.status,
    required this.season,
    required this.year,
    required this.synopsis,
    required this.isOnWatchlist,
    required this.animeID,
    required this.fetchWatchlist,
    Key? key,
  }) : super(key: key);

  @override
  _AnimeDetailPageState createState() => _AnimeDetailPageState();
}

class _AnimeDetailPageState extends State<AnimeDetailPage> {
  final String myUserEmail = 'elsherviana@gmail.com';

  bool showFullSynopsis = false;
  bool get hasSynopsis => widget.synopsis != 'No synopsis provided';

  void _addWatchlistToFirestore(int rating, ListStatus listStatus) async {
    try {
      final userQuerySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: myUserEmail)
          .get();

      if (userQuerySnapshot.docs.isNotEmpty) {
        final userDoc = userQuerySnapshot.docs.first;
        final userRef = FirebaseFirestore.instance.collection('users').doc(userDoc.id);

        List<Map<String, dynamic>> watchlist = List<Map<String, dynamic>>.from(userDoc['watchlist'] ?? []);

        watchlist.add({
          'animeID': widget.animeID,
          'rating': rating,
          'listStatus': listStatus.toFirestoreString(),
        });

        await userRef.update({'watchlist': watchlist});

        setState(() {
          widget.isOnWatchlist = true;
        });

        widget.fetchWatchlist();
      } else {
        print('User not found with email $myUserEmail');
      }
    } catch (error) {
      print('Error adding watchlist: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.red.shade900,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.0),
                      border: Border.all(color: Colors.black54, width: 2.0),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        widget.pictureUrl,
                        height: 180.0,
                        width: 120.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.red.shade900,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          '${widget.type} - ${widget.status}',
                          style: const TextStyle(
                            fontSize: 18.0,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          '${widget.season} ${widget.year}',
                          style: const TextStyle(
                            fontSize: 18.0,
                            color: Colors.grey,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => RatingDialog(
                                pictureUrl: widget.pictureUrl,
                                title: widget.title,
                                status: widget.status,
                                onSave: (int newRating, ListStatus newListStatus) {
                                  _addWatchlistToFirestore(newRating, newListStatus);
                                },
                              ),
                            );
                          },
                          child: widget.isOnWatchlist
                              ? const Icon(Icons.check_circle, color: Colors.green)
                              : const Icon(Icons.add_circle_outline, color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Text(
                'Synopsis',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade900,
                ),
              ),
              const SizedBox(height: 8.0),
              GestureDetector(
                onTap: () {
                  setState(() {
                    showFullSynopsis = !showFullSynopsis;
                  });
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: widget.synopsis.split('\n').expand((line) {
                          return [
                            TextSpan(
                              text: line,
                              style: const TextStyle(
                                fontSize: 16.0,
                                color: Colors.white70,
                              ),
                            ),
                            const TextSpan(
                              text: '\n',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.white70,
                              ),
                            ),
                          ];
                        }).toList(),
                      ),
                      textAlign: TextAlign.justify,
                      maxLines: showFullSynopsis ? null : 4,
                      overflow: showFullSynopsis
                          ? TextOverflow.visible
                          : TextOverflow.ellipsis,
                    ),
                    if (!showFullSynopsis && hasSynopsis)
                      Text(
                        'Read More',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.red.shade900,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
