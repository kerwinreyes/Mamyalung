import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mamyalung/materials.dart';
import 'package:mamyalung/screens/custom/custom.dart';
class Badges extends StatefulWidget {
  final String? uid;
  const Badges({ Key? key, required this.uid }) : super(key: key);

  @override
  _BadgesState createState() => _BadgesState();
}

class _BadgesState extends State<Badges> {
  bool first = false,
  second = false,
  third = false,
  fourth = false,
  fifth = false,
  sixth = false,
  seventh = false,
  eight = false,
  ninth = false;    
  int points = 0;       

  void read(){
    FirebaseFirestore.instance
    .collection('users')
    .where('uid',isEqualTo: widget.uid)
    .get()
    .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
      setState(() {
        points = int.parse(doc['points']);
      });
    });
  });
  }
 

  @override
  void initState() { 
    super.initState();
    read();
  }
   @override
Widget build(BuildContext context) {
  
  return Container(
          child: ListView(
          children: <Widget>[
            Container(
              //color: primaryBlue,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  //borderRadius: BorderRadius.all(Radius.circular(10))
                ),
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child:  BadgeTap(
                          lock: points >= 100 ? true : false,
                          buttonText: "Okay",
                          description: "",
                          path: 'https://i.ibb.co/jZXzvBk/little-Explorer.png',
                          title: "Hey there!",
                          points: points,
                          min: 100,
                          max: 199,
                          trueMsg: "You are a little Explorer! Explore more! Keep it up!",
                          falseMsg: "Earn a minimum of 100 points to unlock!",
                        ),
                      ),
                      Expanded(
                        child:  BadgeTap(
                          lock: points >= 200 ? true : false,
                          buttonText: "Okay",
                          description: "",
                          path: 'https://i.ibb.co/WH9rj7K/shinningbright.png',
                          title: "Sample Title",
                          points: points,
                          min: 200,
                          max: 299,
                          trueMsg: "Sample Message",
                          falseMsg: "Earn a minimum of 200 points to unlock!",
                        ),
                      ),
                      Expanded(
                        child:  BadgeTap(
                         lock: points >= 300 ? true : false,
                          buttonText: "Okay",
                          description: "",
                          path: 'https://i.ibb.co/4mt3K9c/royalty.png',
                          title: "Sample Title",
                          points: points,
                          min: 300,
                          max: 399,
                          trueMsg: "Sample Message",
                          falseMsg: "Earn a minimum of 300 points to unlock!",
                        ),
                      )
                    ],
                  ),
                )
              ),
            ),
            Container(
              //color: primaryBlue,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  border: Border.all(color: Colors.white),
                  //borderRadius: BorderRadius.all(Radius.circular(10))
                ),
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child:  BadgeTap(
                          lock: points >= 400 ? true : false,
                          buttonText: "Okay",
                          description: "",
                          path: 'https://i.ibb.co/jZXzvBk/little-Explorer.png',
                          title: "Sample Title",
                          points: points,
                          min: 400,
                          max: 499,
                          trueMsg: "Sample Message",
                          falseMsg: "Earn a minimum of 400 points to unlock!",
                        ),
                      ),
                      Expanded(
                        child:  BadgeTap(
                         lock: points >= 500 ? true : false,
                          buttonText: "Okay",
                          description: "",
                          path: 'https://i.ibb.co/jZXzvBk/little-Explorer.png',
                          title: "Sample Title",
                          points: points,
                          min: 500,
                          max: 599,
                          trueMsg: "Sample Message",
                          falseMsg: "Earn a minimum of 500 points to unlock!",
                        ),
                      ),
                      Expanded(
                        child:  BadgeTap(
                         lock: points >= 600 ? true : false,
                          buttonText: "Okay",
                          description: "",
                          path: 'https://i.ibb.co/jZXzvBk/little-Explorer.png',
                          title: "Sample Title",
                          points: points,
                          min: 600,
                          max: 699,
                          trueMsg: "Sample Message",
                          falseMsg: "Earn a minimum of 600 points to unlock!",
                        ),
                      )
                    ],
                  ),
                )
              ),
            ),
            Container(
              //color: primaryBlue,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,

                  //borderRadius: BorderRadius.all(Radius.circular(10))
                ),
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child:  BadgeTap(
                          lock: points >= 700 ? true : false,
                          buttonText: "Okay",
                          description: "",
                          path: 'https://i.ibb.co/jZXzvBk/little-Explorer.png',
                          title: "Sample Title",
                          points: points,
                          min: 700,
                          max: 799,
                          trueMsg: "Sample Message",
                          falseMsg: "Earn a minimum of 700 points to unlock!",
                        ),
                      ),
                      Expanded(
                        child:  BadgeTap(
                          lock: points >= 800 ? true : false,
                          buttonText: "Okay",
                          description: "",
                          path: 'https://i.ibb.co/jZXzvBk/little-Explorer.png',
                          title: "Sample Title",
                          points: points,
                          min: 800,
                          max: 899,
                          trueMsg: "Sample Message",
                          falseMsg: "Earn a minimum of 800 points to unlock!",
                        ),
                      ),
                      Expanded(
                        child:  BadgeTap(
                          lock: points >= 900 ? true : false,
                          buttonText: "Okay",
                          description: "",
                          path: 'https://i.ibb.co/jZXzvBk/little-Explorer.png',
                          title: "Sample Title",
                          points: points,
                          min: 900,
                          max: 999,
                          trueMsg: "Sample Message",
                          falseMsg: "Earn a minimum of 900 points to unlock!",
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
