
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
  int isUnlocked1 = 0;
  int isUnlocked2 = 0;
  int isUnlocked3 = 0;
  int isUnlocked4 = 0;

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  void read(){
    FirebaseFirestore.instance
    .collection('users')
    .where('uid',isEqualTo: widget.uid)
    .get()
    .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
      setState(() {
        gradeLevel = doc['grade_level'];
        isUnlocked1 = doc['isUnlocked1'];
        isUnlocked2 = doc['isUnlocked2'];
        isUnlocked3 = doc['isUnlocked3'];
        isUnlocked4 = doc['isUnlocked4'];
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
        Image(image: NetworkImage('https://i.ibb.co/YBzRfyT/background.png'),height: MediaQuery.of(context).size.height, width: MediaQuery.of(context).size.width,fit: BoxFit.fill,),
      GridView.count(
      
      crossAxisCount: 2,
      padding: EdgeInsets.only(top:MediaQuery.of(context).size.height * .15),
      children: [
        //Pagpapakilala

        GestureDetector(
        
        onTap: (){
        Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => TopicOne(uid:widget.uid, gradeLevel: gradeLevel)),);
        },
        child: Container(
          margin: EdgeInsets.only(left:30,right: 30,top:10,bottom:20),
          width: double.infinity,
          height: 100.0,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(gradeLevel == 2 && isUnlocked1 == 1 ? "https://i.ibb.co/yysdY1s/Pagpapakilala-g2.png" :
               gradeLevel == 2 && isUnlocked1 == 0 ? "https://i.ibb.co/ftxGCFG/Pagtukoy-locked.png" : gradeLevel == 3 && isUnlocked1== 1 ? "https://i.ibb.co/yysdY1s/Pagpapakilala-g2.png"
                : gradeLevel == 3 && isUnlocked1 == 0 ? "https://i.ibb.co/2n6qW8X/kasarian-locked.png": "https://i.ibb.co/gghzqTq/mamyalung-logo.png"),
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
          if(isUnlocked2 == 1){
             Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => TopicTwo(uid: widget.uid,gradeLevel :gradeLevel),
        ),
      );
          }

          
        },
        child: Container(
          margin: EdgeInsets.only(left:30,right: 30,top:10,bottom:20),
          width: double.infinity,
          height: 100.0,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(gradeLevel == 2 && isUnlocked2 == 1 ? "https://i.ibb.co/GVDRRfZ/Pagtukoy1.png" :
               gradeLevel == 2 && isUnlocked2 == 0 ? "https://i.ibb.co/ftxGCFG/Pagtukoy-locked.png" : gradeLevel == 3 && isUnlocked2 == 1 ? "https://i.ibb.co/SvpBVSk/kasarian.png"
                : gradeLevel == 3 && isUnlocked2 == 0 ? "https://i.ibb.co/2n6qW8X/kasarian-locked.png": "https://i.ibb.co/gghzqTq/mamyalung-logo.png"),
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
          if(isUnlocked3 == 1){
            Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => TopicThree(uid: widget.uid,gradeLevel :gradeLevel),
        ),
      );
          }
          else{
             
          }
         
        },
        child: Container(
          margin: EdgeInsets.only(left:30,right: 30,top:20,bottom:20),
          width: double.infinity,
          height: 100.0,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(gradeLevel == 2 && isUnlocked3 == 1 ? "https://i.ibb.co/cQSCdbQ/kakatni.png" :
               gradeLevel == 2 && isUnlocked3 == 0 ? "https://i.ibb.co/nwf99Dw/kakatni-locked.png" : gradeLevel == 3 && isUnlocked3 == 1 ? "https://i.ibb.co/PzKZHd1/panghalip.png"
               : gradeLevel == 3 && isUnlocked3 == 0 ? "https://i.ibb.co/rxmg8jh/panghalip-locked.png": "https://i.ibb.co/gghzqTq/mamyalung-logo.png"),
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
          if(isUnlocked4 == 1){
            Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => TopicFour(uid: widget.uid,gradeLevel :gradeLevel),
        ),
      );
          }
          
        },
        child:Container(
          margin: EdgeInsets.only(left:30,right: 30,top:20,bottom:20),
          width: double.infinity,
          height: 100.0,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(gradeLevel == 2 && isUnlocked4 == 1 ? "https://i.ibb.co/2ddqmbw/pagpapantig.png" :
               gradeLevel == 2 && isUnlocked4 == 0 ? "https://i.ibb.co/DRpDzhV/pagpapantig-locked.png" :gradeLevel == 3 && isUnlocked4 == 1 ? "https://i.ibb.co/D9qd1Vt/papakitgalo.png"
                : gradeLevel == 3 && isUnlocked4 == 0 ? "https://i.ibb.co/02GVH7r/papakitgalo-locked.png": "https://i.ibb.co/gghzqTq/mamyalung-logo.png"),
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
      ],
    );
  }
}
