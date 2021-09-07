import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mamyalung/responsive.dart';
import 'package:mamyalung/screens/custom/badge_message.dart';
import '../../materials.dart';
import 'package:mamyalung/widgets/buttons.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'homepage.dart';

class TopicOne extends StatefulWidget {
  final String? uid;
  final int gradeLevel;
  const TopicOne({ Key? key, required this.uid, required this.gradeLevel }) : super(key: key);

  @override
  _TopicOneState createState() => _TopicOneState();
}


class _TopicOneState extends State<TopicOne> {

  String topic = '';
  int gradeLevel = 0;
  String isUnlocked = "isUnlocked2";
  
  @override
  void initState() { 
    super.initState();
    gradeLevel = widget.gradeLevel;
  }
  
  @override
  Widget build(BuildContext context) {
    if(gradeLevel == 2){
    topic = 'assets/questions/Pagpapakilala_sa_Sarili.json';
    }
    else{
    topic = 'assets/questions/Pagpapakilala_sa_Sarili_G3.json';
    }
    return Scaffold(
      appBar: AppBar(title: Text("Topic"),
      backgroundColor: lightBlue,
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: (){
          Navigator.pushReplacement(
                            context,
                            //MaterialPageRoute(builder: (context) => BadgeMsg(uid: widget.uid)),\
                            MaterialPageRoute(builder: (context) => StudentHomePage(uid: widget.uid)),
                        );
        },
      ),
      ),
      backgroundColor: powderblue.withOpacity(0.5),
      body: Container(
        child: Responsive(
          desktop: Container(),
          tablet: Container(),
          mobile: MultipleBody(uid: widget.uid, topic: topic, unlock : isUnlocked)
        )
      )
    );
  }
}

class TopicTwo extends StatefulWidget {
  final String? uid;
  final int gradeLevel;
  const TopicTwo({ Key? key, required this.uid, required this.gradeLevel }) : super(key: key);

  @override
  _TopicTwoState createState() => _TopicTwoState();
}

class _TopicTwoState extends State<TopicTwo> {

  String topic = '';
  int gradeLevel = 0;
  String isUnlocked = "isUnlocked3";

  @override
  void initState() { 
    super.initState();
    gradeLevel = widget.gradeLevel;
  }
  @override
  Widget build(BuildContext context) {
    if(gradeLevel == 2){
    topic = 'assets/questions/Magagalang_na_Salita.json';
    }
    else{
    topic = 'assets/questions/Kasarian_ning_palagyu.json';
    }
    return Scaffold(
      appBar: AppBar(title: Text("Topic"), 
      backgroundColor: lightBlue,),
      backgroundColor: powderblue.withOpacity(0.5),
      body: Container(
        child: Responsive(
          desktop: Container(),
          tablet: Container(),
          mobile: MultipleBody(uid: widget.uid, topic: topic, unlock : isUnlocked)
        )
      )
    );
  }
}

class TopicThree extends StatefulWidget {
  final String? uid;
  final int gradeLevel;
  const TopicThree({ Key? key, required this.uid, required this.gradeLevel }) : super(key: key);

  @override
  _TopicThreeState createState() => _TopicThreeState();
}

class _TopicThreeState extends State<TopicThree> {
  String topic = '';
  
  int gradeLevel = 0;
  String isUnlocked = "isUnlocked4";
  

  @override
  void initState() { 
    super.initState();
    gradeLevel = widget.gradeLevel;
  }
  @override
  Widget build(BuildContext context) {
    if(gradeLevel == 2){
    topic = 'assets/questions/Kakatni_Makikatni.json';
    }
    else{
    topic = 'assets/questions/Panghalip_AkuIyaIka.json';
    }
    return Scaffold(
      appBar: AppBar(title: Text("Topic"),
      backgroundColor: lightBlue,),
      backgroundColor: powderblue.withOpacity(0.5),
      body: Container(
        child: Responsive(
          desktop: Container(),
          tablet: Container(),
          mobile: MultipleBody(uid: widget.uid, topic: topic, unlock : isUnlocked)
        )
      )
    );
  }
}

class TopicFour extends StatefulWidget {
  final String? uid;
  final int gradeLevel;
  const TopicFour({ Key? key, required this.uid, required this.gradeLevel }) : super(key: key);

  @override
  _TopicFourState createState() => _TopicFourState();
}

class _TopicFourState extends State<TopicFour> {

String topic = '';
int gradeLevel = 0;
String isUnlocked = "isUnlocked4";
  @override
  void initState() { 
    super.initState();
    gradeLevel = widget.gradeLevel;
  }
  @override
  Widget build(BuildContext context) {
    if(gradeLevel == 2){
    topic = 'assets/questions/Pagpapantig.json';
    }
    else{
    topic = 'assets/questions/Salitang_Papakit_Galo.json';
    }
    return Scaffold(
      appBar: AppBar(title: Text("Topic"),
      backgroundColor: lightBlue,),
      backgroundColor: powderblue.withOpacity(0.5),
      body: Container(
        child: Responsive(
          desktop: Container(),
          tablet: Container(),
          mobile: MultipleBody(uid: widget.uid, topic: topic, unlock: isUnlocked)
        )
      )
    );
  }
}
  
