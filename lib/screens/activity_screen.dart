import 'package:flutter/material.dart';

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
      body: Center(
        child: Text('Actvity'),
      ),
    );
  }
}
