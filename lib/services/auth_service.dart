import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_instagram/screens/feed_screen.dart';
import 'package:flutter_firebase_instagram/screens/login_screen.dart';

class AuthService {
  static final _auth = FirebaseAuth.instance;
  static final _firestore = Firestore.instance;

  static void signUpUser(
      BuildContext context, String name, String email, String password) async {
    try {
      AuthResult authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser signedUser = authResult.user;
      if (signedUser != null) {
        _firestore.collection('/user').document(signedUser.uid).setData({
          'name': name,
          'email': email,
          'profileImageUrl': '',
        });
        Navigator.pushReplacementNamed(context, FeedScreen.id);
      }
    } catch (e) {
      print(e);
    }
  }

  static void login(BuildContext context, String email, String password) async {
    try {
      AuthResult authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = authResult.user;
      if (user != null) {
        // Navigator.pushReplacementNamed(context, FeedScreen.id);
      }
    } catch (e) {
      print(e);
    }
  }

  static void signOut() {
    _auth.signOut();
    // Navigator.pushReplacementNamed(context, LoginScreen.id);
  }
}
