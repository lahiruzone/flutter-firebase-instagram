import 'package:flutter/material.dart';
import 'package:flutter_firebase_instagram/services/auth_service.dart';

class ActivityScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProfilecreenState();
  }
}

class _ProfilecreenState extends State<ActivityScreen> {
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
      body: Center(
        child: FlatButton(
          onPressed: () => AuthService.signOut(),
          child: Text('SignOut'),
        ),
      ),
    );
  }
}
