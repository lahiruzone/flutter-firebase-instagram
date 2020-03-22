import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_instagram/models/user_data.dart';
import 'package:flutter_firebase_instagram/screens/feed_screen.dart';
import 'package:flutter_firebase_instagram/screens/home_screen.dart';
import 'package:flutter_firebase_instagram/screens/login_screen.dart';
import 'package:flutter_firebase_instagram/screens/signup_scree.dart';
import 'package:provider/provider.dart';

void main() => runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (_) => UserData())],
    child: MyApp()));

class MyApp extends StatelessWidget {
  _screenMaping() {
    return StreamBuilder<FirebaseUser>(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            Provider.of<UserData>(context).currentUserId = snapshot.data.uid;
            return HomeScreen();
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
      theme: ThemeData(
        primaryIconTheme:
            Theme.of(context).primaryIconTheme.copyWith(color: Colors.black),
      ),
      routes: {
        LoginScreen.id: (context) => LoginScreen(),
        SignupScreen.id: (context) => SignupScreen(),
        FeedScreen.id: (context) => FeedScreen(),
      },
    );
  }
}
