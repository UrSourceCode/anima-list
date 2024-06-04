import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../components/anime_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CollectionReference animeCollection =
  FirebaseFirestore.instance.collection('anime');

  final String myUserEmail = "elsherviana@gmail.com";
  List<Map<String, dynamic>> _watchlist = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchWatchlist();
  }

  Future<void> _fetchWatchlist() async {
    try {
      QuerySnapshot userQuerySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: myUserEmail)
          .get();

      if (userQuerySnapshot.docs.isNotEmpty) {
        final userDocument =
        userQuerySnapshot.docs.first.data() as Map<String, dynamic>;
        final List<dynamic> watchlistData = userDocument['watchlist'] ?? [];

        List<Map<String, dynamic>> watchlist = watchlistData.map((item) {
          return Map<String, dynamic>.from(item as Map);
        }).toList();

        setState(() {
          _watchlist = watchlist;
          _isLoading = false;
        });
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
                  'Home Page',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.red.shade900,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: animeCollection.snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final data = snapshot.requireData.docs;

                      Map<String, List<QueryDocumentSnapshot>> categorizedData = {};
                      for (var doc in data) {
                        String type = doc['type'];
                        if (!categorizedData.containsKey(type)) {
                          categorizedData[type] = [];
                        }
                        categorizedData[type]!.add(doc);
                      }

                      List<Widget> categoryWidgets = [];
                      categorizedData.forEach((type, animeList) {
                        categoryWidgets.add(
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              type,
                              style: TextStyle(
                                color: Colors.red.shade900,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );

                        categoryWidgets.add(
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, //  Three columns
                              childAspectRatio: 0.67, // Adjusted for better layout
                              crossAxisSpacing: 8.0,
                              mainAxisSpacing: 8.0,
                            ),
                            itemCount: animeList.length,
                            itemBuilder: (context, index) {
                              var anime = animeList[index];
                              var animeID = anime.id;
                              var animeSeason = anime['animeSeason'] as Map<String, dynamic>;
                              var data = anime.data() as Map<String, dynamic>?;
                              String synopsis = data?.containsKey('synopsis') ?? false ? data!['synopsis'] : 'No synopsis provided';
                              final isOnWatchlist = _watchlist.any((item) => item['animeID'] == animeID);

                              return AnimeCard(
                                pictureUrl: anime['picture'],
                                title: anime['title'],
                                type: anime['type'],
                                status: anime['status'],
                                season: animeSeason['season'],
                                year: animeSeason['year'].toString(),
                                synopsis: synopsis,
                                isOnWatchlist: isOnWatchlist,
                                animeID: animeID,
                                fetchWatchlist: _fetchWatchlist
                              );
                            },
                          ),
                        );
                      });

                      return ListView(
                        children: categoryWidgets,
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