class MultipleBody extends StatefulWidget {
  final String topic;
  final String? uid;
  final String unlock;
  
  const MultipleBody({ Key? key, required this.uid, required this.topic, required this.unlock }) : super(key: key);
  
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

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  void read(){
    FirebaseFirestore.instance
    .collection('users')
    .where('uid',isEqualTo: widget.uid)
    .get()
    .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
      setState(() {
        score = int.parse(doc['points']);
        badgeCount = doc['badge_count'];
      });
    });
  });
  

  }
  Future<void> updateUser() {
  return users
    .doc('${widget.uid}')
    .update({'points': '$score', widget.unlock : 1})
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

  @override
  void initState() { 
    super.initState();
    read();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
          child: Center(
            // Use future builder and DefaultAssetBundle to load the local JSON file
            child: FutureBuilder(
                future: DefaultAssetBundle
                    .of(context)
                    .loadString('${widget.topic}'),
                builder: (context, snapshot) {

                  if(snapshot.hasError){
                    print('error');
                  }
                  if(snapshot.hasData){
                   
                  // Decode the JSON
                  var data = json.decode(snapshot.data.toString());
                  return Container(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,

            children: <Widget>[

              // Container(height: 400,
              // width: 500,
              // decoration: BoxDecoration(
              //   image: DecorationImage(image: AssetImage("images/png.png"),
              //   fit: BoxFit.fill ),
              //   ),
              // ),

              Padding(padding: EdgeInsets.only(top: 30)),
              Container(
                child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text("Question ${index + 1} / ${data.length}",style: TextStyle(color : Colors.brown , 
                    fontSize: 20,fontWeight: FontWeight.bold),),
                    Text("Score : $finalScore",style: TextStyle(color : Colors.brown , 
                    fontSize: 20,fontWeight: FontWeight.bold),),
                    
                 ],
               ),
              
              ),

             Padding(padding: EdgeInsets.only(top: 30)),
              
              Container(
                    decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(color: Color(0xFFF7C229))
                  ),
                  height: 90.0,
                  width: 400,
                     child: Column(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: <Widget>[
                         Padding(
                           padding: EdgeInsets.only(left: 20, right: 20),
                           child: 
                            AutoSizeText(data[index]['question'],textAlign: TextAlign.center,style: TextStyle(fontSize: 30.0,height: 1.5),maxLines: 2,maxFontSize: 18,
                         
                         )),
                       ],
                     ),             
                     
               ),

              Padding(padding: EdgeInsets.only(top: 30)),
                      
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                   
                button(first: isButtonPressed0 ? green : lightBlue, 
                     second: isButtonPressed0 ? green : primaryBlue, 
                     size: 15, 
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
                button(first: isButtonPressed1 ? green : lightBlue, 
                     second: isButtonPressed1 ? green : primaryBlue, 
                     size: 15, 
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
                 button(first: isButtonPressed2 ? green : lightBlue, 
                     second: isButtonPressed2 ? green : primaryBlue, 
                     size: 15, 
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
               button(first: isButtonPressed3 ? green : lightBlue, 
                     second: isButtonPressed3 ? green : primaryBlue, 
                     size: 15, 
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

              Padding(padding: EdgeInsets.only(top: 50,)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                SizedBox(height: 10),
                button(first: lightBlue, 
                     second: primaryBlue, 
                     size: 15, 
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
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => StudentHomePage(uid: widget.uid)),
                        );
                        if(badgeCount < 9){
                          Navigator.push(context,
                          MaterialPageRoute(builder: (context) => 
                          score >= 900 && badgeCount < 9 ? BadgeMsg(uid: widget.uid, path:  'https://i.ibb.co/mBt51bF/littleexplorer.png'):
                          score >= 800 && badgeCount < 8 ? BadgeMsg(uid: widget.uid, path:  'https://i.ibb.co/mBt51bF/littleexplorer.png'):
                          score >= 700 && badgeCount < 7 ? BadgeMsg(uid: widget.uid, path:  'https://i.ibb.co/mBt51bF/littleexplorer.png'):
                          score >= 600 && badgeCount < 6 ? BadgeMsg(uid: widget.uid, path:  'https://i.ibb.co/mBt51bF/littleexplorer.png'):
                          score >= 500 && badgeCount < 5 ? BadgeMsg(uid: widget.uid, path:  'https://i.ibb.co/mBt51bF/littleexplorer.png'):
                          score >= 400 && badgeCount < 4 ? BadgeMsg(uid: widget.uid, path:  'https://i.ibb.co/mBt51bF/littleexplorer.png'):
                          score >= 300 && badgeCount < 3 ? BadgeMsg(uid: widget.uid, path:  'https://i.ibb.co/NxMDq9F/royalty.png'):
                          score >= 200 && badgeCount < 2 ? BadgeMsg(uid: widget.uid, path:  'https://i.ibb.co/8dt2T8m/shiningbright.png'):
                          score >= 100 && badgeCount < 1 ? BadgeMsg(uid: widget.uid, path:  'https://i.ibb.co/mBt51bF/littleexplorer.png'):
                          StudentHomePage(uid: widget.uid)));
                          return;
                        }
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
      );
                } return CircularProgressIndicator();
                }),
        ));
     
  }
}