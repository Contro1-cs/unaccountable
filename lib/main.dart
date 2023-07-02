import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:unaccountable/home/home.dart';
import 'package:unaccountable/landing_page.dart';

bool _userSignedIn = false;
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    if (user == null) {
      _userSignedIn = true;
    } else {
      _userSignedIn = false;
    }
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: _userSignedIn ? const HomePage() : const LandingPage(),
    );
  }
}
