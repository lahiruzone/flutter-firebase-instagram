import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

final firestore = Firestore.instance;

final userRef = firestore.collection('users');
final storageRef = FirebaseStorage.instance.ref();
final postsRef = firestore.collection('posts');
final followersRef = firestore.collection('followers');
final followeingsRef = firestore.collection('following');
final feedsRef = firestore.collection('feeds');
final likesRef = firestore.collection('likes');
