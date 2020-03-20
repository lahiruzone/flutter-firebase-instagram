import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SearchScreenState();
  }
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Search'),
      ),
    );
  }
}
