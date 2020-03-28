import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_instagram/models/activity_model.dart';
import 'package:flutter_firebase_instagram/models/post_model.dart';
import 'package:flutter_firebase_instagram/models/user_model.dart';
import 'package:flutter_firebase_instagram/utilities/constant.dart';

class DatabaseService {
  static Future<void> updateUser(User user) async {
    await userRef.document(user.id).updateData({
      'name': user.name,
      'bio': user.bio,
      'profileImageUrl': user.profileImageUrl,
    });
  }

  static Future<void> createPost(Post post) async {
    postsRef.document(post.authorId).collection('userPosts').add({
      'imageUrl': post.imageUrl,
      'caption': post.caption,
      'likesCount': post.likeCount,
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

  static Future<List<Post>> getFeedPosts(String userId) async {
    QuerySnapshot feedsSnapshot = await feedsRef
        .document(userId)
        .collection('userFeed')
        .orderBy('timeStamp', descending: true)
        .getDocuments();

    List<Post> posts =
        feedsSnapshot.documents.map((doc) => Post.fromDoc(doc)).toList();
    return posts;
  }

  static Future<List<Post>> getUserPosts(String userId) async {
    QuerySnapshot postsSnapshot = await postsRef
        .document(userId)
        .collection('userPosts')
        .orderBy('timeStamp', descending: true)
        .getDocuments();

    List<Post> posts =
        postsSnapshot.documents.map((doc) => Post.fromDoc(doc)).toList();

    return posts;
  }

  //post have authorId, so we need a methord to getuser details from a ID
  static Future<User> getUserFromId(String userId) async {
    DocumentSnapshot userDocSnapshot = await userRef.document(userId).get();
    if (userDocSnapshot.exists) {
      return User.fromDoc(userDocSnapshot);
    }
    return User();
  }

  static void likePost({String currentUserId, Post post}) async {
    DocumentReference postRef = postsRef
        .document(post.authorId)
        .collection('userPosts')
        .document(post.id);

    postRef.get().then((doc) {
      int likeCount = doc.data['likesCount'];
      String des = doc.data['caption'];
      print('like Count >>>   $likeCount');
      print('like Count >>>   $des');
      postRef.updateData({'likesCount': likeCount + 1});

      likesRef
          .document(post.id)
          .collection('postLikes')
          .document(currentUserId)
          .setData({});
    });

    addActivityItem(post: post, currentUserId: currentUserId, comment: null);
  }

  static void unLikePost({String currentUserId, Post post}) async {
    DocumentReference postRef = postsRef
        .document(post.authorId)
        .collection('userPosts')
        .document(post.id);

    postRef.get().then((doc) {
      int likeCount = doc.data['likesCount'];
      print('like Count >>>   $likeCount');
      postRef.updateData({'likesCount': likeCount - 1});

      likesRef
          .document(post.id)
          .collection('postLikes')
          .document(currentUserId)
          .delete();
    });
  }

  static Future<bool> didLikePost({String currentUserId, Post post}) async {
    DocumentSnapshot userDoc = await likesRef
        .document(post.id)
        .collection('postLikes')
        .document(currentUserId)
        .get();
    return userDoc.exists;
  }

  static Future<Void> commentPost(
      {String currentUserId, Post post, String content}) async {
    await commentsRef.document(post.id).collection('postComments').add({
      'content': content,
      'authorId': currentUserId,
      'timeStamp': Timestamp.fromDate(DateTime.now()),
    });

    addActivityItem(currentUserId: currentUserId, post: post, comment: content);
  }

  static void addActivityItem(
      {String currentUserId, Post post, String comment}) {
    //stop adding own like and commet to activity
    if (currentUserId != post.authorId) {
      activitiesRef.document(post.authorId).collection('userActivities').add({
        'fromUserId': currentUserId,
        'postId': post.id,
        'postImageUrl': post.imageUrl,
        'comment': comment,
        'timeStamp': Timestamp.fromDate(DateTime.now())
      });
    }
  }

  static Future<List<Activity>> getActivities(String userId) async {
    QuerySnapshot userActivitySnapshot = await activitiesRef
        .document(userId)
        .collection('userActivities')
        .orderBy('timeStamp', descending: true)
        .getDocuments();

    List<Activity> activities = userActivitySnapshot.documents
        .map((doc) => Activity.formDoc(doc))
        .toList();

    return activities;
  }

  static Future<Post> getUserPost(String userId, String postId) async {
    DocumentSnapshot postDocSnapshot = await postsRef
        .document(userId)
        .collection('userPosts')
        .document(postId)
        .get();
    Post post = Post.fromDoc(postDocSnapshot);
    return post;
  }
}
