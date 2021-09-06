import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LeaderBoard extends StatefulWidget {
  const LeaderBoard({ Key? key }) : super(key: key);

  @override
  _LeaderBoardState createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoard> {

  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('users')
  .where('role', isEqualTo: 'Student')
  .orderBy('points', descending: true)
  .snapshots();

  @override
  Widget build(BuildContext context) {
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

        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage('https://i.ibb.co/TTfqqbc/leaderboards.png'),
              fit: BoxFit.fill
            )
          ),
        child: Column(
          children: [
            Padding(padding: EdgeInsets.fromLTRB(60, MediaQuery.of(context).size.height * .17, 60, 0),
              child: Row(
                children: [
                  Text("Student Name"),
                  Spacer(),
                  Text("Points")
                ],
              )
            ),
            Container(
              //padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * .1),
              child: ListView(
                shrinkWrap: true,
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                  return _buildRow("${data['fname']} ${data['lname']}" , data['points']);
                }).toList(),
              )
            )
          ],
        )
      );
      },
    );
  }
}
Widget _buildRow(String name, var score) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 60.0),
    child: Column(
      children: <Widget>[
        SizedBox(height: 12),
        //rContainer(height: 2, color: Colors.redAccent),
        SizedBox(height: 12),
        Row(
          children: <Widget>[
            CircleAvatar(backgroundImage: NetworkImage('https://i.ibb.co/gghzqTq/mamyalung-logo.png')),
            SizedBox(width: 12),
            Text(name),
            Spacer(),
            Container(
              decoration: BoxDecoration(color: Colors.yellow[900], borderRadius: BorderRadius.circular(20)),
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              child: Text('$score'),
            ),
          ],
        ),
      ],
    ),
  );
}