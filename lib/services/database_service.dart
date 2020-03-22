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

  static void createPost(Post post){
    postRef.document(post.authorId).collection('usersPost').add({
      'imageUrl':post.imageUrl,
      'caption':post.caption,
      'likes': post.likes,
      'authorId':post.authorId,
      'timeStamp' : post.timestamp,
    });
  }


  static Future<QuerySnapshot> searchUsers(String name) {
    Future<QuerySnapshot> users =
        userRef.where('name', isGreaterThanOrEqualTo: name).getDocuments();
    return users;
  }
}
