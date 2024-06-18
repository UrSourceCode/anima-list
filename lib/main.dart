import 'package:AnimaList/screens/anime/anime_detail_screen.dart';
import 'package:AnimaList/screens/auth/auth_screen.dart';
import 'package:AnimaList/screens/auth/home_screen.dart';
import 'package:AnimaList/screens/community_screen.dart';
import 'package:AnimaList/screens/discover_screen.dart';
import 'package:AnimaList/screens/splash_screen.dart';
import 'package:AnimaList/screens/thread/thread_detail_screen.dart';
import 'package:AnimaList/screens/watchlist/watchlist_screen.dart';
import 'package:AnimaList/theme/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      theme: AppTheme.lightTheme,
      home: AuthScreen(),
    );
  }
}