// anime_detail_page.dart
import 'package:flutter/material.dart';

class AnimeDetailPage extends StatefulWidget {
  final String pictureUrl;
  final String title;
  final String type;
  final String status;
  final String season;
  final String year;
  final String synopsis;

  const AnimeDetailPage({
    required this.pictureUrl,
    required this.title,
    required this.type,
    required this.status,
    required this.season,
    required this.year,
    required this.synopsis,
    Key? key,
  }) : super(key: key);

  @override
  _AnimeDetailPageState createState() => _AnimeDetailPageState();
}

class _AnimeDetailPageState extends State<AnimeDetailPage> {
  bool showFullSynopsis = false;


  @override
  Widget build(BuildContext context) {
    bool hasSynopsis = widget.synopsis.isNotEmpty && widget.synopsis != 'No synopsis provided';
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
