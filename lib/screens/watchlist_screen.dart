import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:anima_list/enum/list_status_enum.dart';

import '../components/rating_dialog.dart';

class WatchlistScreen extends StatefulWidget {
  const WatchlistScreen({Key? key}) : super(key: key);

  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  final String myUserEmail = "elsherviana@gmail.com";
  List<Map<String, dynamic>> _watchlist = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchWatchlist();
  }

  Future<void> _fetchWatchlist() async {
    setState(() {
      _isLoading = true;
    });

    try {
      QuerySnapshot userQuerySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: myUserEmail)
          .get();

      if (userQuerySnapshot.docs.isNotEmpty) {
        final userDocument = userQuerySnapshot.docs.first.data() as Map<String, dynamic>;
        final List<dynamic> watchlistData = userDocument['watchlist'] ?? [];

        List<Map<String, dynamic>> watchlist = watchlistData.map((item) {
          return Map<String, dynamic>.from(item as Map);
        }).toList();

        _fetchAnimeData(watchlist);
        print('Watchlist Data: $watchlistData');
      } else {
        print('User not found with email $myUserEmail');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (error) {
      print('Error fetching user: $error');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _deleteItemFromWatchlist(String animeID) async {
    try {
      DocumentSnapshot userDocumentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: myUserEmail)
          .get()
          .then((querySnapshot) => querySnapshot.docs.first);

      List<dynamic> watchlist = userDocumentSnapshot['watchlist'];

      int indexToDelete = watchlist.indexWhere((item) => item['animeID'] == animeID);

      if (indexToDelete != -1) {
        watchlist.removeAt(indexToDelete);

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userDocumentSnapshot.id)
            .update({'watchlist': watchlist});

        // Fetch the updated watchlist
        _fetchWatchlist();
      } else {
        print('Item with animeID $animeID not found in watchlist.');
      }
    } catch (error) {
      print('Error deleting item from watchlist: $error');
    }
  }

  Future<void> _fetchAnimeData(List<Map<String, dynamic>> watchlist) async {
    List<Map<String, dynamic>> fetchedAnimeData = [];

    for (var item in watchlist) {
      String animeID = item['animeID'];
      try {
        DocumentSnapshot animeDocSnapshot = await FirebaseFirestore.instance
            .collection('anime')
            .doc(animeID)
            .get();

        if (animeDocSnapshot.exists) {
          final animeData = animeDocSnapshot.data() as Map<String, dynamic>;
          fetchedAnimeData.add({
            'animeID': animeID,
            'rating': item['rating'],
            'title': animeData['title'],
            'pictureUrl': animeData['picture'],
            'status': animeData['status'],
            'listStatus': ListStatusExtension.fromString(item['listStatus']),
          });
        }
      } catch (error) {
        print('Error fetching anime with ID $animeID: $error');
      }
    }

    setState(() {
      _watchlist = fetchedAnimeData;
      _isLoading = false;
    });
  }

  void _saveRatingToFirebase(String animeID, int newRating, ListStatus newListStatus, VoidCallback onComplete) async {
    try {
      QuerySnapshot userQuerySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: myUserEmail)
          .get();

      if (userQuerySnapshot.docs.isNotEmpty) {
        final userDocument = userQuerySnapshot.docs.first;
        List<dynamic> watchlist = List.from(userDocument['watchlist']);

        for (var item in watchlist) {
          if (item['animeID'] == animeID) {
            item['rating'] = newRating;
            item['listStatus'] = newListStatus.toFirestoreString();
            break;
          }
        }

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userDocument.id)
            .update({'watchlist': watchlist});

        onComplete();
      }
    } catch (error) {
      print('Error saving rating: $error');
    }
  }

  Future<void> _handleRefresh() async {
    await _fetchWatchlist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Watchlist',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.red.shade900,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _watchlist.isEmpty
                      ? const Center(child: Text(
                      'Watchlist is empty',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                  ))
                      : ListView.builder(
                    itemCount: _watchlist.length,
                    itemBuilder: (context, index) {
                      final item = _watchlist[index];
                      return GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return RatingDialog(
                                onSave: (newRating, newListStatus) {
                                  _saveRatingToFirebase(item['animeID'], newRating, newListStatus, () {
                                    _fetchWatchlist();
                                  });
                                },
                                pictureUrl: item['pictureUrl'],
                                title: item['title'],
                                status: item['status'],
                                initialRating: item['rating'],
                                initialListStatus: item['listStatus'],
                              );
                            },
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white12,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(8.0),
                              leading: item['pictureUrl'] != null
                                  ? Image.network(
                                item['pictureUrl'],
                                fit: BoxFit.cover,
                              )
                                  : null,
                              title: Text(
                                '${item['title']}',
                                style: TextStyle(
                                  color: Colors.red.shade900,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 6.0),
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      const TextSpan(
                                        text: 'Status: ',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                      TextSpan(
                                        text: (item['listStatus'] as ListStatus).toReadableString(),
                                        style: TextStyle(
                                          color: Colors.red.shade900,
                                          fontSize: 12,
                                        ),
                                      ),
                                      const TextSpan(
                                        text: '\nRating: ',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                      TextSpan(
                                        text: item['status'] == 'UPCOMING' || item['rating'] == null ? 'N/A' : '${item['rating']}',
                                        style: TextStyle(
                                          color: Colors.red.shade900,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                color: Colors.white38,
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Confirm Deletion'),
                                        content: RichText(
                                          text: TextSpan(
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 14.0,
                                            ),
                                            children: [
                                              const TextSpan(
                                                text: 'Are you sure you want to delete ',
                                              ),
                                              TextSpan(
                                                text: '${item['title']}',
                                                style: const TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const TextSpan(
                                                text: ' from your watchlist?',
                                              ),
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop(); // Close the dialog
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              _deleteItemFromWatchlist(item['animeID']);
                                              Navigator.of(context).pop(); // Close the dialog
                                            },
                                            child: const Text(
                                              'Delete',
                                              style: TextStyle(color: Colors.red),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
