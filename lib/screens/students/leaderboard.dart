import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mamyalung/materials.dart';

class LeaderBoard extends StatefulWidget {
  final String? uid;
  const LeaderBoard({ Key? key, this.uid }) : super(key: key);

  @override
  _LeaderBoardState createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoard> {

  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('users')
  .where('role', isEqualTo: 'Student')
  .orderBy('lname', descending: false)
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
    
    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error?.toString());
          return CircularProgressIndicator();
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          print(snapshot.connectionState.toString());
          return CircularProgressIndicator();
        }

        return  Stack(
      children: [
        Container(
          width: screenSizeW,
          height: screenSizeH,
          decoration: BoxDecoration(
        image: DecorationImage(
          image: screenSizeW <= 649 ? NetworkImage('https://i.ibb.co/WWmXCWV/leaderboards.png') : NetworkImage("https://i.ibb.co/RPPY7mM/leaderboardsweb.png"), fit: BoxFit.fill),
          ),),
        SingleChildScrollView(
          child: Column(
          children: [
            Padding(//padding: EdgeInsets.symmetric(vertical: screenSizeH * 0.4, horizontal: screenSizeW *0.09),
                      padding: screenSizeW <= 649 ? EdgeInsets.fromLTRB( screenSizeW *0.09, screenSizeH * 0.2,  screenSizeW *0.09, 0) : EdgeInsets.fromLTRB( screenSizeW *0.34, screenSizeH * 0.3,  screenSizeW *0.34, 0),
              child: Row(
                children: [
                  Text("Student Name", style: TextStyle(fontFamily: 'Playfull', fontSize: 25)),
                  Spacer(),
                  Text("Points", style: TextStyle(fontFamily: 'Playfull', fontSize: 25))
                ],
              )
            ),
            Container(
              padding: screenSizeW <= 649 ? EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * .02): EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * .3) ,
              child: ListView(
                physics: AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                  return _buildRow("${data['fname']} ${data['lname']}" , data['points'],'${data['image']}');
                }).toList(),
              )
            )
          ],
        )),
    
        
      ],
      );
      },
    );
  }
}
Widget _buildRow(String name, var score, String image) {
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
            Text(name, style: TextStyle(fontFamily: 'SundayMorning', fontSize: 20)),
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