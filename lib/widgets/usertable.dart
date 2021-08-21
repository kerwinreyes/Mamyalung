import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mamyalung/extension.dart';
import 'package:intl/intl.dart';
import 'package:mamyalung/model/users.dart';

import '../materials.dart';

Widget buildTripCard(BuildContext context, DocumentSnapshot document) {
  final user = Users.fromSnapshot(document);

  return new Container(
    child: InkWell(
      focusColor: white,
      hoverColor: Colors.grey,
        child: Container(
      padding: EdgeInsets.symmetric(horizontal:2, vertical:20),
      width: MediaQuery.of(context).size.width,
      child:Row(
        
        children: [
        Container(
          width: MediaQuery.of(context).size.width/9,
          child:Text('')
        ),
        Container(
          width: MediaQuery.of(context).size.width/5,
          child:Text(user.email,
          style: GoogleFonts.lato(
                      textStyle: TextStyle(color: gray,fontSize: 16, ),
                    ),)
        ),
        Container(
          width: MediaQuery.of(context).size.width/5,
          child: Text(user.fname+' '+user.lname,
          style: GoogleFonts.lato(
                      textStyle: TextStyle(color: gray,fontSize: 16, ),
                    ),)
        ),
        Container(
          width: MediaQuery.of(context).size.width/7,
          child: Text(user.role,
          style: GoogleFonts.lato(
                      textStyle: TextStyle(color: gray,fontSize: 16, ),
                    ),)
        ),
        
        Container(
          width: MediaQuery.of(context).size.width/7,
          child: Text('Action',
          style: GoogleFonts.lato(
                      textStyle: TextStyle(color: gray,fontSize: 16, ),
                    ),)
        ),
      ],),),
        onTap: () {
          /*Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailTripView(trip: trip)),
          );*/
        },
      )
  );
}
Widget moblieViewUsers(BuildContext context, DocumentSnapshot document) {
  final user = Users.fromSnapshot(document);

  return new ListTile(
              title: Padding(
                padding: EdgeInsets.all(5),
                child: Text(user.fname+' '+user.lname),
              ),
              subtitle: Text(user.role),
              leading: Icon(Icons.person),
              trailing: Icon(Icons.arrow_forward),
              onTap: (){

              },
            );
}