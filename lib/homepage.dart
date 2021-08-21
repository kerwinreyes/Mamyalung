import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mamyalung/dashboard.dart';

class RoutePage extends StatelessWidget {
  const RoutePage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
     var user = FirebaseAuth.instance.currentUser;
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
                builder: (BuildContext context)=> new DashBoardPage(user: user)));
          }else if(identical(doc['role'],'teacher')){
            return ;
          }
          else{
            print('Not Authorized');
          }
        }); 
      });
  }
    return Container(
      
    );
  }
}