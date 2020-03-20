import 'package:flutter/material.dart';

class CreatePostScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CreatePostScreenState();
  }
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Create Post'),
      ),
    );
  }
}
