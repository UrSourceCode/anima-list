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

  final String uuid = "UPaGlbfhRO0wAkmHIQHF";

  Future<void> _handleRefresh() async {
    setState(() {});
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
                  child: StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(uuid)
                        .snapshots(),
                    builder: (context, userSnapshot) {
                      if (userSnapshot.hasError) {
                        return Center(child: Text('Error: ${userSnapshot.error}'));
                      }

                      if (userSnapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final userData = userSnapshot.data!.data() as Map<String, dynamic>?;
                      final List<dynamic> watchlistData = userData?['watchlist'] ?? [];

                      List<Map<String, dynamic>> watchlist = watchlistData.map((item) {
                        return Map<String, dynamic>.from(item as Map);
                      }).toList();

                      return StreamBuilder<QuerySnapshot>(
                        stream: animeCollection.snapshots(),
                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> animeSnapshot) {
                          if (animeSnapshot.hasError) {
                            return Center(child: Text('Error: ${animeSnapshot.error}'));
                          }

                          if (animeSnapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }

                          final data = animeSnapshot.requireData.docs;

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
                                  crossAxisCount: 2, // Two columns
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
                                  final isOnWatchlist = watchlist.any((item) {
                                    return item['animeID'] == animeID;
                                  });

                                  //print(data);

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
                                    fetchWatchlist: _handleRefresh,
                                  );
                                },
                              ),
                            );
                          });

                          return ListView(
                            children: categoryWidgets,
                          );
                        },
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
