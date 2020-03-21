import 'package:cloud_firestore/cloud_firestore.dart';

final firestore = Firestore.instance;

final userRef = firestore.collection('users');