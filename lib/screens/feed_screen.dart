import 'package:flutter/material.dart';
import 'package:flutter_firebase_instagram/services/auth_service.dart';

class FeedScreen extends StatefulWidget {
  static final String id = 'fedd_strteam';

  @override
  State<StatefulWidget> createState() {
    return _FeedScreenState();
  }
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: FlatButton(
          onPressed: () => AuthService.signOut(context),
          child: Text('Signout')),
    );
  }
}
