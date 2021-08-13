import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mamyalung/materials.dart';
import 'loginpage.dart';
import 'package:mamyalung/services/usermanagement.dart';

import 'allusers.dart';

class DashBoardPage extends StatefulWidget {
  final User user;

  const DashBoardPage({required this.user});

  @override
  _DashBoardPageState createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  bool _isSigningOut=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(
        child: ListView(
          children:[
            new UserAccountsDrawerHeader(
              accountName: new Text('Kerwin'),
              accountEmail: new Text('kerwinreyes0831@gmail.com'),
              currentAccountPicture: new CircleAvatar(
                backgroundColor: primaryBlue,
              ),
            ),
            new ListTile(
              title: new Text('Profile Page'),
              onTap: (){
                Navigator.of(context).pop();
                Navigator.push(
                  context, new MaterialPageRoute(
                    builder: (BuildContext context) => new AlluserPage()));
              }
            ),
            
            new ListTile(
              title: new Text('Admin Page'),
              onTap: (){
               UserManagement().authorizeAccess(context);
               }
            ),
            new ListTile(title: new Text('Logout'),onTap:(){
              UserManagement().signOut();
            },),
            _isSigningOut
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        _isSigningOut = true;
                      });
                      await FirebaseAuth.instance.signOut();
                      setState(() {
                        _isSigningOut = false;
                      });
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ),
                      );
                    },
                    child: Text('Sign out'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
          ]
        )
      ),
      body: Center(
        child:Text('DashBoard Page')
      ),
    );
  }
}