import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mamyalung/responsive.dart';
import 'package:mamyalung/screens/custom/badge_message.dart';
import 'package:mamyalung/screens/custom/custom.dart';
import '../../materials.dart';
import 'package:mamyalung/widgets/buttons.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'homepage.dart';

class MultipleBody extends StatefulWidget {
  final String topic;
  final int level;
  final String? uid;


  const MultipleBody({ Key? key, required this.uid, required this.topic, required this.level}) : super(key: key);
  
  @override
  _MultipleBodyState createState() => _MultipleBodyState();
}

class _MultipleBodyState extends State<MultipleBody> {
  int finalScore = 0;
  int index = 0;
  int score = 0;
  int badgeCount = 0;
  String next = "Next";
  bool answer = false;
  bool isButtonPressed0 = false , isButtonPressed1 = false,isButtonPressed2 = false,isButtonPressed3 = false;
  List data =[];
  CollectionReference users = FirebaseFirestore.instance.collection('users');

   

  void read(){
    FirebaseFirestore.instance
    .collection('users')
    .where('uid',isEqualTo: widget.uid)
    .get()
    .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
      setState(() {
        score = doc['points'];
        badgeCount = doc['badge_count'];
      });
    });
  });
  

  }
  Future<void> updateUser() {
  return users
    .doc('${widget.uid}')
    .update({
      'points':score.toInt()})
    .then((value) => print("User Updated"))
    .catchError((error) => print("Failed to update user: $error"));
}

falsify(){
  setState(() {
    isButtonPressed0 = false;  
          isButtonPressed1 = false;
          isButtonPressed2 = false;
          isButtonPressed3 = false;
          answer = false;
    
  });

 }
 check(index, length){
 
  if(index + 1 == length){
       setState(() {
         next = "Submit";
       });
    }

 }
 pressed(){
      final snackbar = SnackBar(
      duration: Duration(milliseconds : 500),
      backgroundColor: Colors.orange,
      content: Text("Please choose an answer!"),);
    ScaffoldMessenger.of(context).showSnackBar(snackbar);

 }
 correct(bool check){

   if(check){
     finalScore += 10;
     final snackbar = SnackBar(
      duration: Duration(milliseconds : 500),
      backgroundColor: Colors.green,
      content: Text("Correct!"),);
      ScaffoldMessenger.of(context).showSnackBar(snackbar);


   }

   else{
     final snackbar = SnackBar(
      duration: Duration(milliseconds : 500),
      backgroundColor: Colors.red,
      content: Text("Wrong!"),);
    ScaffoldMessenger.of(context).showSnackBar(snackbar);

   }
setState(() {
      index += 1;
    });
   
 }
