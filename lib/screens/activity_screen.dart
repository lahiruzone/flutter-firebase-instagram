import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_instagram/models/activity_model.dart';
import 'package:flutter_firebase_instagram/models/post_model.dart';
import 'package:flutter_firebase_instagram/models/user_data.dart';
import 'package:flutter_firebase_instagram/models/user_model.dart';
import 'package:flutter_firebase_instagram/screens/comment_screen.dart';
import 'package:flutter_firebase_instagram/services/auth_service.dart';
import 'package:flutter_firebase_instagram/services/database_service.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ActivityScreen extends StatefulWidget {
  final String currentUserId;

  const ActivityScreen({this.currentUserId});
  @override
  State<StatefulWidget> createState() {
    return _ProfilecreenState();
  }
}

class _ProfilecreenState extends State<ActivityScreen> {
  List<Activity> _activities = [];
  @override
  void initState() {
    super.initState();
    _setupActivities();
  }

  _setupActivities() async {
    List<Activity> activities =
        await DatabaseService.getActivities(widget.currentUserId);
    setState(() {
      _activities = activities;
    });
  }

  _builActivity(Activity activity){
    return FutureBuilder(
        future: DatabaseService.getUserFromId(activity.fromUserId),
        builder: (BuildContext contex, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return SizedBox.shrink();
          }
          User user = snapshot.data;
          return ListTile(
            leading: CircleAvatar(
              radius: 20.0,
              backgroundColor: Colors.grey,
              backgroundImage: user.profileImageUrl.isEmpty
                  ? AssetImage('assets/images/user_paceholder.png')
                  : CachedNetworkImageProvider(user.profileImageUrl),
            ),
            title: activity.comment != null
                ? Text('${user.name} commented: "${activity.comment}"')
                : Text('${user.name} liked your post'),
            subtitle: Text(
                DateFormat.yMd().add_jm().format(activity.timeStamp.toDate())),
            trailing: CachedNetworkImage(
              imageUrl: activity.postImageUrl,
              height: 40.0,
              width: 40.0,
              fit: BoxFit.cover,
            ),
            onTap: () async {
              String currentUserId =
                  Provider.of<UserData>(context,listen: false).currentUserId;
              Post post = await DatabaseService.getUserPost(
                  currentUserId, activity.postId);

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => CommetScreen(
                            post: post,
                            likeConut: post.likeCount,
                          )));
            },
          );
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
        body: RefreshIndicator(
            child: ListView.builder(
                itemCount: _activities.length,
                itemBuilder: (BuildContext context, int index) {
                  Activity activity = _activities[index];
                  return _builActivity(activity);
                }),
            onRefresh: () => _setupActivities()));
  }
}
