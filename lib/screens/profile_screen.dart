import 'package:flutter/material.dart';
import 'package:flutter_firebase_instagram/models/user_model.dart';
import 'package:flutter_firebase_instagram/screens/EditProfileScreen.dart';
import 'package:flutter_firebase_instagram/utilities/constant.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;

  ProfileScreen({this.userId});

  @override
  State<StatefulWidget> createState() {
    return _ProfileScreenState();
  }
}

class _ProfileScreenState extends State<ProfileScreen> {
  _profileDetails(String count, String description) {
    return Column(
      children: <Widget>[
        Text(
          count,
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
        ),
        Text(
          description,
          style: TextStyle(color: Colors.black54),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: userRef.document(widget.userId).get(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            User user = User.fromDoc(snapshot.data);
            return ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 0),
                  child: Row(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 50.0,
                        backgroundColor: Colors.grey,
                      ),
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                _profileDetails('12', 'Posts'),
                                _profileDetails('385', 'Fellowing'),
                                _profileDetails('1050', 'Fellowers'),
                              ],
                            ),
                            Container(
                              width: 200.0,
                              child: FlatButton(
                                  color: Colors.blue,
                                  textColor: Colors.white,
                                  onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              EditProfileScreen(user: user))),
                                  child: Text(
                                    'Edit Profile',
                                    style: TextStyle(fontSize: 18.0),
                                  )),
                            )
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
