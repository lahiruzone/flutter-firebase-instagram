import 'dart:async';

import 'package:animator/animator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_instagram/models/post_model.dart';
import 'package:flutter_firebase_instagram/models/user_model.dart';
import 'package:flutter_firebase_instagram/screens/comment_screen.dart';
import 'package:flutter_firebase_instagram/screens/profile_screen.dart';
import 'package:flutter_firebase_instagram/services/database_service.dart';

class PostListView extends StatefulWidget {
  final String currentUserId;
  final Post post;
  final User author;
  final bool
      isPostListVieweUsedInProfileScreen; //stop navigate own profile by clicking profile image

  const PostListView(
      {this.currentUserId,
      this.post,
      this.author,
      this.isPostListVieweUsedInProfileScreen});

  @override
  _PostListViewState createState() => _PostListViewState();
}

class _PostListViewState extends State<PostListView> {
  int _likeCount = 0;
  bool _isLiked = false;
  bool _heartAnim = false;

  @override
  void initState() {
    super.initState();
    _likeCount = widget.post.likeCount;
    _initPostIsLiked();
  }

  //called when we refresh listviewbuilder
  @override
  void didUpdateWidget(covariant PostListView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.post.likeCount != widget.post.likeCount) {
      _likeCount = widget.post.likeCount;
    }
  }

  _initPostIsLiked() async {
    bool isLiked = await DatabaseService.didLikePost(
        post: widget.post, currentUserId: widget.currentUserId);
    //mounted -> Listen thst the widget in the tree bofore setting state
    if (mounted) {
      setState(() {
        _isLiked = isLiked;
      });
    }
  }

//these functions runs in loading autimaticaly -> both if and else parts in same time
  // _likeButtonFunction() {
  // if (!_isLiked) {
  //   DatabaseService.likePost(
  //       post: widget.post, currentUserId: widget.currentUserId);
  //   setState(() {
  //     _likeCount++;
  //     _isLiked = true;
  //     _heartAnim = true;
  //   });
  //   // Timer(Duration(milliseconds: 350), () {
  //   //   setState(() {
  //   //     _heartAnim = false;
  //   //   });
  //   // });
  // } else {
  //   DatabaseService.unLikePost(
  //       post: widget.post, currentUserId: widget.currentUserId);
  //   setState(() {
  //     _likeCount--;
  //     _isLiked = false;
  //   });
  // }
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () => !widget.isPostListVieweUsedInProfileScreen
              ? Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ProfileScreen(
                            currentUserId: widget.currentUserId,
                            userId: widget.author.id,
                          )))
              : {},
          child: Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                child: CircleAvatar(
                  radius: 25.0,
                  backgroundImage: widget.author.profileImageUrl.isEmpty
                      ? AssetImage('assets/images/user_paceholder.png')
                      : CachedNetworkImageProvider(
                          widget.author.profileImageUrl),
                ),
              ),
              SizedBox(
                width: 8.0,
              ),
              Text(
                widget.author.name,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
              )
            ],
          ),
        ),
        GestureDetector(
          onDoubleTap: () {
            if (!_isLiked) {
              DatabaseService.likePost(
                  post: widget.post, currentUserId: widget.currentUserId);
              setState(() {
                _likeCount++;
                _isLiked = true;
                _heartAnim = true;
              });
              Timer(Duration(milliseconds: 450), () {
                setState(() {
                  _heartAnim = false;
                });
              });
            } else {
              DatabaseService.unLikePost(
                  post: widget.post, currentUserId: widget.currentUserId);
              setState(() {
                _likeCount--;
                _isLiked = false;
              });
            }
          },
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Center(
                child: Container(
                  height: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image:
                              CachedNetworkImageProvider(widget.post.imageUrl),
                          fit: BoxFit.cover)),
                ),
              ),
              _heartAnim
                  ? Animator(
                      duration: Duration(milliseconds: 300),
                      tween: Tween(begin: 0.5, end: 1.4),
                      curve: Curves.elasticInOut,
                      builder: (anim) => Transform.scale(
                        scale: anim.value,
                        child: Icon(
                          Icons.favorite,
                          size: 100.0,
                          color: Colors.red[400],
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  IconButton(
                      icon: _isLiked
                          ? Icon(
                              Icons.favorite,
                              color: Colors.red,
                            )
                          : Icon(Icons.favorite_border),
                      iconSize: 30.0,
                      onPressed: () {
                        if (!_isLiked) {
                          DatabaseService.likePost(
                              post: widget.post,
                              currentUserId: widget.currentUserId);
                          setState(() {
                            _likeCount++;
                            _isLiked = true;
                            _heartAnim = true;
                          });
                          Timer(Duration(milliseconds: 450), () {
                            setState(() {
                              _heartAnim = false;
                            });
                          });
                        } else {
                          DatabaseService.unLikePost(
                              post: widget.post,
                              currentUserId: widget.currentUserId);
                          setState(() {
                            _likeCount--;
                            _isLiked = false;
                          });
                        }
                      }),
                  IconButton(
                      icon: Icon(Icons.comment),
                      iconSize: 30.0,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => CommetScreen(
                                      post: widget.post,
                                      likeConut: _likeCount,
                                    )));
                      })
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  '${_likeCount.toString()} likes',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 4.0,
              ),
              Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 12.0, right: 6.0),
                    child: Text(
                      widget.author.name,
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    widget.post.caption,
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
