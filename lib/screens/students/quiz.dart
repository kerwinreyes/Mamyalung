
import 'dart:html';

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
  @override
  Widget build(BuildContext context) {
    
    return Container(color: powderblue.withOpacity(0.5),
      child: GridView.count(
      
      crossAxisCount: 2,
      padding: EdgeInsets.only(top: 25),
      children: [
        //Pagpapakilala
        
        
        //FlashCards
        GestureDetector(
        
        onTap: (){
        Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => TopicOne(uid:widget.uid)),);
        },
        child: Container(
          margin: EdgeInsets.only(left:30,right: 30,top:10,bottom:20),
          width: double.infinity,
          height: 100.0,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage("https://i.ibb.co/kVT8hHn/Artboard-1flashcards.png"),
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
          child: Text('')
        ),),
        //Magagalang na Salita
        GestureDetector(
        onTap: (){
           Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => TopicTwo(uid: widget.uid),
        ),
      );
        },
        child: Container(
          margin: EdgeInsets.only(left:30,right: 30,top:10,bottom:20),
          width: double.infinity,
          height: 100.0,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage("https://i.ibb.co/NYYc3nQ/Artboard-1quiz.png"),
              fit: BoxFit.cover
            ),
            color: white,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: black.withOpacity(0.5),spreadRadius: 5,
                blurRadius: 7,offset:Offset(2, 5)
              )
            ]
          ),
          child: Text('')
        )),
        //Kakatni
        GestureDetector(
        onTap: (){
          Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => TopicThree(uid: widget.uid),
        ),
      );
        },
        child: Container(
          margin: EdgeInsets.only(left:30,right: 30,top:10,bottom:20),
          width: double.infinity,
          height: 100.0,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage("https://i.ibb.co/4T5ZHRW/Artboard-1badges.png"),
              fit: BoxFit.cover
            ),
            color: white,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: black.withOpacity(0.5),spreadRadius: 5,
                blurRadius: 7,offset:Offset(2, 5)
              )
            ]
          ),
          child: Text('')
        )),
        GestureDetector(
        onTap: (){
          print("Badges");
        },
        child:Container(
          margin: EdgeInsets.only(left:30,right: 30,top:10,bottom:20),
          width: double.infinity,
          height: 100.0,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage("https://i.ibb.co/5MVZzPt/Artboard-1leaderboard.png"),
              fit: BoxFit.cover
            ),
            color: white,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: black.withOpacity(0.5),spreadRadius: 5,
                blurRadius: 7,offset:Offset(2, 5)
              )
            ]
          ),
          child: Text(''))
        ),
      ],
      ),
    );
  }
}
