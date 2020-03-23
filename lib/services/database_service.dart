import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_instagram/models/post_model.dart';
import 'package:flutter_firebase_instagram/models/user_model.dart';
import 'package:flutter_firebase_instagram/utilities/constant.dart';

class DatabaseService {
  static void updateUser(User user) async {
    userRef.document(user.id).updateData({
      'name': user.name,
      'bio': user.bio,
      'profileImageUrl': user.profileImageUrl,
    });
  }

  static void createPost(Post post) {
    postRef.document(post.authorId).collection('usersPost').add({
      'imageUrl': post.imageUrl,
      'caption': post.caption,
      'likes': post.likes,
      'authorId': post.authorId,
      'timeStamp': post.timestamp,
    });
  }

  static Future<QuerySnapshot> searchUsers(String name) {
    Future<QuerySnapshot> users =
        userRef.where('name', isGreaterThanOrEqualTo: name).getDocuments();
    return users;
  }

  static void followUser(String currentUserId, String userId) {
    print('Callin >>>>>>>>>>>>>>>>>>>>>>>>> Flw');
    // Add user to current users following collection
    followeingsRef
        .document(currentUserId)
        .collection('userFollowing')
        .document(userId)
        .setData({});

    //Add current users to users followes collection
    followersRef
        .document(userId)
        .collection('userFollowers')
        .document(currentUserId)
        .setData({});

    print('Callin >>>>>>>>>>>>>>>>>>>>>>>>> Flw222');
  }

  static void unFollowUser(String currentUserId, String userId) {
    print('Callin >>>>>>>>>>>>>>>>>>>>>>>>> UnFlw');
    // Remove user to current users following collection
    followeingsRef
        .document(currentUserId)
        .collection('userFollowing')
        .document(userId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });

    //Remove current users to users followes collection
    followersRef
        .document(userId)
        .collection('userFollowers')
        .document(currentUserId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  static Future<bool> isFollowingUser(
      {String currentUserId, String userId}) async {
    DocumentSnapshot followingDoc = await followersRef
        .document(userId)
        .collection('userFollowers')
        .document(currentUserId)
        .get();
    return followingDoc.exists;
  }

  static Future<int> numFollowers(String userId) async {
    QuerySnapshot followingSnapshot = await followersRef
        .document(userId)
        .collection('userFollowers')
        .getDocuments();
    print('>>>>>>>>>>>>>>>>>>>>>>>>>');
    print(followingSnapshot.documents.length);

    return followingSnapshot.documents.length;
  }

  static Future<int> numFollowing(String userId) async {
    QuerySnapshot followingSnapshot = await followeingsRef
        .document(userId)
        .collection('userFollowing')
        .getDocuments();
    print('>>>>>>>>>>>>>>>>>>>>>>>>>$followingSnapshot.documents.length');
    return followingSnapshot.documents.length;
  }
}
