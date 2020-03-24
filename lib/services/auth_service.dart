import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_instagram/models/user_data.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

class AuthService {
  static final _auth = FirebaseAuth.instance;
  static final _firestore = Firestore.instance;

  static Future<void> signUpUser(
      BuildContext context, String name, String email, String password) async {
    try {
      AuthResult authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser signedUser = authResult.user;
      if (signedUser != null) {
        _firestore.collection('/users').document(signedUser.uid).setData({
          'name': name,
          'email': email,
          'profileImageUrl': '',
        });
        Provider.of<UserData>(context, listen: false).currentUserId =
            signedUser.uid;
        Navigator.pop(context);
      }
    } on PlatformException catch (err) {
      throw (err);
    }
  }

  static Future<void> login(
      BuildContext context, String email, String password) async {
    try {
      AuthResult authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = authResult.user;
      if (user != null) {}
    } on PlatformException catch (err) {
      throw (err);
    }
  }

  static void signOut() {
    _auth.signOut();
  }
}
