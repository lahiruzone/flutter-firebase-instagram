import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

final _firestore = Firestore.instance;

final userRef = _firestore.collection('users');
final storageRef = FirebaseStorage.instance.ref();
final postsRef = _firestore.collection('posts');
final followersRef = _firestore.collection('followers');
final followeingsRef = _firestore.collection('following');
final feedsRef = _firestore.collection('feeds');
final likesRef = _firestore.collection('likes');
final commentsRef = _firestore.collection('comments');
final activitiesRef = _firestore.collection('activities');
