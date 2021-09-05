import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mamyalung/screens/custom/custom.dart';
import 'package:mamyalung/screens/students/homepage.dart';


class BadgeMsg extends StatefulWidget {
  final String? uid;
  final String path;
  const BadgeMsg({ Key? key, required this.uid, required this.path}) : super(key: key);

  @override
  _BadgeMsgState createState() => _BadgeMsgState();
}

class _BadgeMsgState extends State<BadgeMsg> {

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  int badgeCount = 0;

  void read(){
    FirebaseFirestore.instance
    .collection('users')
    .where('uid',isEqualTo: widget.uid)
    .get()
    .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
        setState(() {
        badgeCount = doc['badge_count'];
      });
    });
  });

  }
  Future<void> updateUser() {
  return users
    .doc('${widget.uid}')
    .update({'badge_count' : badgeCount + 1})
    .then((value) => print("User Updated"))
    .catchError((error) => print("Failed to update user: $error"));
}
  @override
  void initState() { 
    super.initState();
    read();
  }
  @override
  Widget build(BuildContext context) {
    updateUser();
    return Scaffold(
      body:
      Stack(
        children: <Widget>[
          Container(
            color: Colors.blue,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * .5,
                  child: Image(
                    image: NetworkImage("${widget.path}"),
                  )
                ),
                Expanded(
                  child: Text("Congrats! \n You just unlocked New Badge",textAlign: TextAlign.center,),
                ),
                GestureDetector(
                  child: Container(
                  padding: EdgeInsets.all(8.0),
                  color: Colors.green,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Center(
                              child:(Text("Collect")
                              )
                            )
                          ),                  
                        ]
                      )
                    )
                  )
                ),
                onTap: (){
                  Navigator.pop(context);

                }
                )
              ],
            )
          ),
          // GestureDetector(
          //   onTap:(){
          //     Navigator.pop(context);
          //  }
          //) 
        ],
      )
    );
  }
}