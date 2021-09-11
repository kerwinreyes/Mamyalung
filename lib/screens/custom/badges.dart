import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mamyalung/materials.dart';
import 'package:mamyalung/screens/custom/custom.dart';

class Badges extends StatefulWidget {
  final String? uid;
  const Badges({Key? key, required this.uid}) : super(key: key);

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

  void read() {
    FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: widget.uid)
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
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: MediaQuery.of(context).size.width <= 649
                    ? NetworkImage("https://i.ibb.co/YBzRfyT/background.png")
                    : NetworkImage(
                        "https://i.ibb.co/4Mn4Mh5/mamyalungnamepets.png"),
                fit: BoxFit.fill),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: ListView(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height * .15,
              ),
              Container(
                color: Colors.transparent,
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
                            child: BadgeTap(
                              lock: points >= 50 ? true : false,
                              buttonText: "Okay",
                              description: "",
                              path: 'https://i.ibb.co/njf8Ndj/steady.png',
                              title: "Slow and Steady",
                              points: points,
                              min: 50,
                              trueMsg: "Remember, slow progress counts!",
                              falseMsg:
                                  "Earn a minimum of 50 points to unlock!",
                            ),
                          ),
                          Expanded(
                            child: BadgeTap(
                              lock: points >= 100 ? true : false,
                              buttonText: "Okay",
                              description: "",
                              path:
                                  'https://i.ibb.co/jZXzvBk/little-Explorer.png',
                              title: "Little Explorer",
                              points: points,
                              min: 100,
                              trueMsg:
                                  "You are a little Explorer! Explore more! Keep it up!",
                              falseMsg:
                                  "Earn a minimum of 100 points to unlock!",
                            ),
                          ),
                          Expanded(
                            child: BadgeTap(
                              lock: points >= 200 ? true : false,
                              buttonText: "Okay",
                              description: "",
                              path: 'https://i.ibb.co/TK6PsmV/fastlearner.png',
                              title: "Fast Learner",
                              points: points,
                              min: 200,
                              trueMsg: "Zooooom! Fast like a Ninja!",
                              falseMsg:
                                  "Earn a minimum of 200 points to unlock!",
                            ),
                          )
                        ],
                      ),
                    )),
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
                            child: BadgeTap(
                              lock: points >= 250 ? true : false,
                              buttonText: "Okay",
                              description: "",
                              path: 'https://i.ibb.co/kSTB0CN/on-fire.png',
                              title: "On Fire",
                              points: points,
                              min: 250,
                              trueMsg: "Raaaawr! Bring up the heat!",
                              falseMsg:
                                  "Earn a minimum of 250 points to unlock!",
                            ),
                          ),
                          Expanded(
                            child: BadgeTap(
                              lock: points >= 500 ? true : false,
                              buttonText: "Okay",
                              description: "",
                              path:
                                  'https://i.ibb.co/8dt2T8m/shiningbright.png',
                              title: "Shinning Bright",
                              points: points,
                              min: 500,
                              trueMsg: "Shine Light, Shine Bright!",
                              falseMsg:
                                  "Earn a minimum of 500 points to unlock!",
                            ),
                          ),
                          Expanded(
                            child: BadgeTap(
                              lock: points >= 1000 ? true : false,
                              buttonText: "Okay",
                              description: "",
                              path: 'https://i.ibb.co/4mt3K9c/royalty.png',
                              title: "Royalty",
                              points: points,
                              min: 1000,
                              trueMsg: "Chin up and don't let your crown fall!",
                              falseMsg:
                                  "Earn a minimum of 1000 points to unlock!",
                            ),
                          )
                        ],
                      ),
                    )),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
