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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: SafeArea(
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
                            crossAxisCount: 3, // Three columns
                            childAspectRatio: 0.6, // Adjusted for better layout
                            crossAxisSpacing: 8.0,
                            mainAxisSpacing: 8.0,
                          ),
                          itemCount: animeList.length,
                          itemBuilder: (context, index) {
                            var anime = animeList[index];
                            return AnimeCard(
                              pictureUrl: anime['picture'],
                              title: anime['title'],
                              type: anime['type'],
                              status: anime['status'],
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
    );
  }
}
