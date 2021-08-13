import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

//firebase package
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//Pages
import '../adminonly.dart';
import '../dashboard.dart';
import '../loginpage.dart';
import '../student.dart';

class UserManagement{
 /* Widget handleAuth(){
    return new StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, snapshot){
        if(snapshot.hasData){
          return DashBoardPage();
        }
        return LoginPage();
      }
      );
  }*/
  authorizeAccess(BuildContext context){
    var user = FirebaseAuth.instance.currentUser;
    final List role;
    if(user != null){
      FirebaseFirestore.instance
      .collection('/users')
      .where('uid', isEqualTo: user.uid)
      .get()
      .then((QuerySnapshot querySnapshot){
         querySnapshot.docs.forEach((doc) {
          if(identical(doc['role'],'Admin')){
           Navigator.of(context).push(
              new MaterialPageRoute(
                builder: (BuildContext context)=> new AdminPage()));
          }
          else{
            print('Not Authorized');
          }
        }); 
      });
  }
  }
  signOut(){
    FirebaseAuth.instance.signOut();
  }
}