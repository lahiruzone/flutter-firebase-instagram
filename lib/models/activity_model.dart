import 'package:cloud_firestore/cloud_firestore.dart';

class Activity {
  final String id;
  final String fromUserId;
  final String postId;
  final String postImageUrl;
  final String comment;
  final Timestamp timeStamp;

  Activity(
      {this.id,
      this.fromUserId,
      this.postId,
      this.postImageUrl,
      this.comment,
      this.timeStamp});

  factory Activity.formDoc(DocumentSnapshot doc) {
    return Activity(
        id: doc.documentID,
        fromUserId: doc['fromUserId'],
        postId: doc['postId'],
        postImageUrl: doc['postImageUrl'],
        comment: doc['comment'],
        timeStamp: doc['timeStamp']);
  }
}
