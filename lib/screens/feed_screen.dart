import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_instagram/models/post_model.dart';
import 'package:flutter_firebase_instagram/models/user_model.dart';
import 'package:flutter_firebase_instagram/screens/profile_screen.dart';
import 'package:flutter_firebase_instagram/services/auth_service.dart';
import 'package:flutter_firebase_instagram/services/database_service.dart';

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

  _buildPost(Post post, User author) {
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ProfileScreen(
                        currentUserId: widget.currentUserId,
                        userId: author.id,
                      ))),
          child: Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                child: CircleAvatar(
                  radius: 25.0,
                  backgroundImage: author.profileImageUrl.isEmpty
                      ? AssetImage('assets/images/user_paceholder.png')
                      : CachedNetworkImageProvider(author.profileImageUrl),
                ),
              ),
              SizedBox(
                width: 8.0,
              ),
              Text(
                author.name,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
              )
            ],
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.width,
          margin: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: CachedNetworkImageProvider(post.imageUrl),
                  fit: BoxFit.cover)),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  IconButton(
                      icon: Icon(Icons.favorite_border),
                      iconSize: 30.0,
                      onPressed: () {}),
                  IconButton(
                      icon: Icon(Icons.comment),
                      iconSize: 30.0,
                      onPressed: () {})
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  '0 likes',
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
                      author.name,
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    post.caption,
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
                          return _buildPost(post, author);
                        });
                  }),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
