import 'package:cloud_firestore/cloud_firestore.dart';
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
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('users').snapshots();
  final db = FirebaseFirestore.instance;
  List userProfileList=[];
  @override
  void initState(){
    fetchDatabaseList();
    super.initState();
  }
  ggetUser() async {
    List a = [];
    await FirebaseFirestore.instance
      .collection('users')
      .get()
      .then((QuerySnapshot querySnapshot){
         querySnapshot.docs.forEach((DocumentSnapshot doc) {
           a.add(doc.data());
           print(a[0]['fname']);
           print(doc.exists);
           print(doc.id);
        }); 
      });
  }
  fetchDatabaseList() async {
    dynamic resultant = await UserManagement().getUsersList();
    if(resultant == null){
      print('unable to retrieve');
    }else{
        userProfileList = resultant;
        print(userProfileList[0]);
             
    }
  }

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
        child: ListView(
          children: [
            Text('Manage Users'),
            UserInformation(),
            Text('Pakyu')
          ],
        ),
      ),
    );
  }
}

class UserInformation extends StatefulWidget {
  @override
    _UserInformationState createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('users').snapshots();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }
        final data =snapshot.requireData;
        return ListView.builder(
          itemCount: data.size,
          itemBuilder: (context, index){
            print(data.docs[index]['fname']);
            return Text(data.docs[index]['fname']);
          },
        );
      },
    ));
  }
}