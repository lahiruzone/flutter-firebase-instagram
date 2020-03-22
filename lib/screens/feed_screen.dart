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
      body: FlatButton(
          onPressed: () => AuthService.signOut(), child: Text('Signout')),
    );
  }
}
