import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mamyalung/materials.dart';

class LeaderBoard extends StatefulWidget {
  final String? uid;
  final String? image;
  final String? name;
  final int? points;
  const LeaderBoard({ Key? key, this.uid, this.image, this.name, this.points }) : super(key: key);

  @override
  _LeaderBoardState createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoard> {
  int grlvll = 2;
  int i = 0;
  Color my = Colors.brown, CheckMyColor = Colors.white;

  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('users')
  .where('role', isEqualTo: 'Student')
  .orderBy('points', descending: true)
  .snapshots();
  int stud_points = 0;
  String stud_name ='';
  String stud_image='';
  @override
  void initState() {
    super.initState();
  FirebaseFirestore.instance
    .collection('users')
    .where('uid',isEqualTo: widget.uid)
    .get()
    .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
      setState(() {
        stud_name = doc['fname'] +' ' + doc['lname'];
        stud_image = doc['image'];
        stud_points = doc['points'];
      });
    });
    });
  }
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var screenSizeW = screenSize.width;
    var screenSizeH = screenSize.height;
        var r = TextStyle(color: Colors.purpleAccent, fontSize: 34);
    return Stack(
      children: <Widget>[
        Scaffold(
            body: Container(
          margin: EdgeInsets.only(top: 65.0),
          decoration: BoxDecoration(
        image: DecorationImage(
          image: screenSizeW <= 649 ? NetworkImage('https://i.ibb.co/4ZJJDVq/leadeboardsmobile.png') : NetworkImage("https://i.ibb.co/RPPY7mM/leaderboardsweb.png"), fit: BoxFit.fill)),
          
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 15.0, top: 10.0),
                child: RichText(
                    text: TextSpan(
                        text: "Leader",
                        style: TextStyle(
                            color: Colors.deepPurple,
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold),
                        children: [
                      TextSpan(
                          text: " Board",
                          style: TextStyle(
                              color: Colors.pink,
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold))
                    ])),
              ),

              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Text(
                  'Global Rank Board: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Flexible(
                  child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .where('role', isEqualTo: 'Student')
                          .orderBy('points', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          i = 0;
                          return ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                print(index);
                                if (index >= 1) {
                                  print('Greater than 1');
                                  if (snapshot.data!.docs[index]['points'] ==
                                      snapshot.data!.docs[index - 1]['points']) {
                                    print('Same');
                                  } else {
                                    i++;
                                  }
                                }

                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0, vertical: 5.0),
                                  child: InkWell(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: i == 0
                                                  ? Colors.amber
                                                  : i == 1
                                                      ? Colors.grey
                                                      : i == 2
                                                          ? Colors.brown
                                                          : Colors.white,
                                              width: 3.0,
                                              style: BorderStyle.solid),
                                          borderRadius:
                                              BorderRadius.circular(5.0)),
                                      width: MediaQuery.of(context).size.width,
                                      child: Column(
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10.0, left: 15.0),
                                                child: Row(
                                                  children: <Widget>[
                                                    CircleAvatar(
                                                        child: Container(
                                                            decoration: BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                image: DecorationImage(
                                                                    image: NetworkImage(snapshot
                                                                            .data
                                                                            !.docs[
                                                                                index][
                                                                        'image']),
                                                                    fit: BoxFit
                                                                        .fill)))),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 20.0, top: 10.0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Container(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          snapshot
                                                              .data
                                                              !.docs[index]['fname'] + ' '+
                                                              snapshot.data
                                                              !.docs[index]['lname'],
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .deepPurple,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                          maxLines: 6,
                                                        )),
                                                    Text("Points: " +
                                                        snapshot
                                                            .data
                                                            !.docs[index]['points']
                                                            .toString()),
                                                  ],
                                                ),
                                              ),
                                              Flexible(child: Container()),
                                              i == 0
                                                  ? Text("🥇", style: r)
                                                  : i == 1
                                                      ? Text(
                                                          "🥈",
                                                          style: r,
                                                        )
                                                      : i == 2
                                                          ? Text(
                                                              "🥉",
                                                              style: r,
                                                            )
                                                          : Text(''),
                                              
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              });
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      }))
            ],
          ),
        )),
        Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height*.75),
        
        Container(
          color: primaryBlue,
          height:100,
          child: Row(
            children: [
              CircleAvatar(backgroundImage: NetworkImage('${widget.image}'), backgroundColor: Colors.transparent,),
            SizedBox(width: 12),
            AutoSizeText('${widget.name}'),
            SizedBox(width: 12),
            AutoSizeText('${widget.points}'),
            SizedBox(width: 12),
            ],
          )
        )]),
      ],
    );
    
  }
}
Widget _buildRow(String name, var score, String image, int grlvl) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 60.0),
    child: Column(
      children: <Widget>[
        SizedBox(height: 12),
        //rContainer(height: 2, color: Colors.redAccent),
        SizedBox(height: 12),
        Row(
          children: <Widget>[
            CircleAvatar(backgroundImage: NetworkImage(image), backgroundColor: Colors.transparent,),
            SizedBox(width: 12),
            AutoSizeText(name, style: TextStyle(fontFamily: 'Spans', fontSize: 20), presetFontSizes: [30,25,20],),
            SizedBox(width: 12),
            AutoSizeText('Grade Level: '+'$grlvl', style: TextStyle(fontFamily: 'Spans', fontSize: 20), presetFontSizes: [30,25,20],),
            
            Spacer(),
            Container(
              decoration: BoxDecoration(
               // boxShadow: [
               //   BoxShadow(
               //   color: gray,
                //  blurRadius: 30,
               //   spreadRadius: 10,
                //  offset: Offset(2,5)
                //  ),
               // ],
                color: Color(0xFF8793B2), 
                borderRadius: BorderRadius.circular(10)),
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              child: Text('$score', style: TextStyle(fontFamily: 'Moon', fontSize: 15)),
            ),
          ],
        ),
      ],
    ),
  );
}