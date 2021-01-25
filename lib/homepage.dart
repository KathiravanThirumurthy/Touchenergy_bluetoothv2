import 'package:flutter/material.dart';

import 'Toggleswitch.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  //creating an instance
  /* FlutterBlue flutterBlue = FlutterBlue.instance;
  bool initialStatus;*/

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [Toggleswitch()],
      ),
    );
  }
}
