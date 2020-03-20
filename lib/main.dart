import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_instagram/screens/feed_screen.dart';
import 'package:flutter_firebase_instagram/screens/login_screen.dart';
import 'package:flutter_firebase_instagram/screens/signup_scree.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  _screenMaping() {
    return StreamBuilder<FirebaseUser>(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return FeedScreen();
          } else {
            return LoginScreen();
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: _screenMaping(),
      routes: {
        LoginScreen.id: (context) => LoginScreen(),
        SignupScreen.id: (context) => SignupScreen(),
        FeedScreen.id: (context) => FeedScreen(),
      },
    );
  }
}
