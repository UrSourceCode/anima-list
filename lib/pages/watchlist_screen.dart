import 'package:flutter/material.dart';

class WatchlistScreen extends StatefulWidget {
  const WatchlistScreen({super.key});

  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // SizedBox(height: 60),

                  Text(
                    'Watchlist Page',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.red.shade900,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  )
                ]
            ),
          )
      )
    );
  }
}
