import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_instagram/models/user_data.dart';
import 'package:flutter_firebase_instagram/models/user_model.dart';
import 'package:flutter_firebase_instagram/screens/EditProfileScreen.dart';
import 'package:flutter_firebase_instagram/services/database_service.dart';
import 'package:flutter_firebase_instagram/utilities/constant.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;
  final String currentUserId;

  ProfileScreen({this.currentUserId, this.userId});

  @override
  State<StatefulWidget> createState() {
    return _ProfileScreenState();
  }
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isFollowing = false;
  int _followerCount = 0;
  int _followingCount = 0;

  @override
  void initState() {
    super.initState();
    _setupIsFollowing();
    _setupFollowers();
    _setupFollowing();
  }

  //becourse you can not run asyn in init
  _setupIsFollowing() async {
    bool isFollowingUser = await DatabaseService.isFollowingUser(
        //we canot pass Provider to currentUserId becourse it needd context and the context is unavalable in init state so pass it from privious screen
        currentUserId: widget.currentUserId,
        userId: widget.userId);
    setState(() {
      _isFollowing = isFollowingUser;
    });
  }

  _setupFollowers() async {
    int userFollowerCount = await DatabaseService.numFollowers(widget.userId);
    setState(() {
      _followerCount = userFollowerCount;
    });
  }

  _setupFollowing() async {
    int userFollowingCount = await DatabaseService.numFollowing(widget.userId);
    setState(() {
      _followingCount = userFollowingCount;
    });
  }

  _profileDetails(int count, String description) {
    return Column(
      children: <Widget>[
        Text(
          count.toString(),
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
        ),
        Text(
          description,
          style: TextStyle(color: Colors.black54),
        ),
      ],
    );
  }

  _displayButton(User user) {
    return user.id ==
            Provider.of<UserData>(context, listen: false).currentUserId
        ? Container(
            width: 200.0,
            child: FlatButton(
                color: Colors.blue,
                textColor: Colors.white,
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => EditProfileScreen(user: user))),
                child: Text(
                  'Edit Profile',
                  style: TextStyle(fontSize: 18.0),
                )),
          )
        : Container(
            width: 200.0,
            child: FlatButton(
                color: _isFollowing ? Colors.grey[300] : Colors.blue,
                textColor: _isFollowing ? Colors.black : Colors.white,
                onPressed: () {
                  if (_isFollowing) {
                    print("ISF trur>>>>>>>>>>>>>>>>>.");
                    DatabaseService.unFollowUser(
                        Provider.of<UserData>(context, listen: false)
                            .currentUserId,
                        user.id);
                    setState(() {
                      _isFollowing = false;
                      _followerCount--;
                    });
                  } else {
                    print("ISF false>>>>>>>>>>>>>>>>>.");
                    DatabaseService.followUser(
                        Provider.of<UserData>(context, listen: false)
                            .currentUserId,
                        user.id);
                    setState(() {
                      _isFollowing = true;
                      _followerCount++;
                    });
                  }
                },
                child: Text(
                  _isFollowing ? 'Unfollow' : 'Follow',
                  style: TextStyle(fontSize: 18.0),
                )),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
      body: FutureBuilder(
        future: userRef.document(widget.userId).get(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            User user = User.fromDoc(snapshot.data);
            print('AAAAA');
            print(user.profileImageUrl);
            return ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 0),
                  child: Row(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 50.0,
                        backgroundImage: user.profileImageUrl.isEmpty
                            ? AssetImage('assets/images/user_paceholder.png')
                            : CachedNetworkImageProvider(user.profileImageUrl),
                      ),
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                _profileDetails(12, 'Posts'),
                                _profileDetails(_followingCount, 'Following'),
                                _profileDetails(_followerCount, 'Followers'),
                              ],
                            ),
                            _displayButton(user),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        user.name,
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Container(height: 80.0, child: Text(user.bio)),
                      Divider()
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
