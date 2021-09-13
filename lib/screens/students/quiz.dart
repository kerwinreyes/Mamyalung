
import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mamyalung/screens/students/multiplechoice.dart';
import '../../materials.dart';

class QuizCard extends StatefulWidget {
  final String? uid;
  const QuizCard({ Key? key, required this.uid}) : super(key: key);
  @override
  _QuizCardState createState() => _QuizCardState();
}

class _QuizCardState extends State<QuizCard> {

  int gradeLevel = 0;

  void read(){
    FirebaseFirestore.instance
    .collection('users')
    .where('uid',isEqualTo: widget.uid)
    .get()
    .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
      setState(() {
        gradeLevel = doc['grade_level'];

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
    List<DocumentSnapshot> topics =[];
    int topicCount = 0;
    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('topics')
    .where('grade_level', isEqualTo: gradeLevel)
    .snapshots();
    var screenSize = MediaQuery.of(context).size;
    var screenSizeW = screenSize.width;
    var screenSizeH = screenSize.height;
    return Stack(
      children: [
        Container(
          width: screenSizeW,
          height: screenSizeH, 
          decoration: BoxDecoration(
            image: DecorationImage(
            image: screenSizeW <= 649 ? NetworkImage('https://i.ibb.co/YBzRfyT/background.png') : NetworkImage("https://i.ibb.co/Zfs8zLR/mobilebg.png"), fit: BoxFit.fill),
          ),
        ),
        StreamBuilder<QuerySnapshot>(
          stream: _usersStream,
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }
            if(snapshot.hasData){
              topics = snapshot.data!.docs;
              topicCount = topics.length; 
            }
            return GridView.builder(
              itemCount: topicCount,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              primary: false,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width < 500 ? 2 :6,
              ),
              itemBuilder: (BuildContext context, int index){
                return 
                 GestureDetector(
                      onTap: (){
                      topics[index]['publish'] == 1? 
                      Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => MultipleBody(uid:widget.uid,topic: topics[index]['topic_name'], level: gradeLevel)),)
                      : print('lock');
                      },
                      
                      child: Container(
                        margin: EdgeInsets.only(left:30,right: 30,top:10,bottom:20),
                        width: double.infinity,
                        height: 100.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(gradeLevel == 2 && topics[index]['publish'] == 1? "${topics[index]['image']}" :
                            gradeLevel == 2 && topics[index]['publish'] == 0 ? "https://i.ibb.co/ftxGCFG/Pagtukoy-locked.png" : gradeLevel == 3 && topics[index]['publish'] == 1 ? "${topics[index]['image']}"
                              : gradeLevel == 3 && topics[index]['publish'] == 0 ? "https://i.ibb.co/2n6qW8X/kasarian-locked.png": "https://i.ibb.co/gghzqTq/mamyalung-logo.png"),
                          fit: BoxFit.cover
                          ),
                          color: white,
                          borderRadius: BorderRadius.circular(20.0),
                          boxShadow: [
                            BoxShadow(
                              color: black.withOpacity(0.5),spreadRadius: 5,
                              blurRadius: 7,offset:Offset(2, 5)
                            )
                          ]
                        ),
                        child: Padding(padding: EdgeInsets.only(top: 10),
                        child: topics[index]['publish'] == 1?  Text(
                          '${topics[index]['topic_name']}',style:TextStyle(fontFamily: 'Bubble',fontSize: 30), textAlign: TextAlign.center,)
                           : Text('')
                          )
                         
                      ),);

              }
            );
          }
        ),
      ],
    );
  }
}

