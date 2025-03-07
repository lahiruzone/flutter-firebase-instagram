import 'package:cloud_firestore/cloud_firestore.dart';

class Comment{
  final String id;
  final String content;
  final String authorId;
  final Timestamp timeStamp;

  Comment({this.id, this.content, this.authorId, this.timeStamp});

  factory Comment.formDoc(DocumentSnapshot doc){
    return Comment(
      id: doc.documentID,
      content: doc['content'],
      authorId: doc['authorId'],
      timeStamp: doc['timeStamp']
    );
  }
}