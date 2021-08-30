import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mamyalung/materials.dart';
import 'package:mamyalung/screens/custom/custom.dart';
class Badges extends StatefulWidget {
  final String id;
  const Badges({ Key? key, required this.id }) : super(key: key);

  @override
  _BadgesState createState() => _BadgesState();
}

class _BadgesState extends State<Badges> {
  @override
  
Widget build(BuildContext context) {
  final Stream<QuerySnapshot> _studStream = FirebaseFirestore.instance
    .collection('users')
    .where('uid',isEqualTo: "${widget.id}")
    .snapshots();
  
  late bool first,second,third,fourth,fifth,sixth,seventh,eight,ninth = false;    
  int count = 0;                                       
  // setState(() {
  // FirebaseFirestore.instance
  // .collection('users')
  // .where('uid',isEqualTo: "${widget.id}")
  // .get()
  // .then((QuerySnapshot querySnapshot) {
  //     querySnapshot.docs.forEach((doc) {
  //         count = doc['points'];
  //         switch (count) {
  //           case 0:
  //             first = true;
  //           break;
  //           case 100:
  //             second = true;
  //           break;
  //           case 200:
  //             third = true;
  //           break;
  //           case 300:
  //             fourth = true;
  //           break;
  //           case 400:
  //             fifth = true;
  //           break;
  //           case 500:
  //             sixth = true;
  //           break;
  //           case 600:
  //             seventh = true;
  //           break;
  //           case 700:
  //             eight = true;
  //           break;
  //           case 800:
  //             ninth = true;
  //           break;
  //           default:
  //         }
  //     });
  // });
  // });
  return Container(
          child: ListView(
          children: <Widget>[
            Container(
              color: primaryBlue,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  border: Border.all(width: 5.0, color: Colors.white),
                  //borderRadius: BorderRadius.all(Radius.circular(10))
                ),
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child:  BadgeTap(
                          lock: true,
                          buttonText: "PAKYU KERWIN",
                          description: "TANIDAMO KERWIN",
                          path: 'https://i.ibb.co/jZXzvBk/little-Explorer.png',
                          title: "PAKYU",
                        ),
                      ),
                      Expanded(
                        child:  BadgeTap(
                          lock: false,
                          buttonText: "PAKYU KERWIN",
                          description: "TANIDAMO KERWIN",
                          path: 'assets/images/explorer.png',
                          title: "PAKYU",
                        ),
                      ),
                      Expanded(
                        child:  BadgeTap(
                          lock: false,
                          buttonText: "PAKYU KERWIN",
                          description: "TANIDAMO KERWIN",
                          path: 'assets/images/explorer.png',
                          title: "PAKYU",
                        ),
                      )
                    ],
                  ),
                )
              ),
            ),
            Container(
              color: primaryBlue,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  border: Border.all(width: 5.0, color: Colors.white),
                  //borderRadius: BorderRadius.all(Radius.circular(10))
                ),
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child:  BadgeTap(
                          lock: false,
                          buttonText: "PAKYU KERWIN",
                          description: "TANIDAMO KERWIN",
                          path: 'assets/images/explorer.png',
                          title: "PAKYU",
                        ),
                      ),
                      Expanded(
                        child:  BadgeTap(
                          lock: false,
                          buttonText: "PAKYU KERWIN",
                          description: "TANIDAMO KERWIN",
                          path: 'assets/images/explorer.png',
                          title: "PAKYU",
                        ),
                      ),
                      Expanded(
                        child:  BadgeTap(
                          lock: false,
                          buttonText: "PAKYU KERWIN",
                          description: "TANIDAMO KERWIN",
                          path: 'assets/images/explorer.png',
                          title: "PAKYU",
                        ),
                      )
                    ],
                  ),
                )
              ),
            ),
            Container(
              color: primaryBlue,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  border: Border.all(width: 5.0, color: Colors.white),
                  //borderRadius: BorderRadius.all(Radius.circular(10))
                ),
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child:  BadgeTap(
                          lock: false,
                          buttonText: "PAKYU KERWIN",
                          description: "TANIDAMO KERWIN",
                          path: 'assets/images/explorer.png',
                          title: "PAKYU",
                        ),
                      ),
                      Expanded(
                        child:  BadgeTap(
                          lock: false,
                          buttonText: "PAKYU KERWIN",
                          description: "TANIDAMO KERWIN",
                          path: 'assets/images/explorer.png',
                          title: "PAKYU",
                        ),
                      ),
                      Expanded(
                        child:  BadgeTap(
                          lock: false,
                          buttonText: "PAKYU KERWIN",
                          description: "TANIDAMO KERWIN",
                          path: 'assets/images/explorer.png',
                          title: "PAKYU",
                        ),
                      )
                    ],
                  ),
                )
              ),
            ),
          ],
        ),
      );
  }
}