void get(){
    FirebaseFirestore.instance
    .collection('questions')
    .where('topic', isEqualTo: '${widget.topic}'.trimRight())
    .where('grade_level', isEqualTo: widget.level)
    .get()
    .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          setState(() {
            data.add(doc.data());
            
          });
        });
    }); 
  }

  
  @override
  void initState() { 
    super.initState();
    get();
    read();
 
  }
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var screenSizeW = screenSize.width;
    var screenSizeH = screenSize.height;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
       shadowColor: primaryBlue,
       backgroundColor: Colors.white.withOpacity(0.2),
        title: Text("${widget.topic}", textAlign: TextAlign.center,style: TextStyle(fontFamily: 'Sans', color: black, fontSize: 25),),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: black),
          onPressed: (){
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => StudentHomePage(uid: widget.uid)));
            },
        ),
      ),
      body: 

      Stack(
      children: [
        Container(
          decoration: BoxDecoration(
          image: DecorationImage(
            image: screenSizeW <= 649 ? NetworkImage('https://i.ibb.co/k4SWgzy/newmobilebg.png') : NetworkImage("https://i.ibb.co/h18BM5q/background.png"),
            fit: BoxFit.fill),
        ),),
        SingleChildScrollView(
          child: data.isEmpty ? CircularProgressIndicator() : Center(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(padding: EdgeInsets.only(top: 70)),
              Container(
                child: Column(
                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Pilinan ing ustung Sagut",style: TextStyle(color : Colors.brown , 
                        fontSize: 20,fontWeight: FontWeight.bold, fontFamily: 'Sans'),),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("Question ${index + 1} / ${data.length}",style: TextStyle(color : Colors.brown , 
                        fontSize: 25,fontWeight: FontWeight.bold, fontFamily: 'Sans'),),
                        Text("Score : $finalScore",style: TextStyle(color : Colors.brown , 
                        fontSize: 25,fontWeight: FontWeight.bold, fontFamily: 'Sans'),), 
                      ],
                    )
                 ],
               ),
              
              ),

             Padding(padding: EdgeInsets.only(top: 30)),
              
              Container(
                    decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(color: Color(0xFFF7C229))
                  ),
                  height: 165.0,
                  width: 400,
                     child: Column(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: <Widget>[
                         Padding(
                           padding: EdgeInsets.only(left: 20, right: 20),
                           child: 
                            AutoSizeText("${data[index]['question']}\n\n (${data[index]['translation']})",textAlign: TextAlign.center,style: TextStyle(fontSize: 28.0, fontFamily: 'Sans'),maxLines: 5,maxFontSize: 25,
                         
                         )),
                       ],
                     ),             
                     
               ),
              
              Padding(padding: EdgeInsets.only(top: 30)),
                    
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                   
                button(first: isButtonPressed0 ? green : orange, 
                     second: isButtonPressed0? green : orange, 
                     size: 30, 
                     height: 50, 
                     width: MediaQuery.of(context).size.width/1.5, 
                     text:"${data[index]['multiple_choice'][0]}",
                     onTap: (){
                       
                       setState(() {
                        isButtonPressed0 = true;  
                        isButtonPressed1 = false;
                        isButtonPressed2 = false;
                        isButtonPressed3 = false;
                       });
                       if(data[index]['multiple_choice'][0] == data[index]['multiple_choice'][data[index]['answer']]){
                         answer = true;
                       }
                       
                     }
                    ),
                 SizedBox(height: 10),
                button(first: isButtonPressed1 ? green : orange, 
                     second: isButtonPressed1 ? green : orange, 
                     size: 30, 
                     width: MediaQuery.of(context).size.width/1.5,
                     height: 50, 
                     text:"${data[index]['multiple_choice'][1]}",
                     onTap: (){
                       setState(() {
                        isButtonPressed0 = false;  
                        isButtonPressed1 = true;
                        isButtonPressed2 = false;
                        isButtonPressed3 = false;
                       });
                       if(data[index]['multiple_choice'][1] == data[index]['multiple_choice'][data[index]['answer']]){
                         answer = true;
                       }
                       
                     }
                    ),
                ],
              ),
              
              
              
                      
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                SizedBox(height: 10),
                 button(first: isButtonPressed2 ? green : orange, 
                     second: isButtonPressed2 ? green : orange, 
                     size: 30, 
                     width: MediaQuery.of(context).size.width/1.5,
                     height: 50,
                     text:"${data[index]['multiple_choice'][2]}",
                     onTap: (){
                       setState(() {
                        isButtonPressed0 = false;  
                        isButtonPressed1 = false;
                        isButtonPressed2 = true;
                        isButtonPressed3 = false;
                       });
                       if(data[index]['multiple_choice'][2] == data[index]['multiple_choice'][data[index]['answer']]){
                         answer = true;
                       }
                       
                     }
                    ),

                SizedBox(height: 10),
               button(first: isButtonPressed3 ? green : orange, 
                     second: isButtonPressed3 ? green : orange, 

                     size: 30, 
                     width: MediaQuery.of(context).size.width/1.5,
                     height: 50, 
                     text:"${data[index]['multiple_choice'][3]}",
                     onTap: (){
                       setState(() {
                        isButtonPressed0 = false;  
                        isButtonPressed1 = false;
                        isButtonPressed2 = false;
                        isButtonPressed3 = true;
                       });
                       if(data[index]['multiple_choice'][3] == data[index]['multiple_choice'][data[index]['answer']]){
                         answer = true;
                       }
                     }
                    ),
                ],
              ),

              Padding(padding: EdgeInsets.only(top: 40,)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                SizedBox(height: 10),
                button(first:  orange, 
                  second: orange,
                     size: 25, 
                     width: MediaQuery.of(context).size.width/1.5,
                     height: 50, 
                     text:"$next",
                     onTap: (){
                      if(isButtonPressed0 == false && isButtonPressed1 == false && isButtonPressed2 == false && isButtonPressed3 == false){
                        pressed();
                        return;
                      }
                      else if(next == "Submit"){
                          
                          index -= 1;
                          correct(answer);
                          score += finalScore;
                          updateUser();
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => ScoreDialog(
                              title: "${widget.topic}",
                               description:
                                "You have earned a Score of $finalScore",
                                 buttonText:
                                  "Okay",
                                   path: "https://i.ibb.co/MM7kwtm/newbadge.png",
                                   uid: widget.uid
                                   )
                          
                          );
                          
                        if(badgeCount < 6){
                          
                          score >= 1200 && badgeCount < 6 ? Navigator.push(context,
                          MaterialPageRoute(builder: (context) => BadgeMsg(uid: widget.uid, path: 'https://i.ibb.co/4mt3K9c/royalty.png', badgename: "Royalty"))):
                          score >= 900 && badgeCount < 5 ? Navigator.push(context,
                          MaterialPageRoute(builder: (context) => BadgeMsg(uid: widget.uid, path:  'https://i.ibb.co/8dt2T8m/shiningbright.png', badgename: "Shining Bright"))):
                          score >= 750 && badgeCount < 4 ? Navigator.push(context,
                          MaterialPageRoute(builder: (context) => BadgeMsg(uid: widget.uid, path:  'https://i.ibb.co/kSTB0CN/on-fire.png', badgename: "On Fire"))):
                          score >= 500 && badgeCount < 3 ? Navigator.push(context,
                          MaterialPageRoute(builder: (context) => BadgeMsg(uid: widget.uid, path:  'https://i.ibb.co/TK6PsmV/fastlearner.png', badgename: "Fast Learner"))):
                          score >= 300 && badgeCount < 2 ? Navigator.push(context,
                          MaterialPageRoute(builder: (context) => BadgeMsg(uid: widget.uid, path:  'https://i.ibb.co/jZXzvBk/little-Explorer.png', badgename: "Little Explorer"))):
                          score >= 100 && badgeCount < 1 ? Navigator.push(context,
                          MaterialPageRoute(builder: (context) => BadgeMsg(uid: widget.uid, path:  'https://i.ibb.co/njf8Ndj/steady.png', badgename: "Slow and Steady"))):
                          print("End of Condition");

                        }
                        return;
                      }
                      correct(answer);
                      check(index, data.length);
                      falsify();
                      
                    }
                  ),
                ],
              ),
             ],
          ),
      ))])
    );
  }
}
