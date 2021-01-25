import 'package:bleApp2/homepage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Demo'),
          backgroundColor: Colors.amber[900],
        ),
        body: Homepage(),
      ),
    );
  }
}
