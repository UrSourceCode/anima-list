// anime_card.dart
import 'package:flutter/material.dart';

class AnimeCard extends StatelessWidget {
  final String pictureUrl;
  final String title;
  final String type;
  final String status;

  const AnimeCard({
    required this.pictureUrl,
    required this.title,
    required this.type,
    required this.status,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black54,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                pictureUrl,
                height: 90.0,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              '$type - $status',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
