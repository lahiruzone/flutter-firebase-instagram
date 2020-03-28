import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_instagram/models/comment_model.dart';
import 'package:flutter_firebase_instagram/models/user_data.dart';
import 'package:flutter_firebase_instagram/models/user_model.dart';
import 'package:flutter_firebase_instagram/services/database_service.dart';
import 'package:flutter_firebase_instagram/utilities/constant.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CommetScreen extends StatefulWidget {
  final String postId;
  final int likeConut;

  const CommetScreen({this.postId, this.likeConut});
  @override
  _CommetScreenState createState() => _CommetScreenState();
}

class _CommetScreenState extends State<CommetScreen> {
  final TextEditingController _commentController = TextEditingController();
  bool _isCommenting = false;
  _buildComment(Comment comment) {
    return FutureBuilder(
      future: DatabaseService.getUserFromId(comment.authorId),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return SizedBox.shrink();
        } else {
          User author = snapshot.data;
          return ListTile(
            leading: CircleAvatar(
              radius: 25.0,
              backgroundColor: Colors.grey,
              backgroundImage: author.profileImageUrl.isEmpty
                  ? AssetImage('assets/images/user_paceholder.png')
                  : CachedNetworkImageProvider(author.profileImageUrl),
            ),
            title: Text(author.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(comment.content),
                SizedBox(
                  height: 6.0,
                ),
                Text(DateFormat.yMd()
                    .add_jm()
                    .format(comment.timeStamp.toDate())),
              ],
            ),
          );
        }
      },
    );
  }

  _buildCommentTF() {
    final currentUserId = Provider.of<UserData>(context).currentUserId;
    return IconTheme(
        data: IconThemeData(
            color: _isCommenting
                ? Theme.of(context).accentColor
                : Theme.of(context).disabledColor),
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: 8.0,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 10.0,
              ),
              Expanded(
                  child: TextField(
                controller: _commentController,
                textCapitalization: TextCapitalization.sentences,
                onChanged: (comment) {
                  setState(() {
                    _isCommenting = comment.length > 0;
                  });
                },
                decoration:
                    InputDecoration.collapsed(hintText: 'Write a comment...'),
              )),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 4.0),
                child: IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      if (_isCommenting) {
                        DatabaseService.commentPost(
                            currentUserId: currentUserId,
                            postId: widget.postId,
                            content: _commentController.text);
                      }
                      _commentController.clear();
                      setState(() {
                        _isCommenting = false;
                      });
                    }),
              )
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Comments',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text('${widget.likeConut} likes'),
          ),
          StreamBuilder(
            stream: commentsRef
                .document(widget.postId)
                .collection('postComments')
                .orderBy('timeStamp', descending: true)
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Expanded(
                    child: ListView.builder(
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (BuildContext context, int index) {
                          Comment comment =
                              Comment.formDoc(snapshot.data.documents[index]);
                          return _buildComment(comment);
                        }));
              }
            },
          ),
          Divider(
            height: 1.0,
          ),
          _buildCommentTF(),
        ],
      ),
    );
  }
}
