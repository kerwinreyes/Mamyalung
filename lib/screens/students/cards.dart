import 'package:flutter/material.dart';

import '../../materials.dart';

class StudentCard extends StatefulWidget {
  const StudentCard({ Key? key }) : super(key: key);

  @override
  _StudentCardState createState() => _StudentCardState();
}

class _StudentCardState extends State<StudentCard> {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      children: [
        //FlashCards
        GestureDetector(
        onTap: (){
          print("FlashCards");
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
                color: white.withOpacity(0.5),spreadRadius: 5,
                blurRadius: 7,offset:Offset(0, 3)
              )
            ]
          ),
          child: Text('')
        ),),
        //Games
        GestureDetector(
        onTap: (){
          print("Quiz Games");
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
                color: white.withOpacity(0.5),spreadRadius: 5,
                blurRadius: 7,offset:Offset(0, 3)
              )
            ]
          ),
          child: Text('')
        )),
        //Achievements
        GestureDetector(
        onTap: (){
          print("Badges");
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
                color: whitey.withOpacity(0.5),spreadRadius: 5,
                blurRadius: 7,offset:Offset(0, 3)
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
                color: whitey.withOpacity(0.5),spreadRadius: 5,
                blurRadius: 7,offset:Offset(0, 3)
              )
            ]
          ),
          child: Text(''))
        ),
      ],
      
    );
  }
}