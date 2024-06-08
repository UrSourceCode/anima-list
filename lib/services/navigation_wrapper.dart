import 'package:anima_list/screens/auth/home_screen.dart';
import 'package:anima_list/screens/watchlist/watchlist_screen.dart';
import 'package:flutter/material.dart';
import 'package:anima_list/screens/community_screen.dart';
import 'package:anima_list/screens/profile_screen.dart';

class HomeScreenWrapper extends StatelessWidget {
  final Function refresh;

  const HomeScreenWrapper({required this.refresh, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        refresh();
        return true;
      },
      child: const HomeScreen(),
    );
  }
}

class CommunityScreenWrapper extends StatelessWidget {
  final Function refresh;

  const CommunityScreenWrapper({required this.refresh, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        refresh();
        return true;
      },
      child: const CommunityScreen(),
    );
  }
}

class WatchlistScreenWrapper extends StatelessWidget {
  final Function refresh;

  const WatchlistScreenWrapper({required this.refresh, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        refresh();
        return true;
      },
      child: const WatchlistScreen(),
    );
  }
}

class ProfileScreenWrapper extends StatelessWidget {
  final Function refresh;

  const ProfileScreenWrapper({required this.refresh, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        refresh();
        return true;
      },
      child: const ProfileScreen(),
    );
  }
}
