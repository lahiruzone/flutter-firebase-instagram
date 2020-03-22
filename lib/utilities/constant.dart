import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

final firestore = Firestore.instance;

final userRef = firestore.collection('users');
final storageRef = FirebaseStorage.instance.ref();
final postRef = firestore.collection('posts');
