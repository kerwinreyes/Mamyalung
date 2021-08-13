import 'package:flutter/material.dart';

class AlluserPage extends StatefulWidget {
  const AlluserPage({ Key? key }) : super(key: key);

  @override
  _AlluserPageState createState() => _AlluserPageState();
}

class _AlluserPageState extends State<AlluserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All User Allowed'),
        centerTitle: true,
      )
    );
  }
}