import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_instagram/models/post_model.dart';
import 'package:flutter_firebase_instagram/models/user_model.dart';
import 'package:flutter_firebase_instagram/screens/profile_screen.dart';
import 'package:flutter_firebase_instagram/services/auth_service.dart';
import 'package:flutter_firebase_instagram/services/database_service.dart';
import 'package:flutter_firebase_instagram/widgets/post_list_view.dart';

class FeedScreen extends StatefulWidget {
  static final String id = 'fedd_strteam';
  final String currentUserId;

  const FeedScreen({this.currentUserId});

  @override
  State<StatefulWidget> createState() {
    return _FeedScreenState();
  }
}

class _FeedScreenState extends State<FeedScreen> {
  List<Post> _posts = [];

  @override
  void initState() {
    super.initState();
    _setupFeed();
  }

  _setupFeed() async {
    List<Post> posts = await DatabaseService.getFeedPosts(widget.currentUserId);
    setState(() {
      _posts = posts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          'Instergram',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Billabong',
            fontSize: 35.0,
          ),
        ),
      ),
      body: _posts.length > 0
          ? RefreshIndicator(
              onRefresh: () => _setupFeed(),
              child: ListView.builder(
                  itemCount: _posts.length,
                  itemBuilder: (BuildContext context, int index) {
                    Post post = _posts[index];
                    return FutureBuilder(
                        future: DatabaseService.getUserFromId(post.authorId),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (!snapshot.hasData) {
                            return SizedBox.shrink();
                          }
                          User author = snapshot.data;
                          //PostListView -> Custome made widget
                          return PostListView(
                            currentUserId: widget.currentUserId,
                            author: author,
                            post: post,
                            isPostListVieweUsedInProfileScreen: false,
                          );
                        });
                  }),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
