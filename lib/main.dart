import 'package:anima_list/screens/auth/auth_screen.dart';
import 'package:anima_list/screens/auth/login_or_register_screen.dart';
import 'package:anima_list/screens/auth/register_screen.dart';
import 'package:anima_list/screens/old_home_screen.dart';
import 'package:anima_list/screens/auth/login_screen.dart';
import 'package:anima_list/screens/old_watchlist_screen.dart';
import 'package:anima_list/screens/startup_screen.dart';
import 'package:anima_list/theme/theme.dart';
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
      home: const AuthScreen(),
    );
  }
}