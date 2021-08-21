import 'package:flutter/material.dart';
class AdminProfile extends StatefulWidget {
  static const String routeName = '/admin/profile';

  const AdminProfile({ Key? key }) : super(key: key);

  @override
  _AdminProfileState createState() => _AdminProfileState();
}

class _AdminProfileState extends State<AdminProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('Hello!'),
    );
  }
}