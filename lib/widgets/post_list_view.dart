import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_instagram/models/post_model.dart';
import 'package:flutter_firebase_instagram/models/user_model.dart';
import 'package:flutter_firebase_instagram/screens/profile_screen.dart';

class PostListView extends StatelessWidget {
  final String currentUserId;
  final Post post;
  final User author;
  final bool isPostListVieweUsedInProfileScreen; //stop navigate own profile by clicking profile image

  const PostListView({this.currentUserId, this.post, this.author, this.isPostListVieweUsedInProfileScreen});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () => !isPostListVieweUsedInProfileScreen   
              ? Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ProfileScreen(
                            currentUserId: currentUserId,
                            userId: author.id,
                          )))
              : {},
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
}
