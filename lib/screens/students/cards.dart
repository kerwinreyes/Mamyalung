import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mamyalung/widgets/buttons.dart';
import '../../materials.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:intl/intl.dart';





class StudentCard extends StatefulWidget {
  final String? uid;
  const StudentCard({ Key? key, this.uid }) : super(key: key);

  @override
  _StudentCardState createState() => _StudentCardState();
}

class _StudentCardState extends State<StudentCard> {
  
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var screenSizeW = screenSize.width;
    var screenSizeH = screenSize.height;
    return(
      Container(
        height: MediaQuery.of(context).size.height/1.5,
        width: MediaQuery.of(context).size.width*.5,
        color: Colors.blue,
        child: button(
          first: lightgreen, height: 50, second: green, 
          size: 12, text: 'Start the Flashcards', width: 150.0,onTap:(){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => QuizState(uid: widget.uid)));
          })

      )
    );
}}
 
class FlashcardView extends StatelessWidget {
  final String text;

  FlashcardView({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: 'Evil',fontSize: 25),
        ),
      ),
    );
  }
}
class Flashcard {
  final String question;
  final int questionID;
  final int answer;
  final List multiple_choice;
  int level;

  Flashcard({required this.multiple_choice,required this.questionID, required this.level,required this.question,required this.answer});
}
class QuizState extends StatefulWidget {
  final String? uid;
  const QuizState({ Key? key, this.uid }) : super(key: key);

  @override
  _QuizStateState createState() => _QuizStateState();
}

class _QuizStateState extends State<QuizState> {
  var now = new DateTime.now();
  var format = new DateFormat('dd');  
  List<int> qis=[];
  int grade_level=0;
  String lastgame='';
  int day=1;
  bool _Start = false;
  List flashcards=[];
  List _todayResults=[];
  List _todayFlashcards= [
  {'question':'Pindutan me ing kard bakanta akit me ing sagut' + '\n\n' + '(Click the card to see the answer)','answer':'Pindutan me ing next o ing prev a button' + '\n\n' +'(Click the next or prev button)'}];
  //Pabs Paedit Design
  //patranslate tagalo gand kapampangan
  List _tryflashcards=[
    {'questionID':0,
                  'question': 'Sagutan la ding susunud a kutang',
                  'translation': '(Answer the following questions)',
                  'level': 1,
                  'multiple_choice': ['Okay'],
                  'choice':['Okay','Cancel'],
                  'answer':0
                  },
                  ];
  bool _doneforday= false;
  var score=0;
  List others=[];
  
  Map<int, List> days = {
    1: [1,2], 2: [1,3], 3: [1,2],4: [1,4], 
    5: [1,2], 6: [1,3], 7: [1,2],8: [1], 
    9: [1,2], 10: [1,3], 11: [1,2],12: [1,5],
    13: [1,2,4], 14: [1,3], 15: [1,2],16: [1],  
    };
List finaflashcards=[];
List allflashcards=[];
Future<void>  read() async{
    print(widget.uid);
    await FirebaseFirestore.instance
    .collection('users')
    .where('uid',isEqualTo: widget.uid)
    .get()
    .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          grade_level=doc['grade_level'];
          day = doc['day'];
          lastgame=doc['lastplayed_flashcard'];
          for(int i =0; i<doc['flashcards'].length; i++){
            FirebaseFirestore.instance
            .collection('questions')
            .where('questionID',isEqualTo: doc['flashcards'][i]['questionID'])
            .get()
            .then((QuerySnapshot querySnapshot) {
                querySnapshot.docs.forEach((ques) {
                  qis.add(doc['flashcards'][i]['questionID']);

                allflashcards.add({
                  'level': doc['flashcards'][i]['level'],
                  'questionID': doc['flashcards'][i]['questionID'],
                  
                });
                  if(days[doc['day']]!.contains(doc['flashcards'][i]['level'])){
                  _tryflashcards.add({
                  'questionID':ques['questionID'],
                  'question': ques['question'],
                  'level': doc['flashcards'][i]['level'],
                  'multiple_choice':ques['multiple_choice'],
                  'choice':listShuffle(ques['multiple_choice'],ques['answer'],ques['multiple_choice'][ques['answer']]),
                  'translation':ques['translation'],
                  'answer':ques['answer']
                });
                _todayFlashcards.add({
                  'question':ques['question'],
                  'answer':ques['multiple_choice'][ques['answer']]
                });

                  }
            });
            
                });
          }
    });
        });
  setState(() {
    start_flashcard = !start_flashcard;
                    
  });
  await FirebaseFirestore.instance
    .collection('questions')
    .where('grade_level',isEqualTo: grade_level)
    .get()
    .then((QuerySnapshot queryQuestion){
      queryQuestion.docs.forEach((ques){
         _others.add(ques['questionID']);
    });
    });
  }
  //Update Flashcards
    CollectionReference users = FirebaseFirestore.instance.collection('users');
  List<int> _others=[];
Future<void> updateUser() {
  setState(() {
  lastgame = format.format(now);
    
  });
  if(day==16){
    setState((){
    day = 1;
    });
  }
  else{
    day+=1;
  }
  int cc=0;


  List finalresults = [];
  bool inCards = false;
    print(_others);
    print(qis);
    print(allflashcards);
    for(var cards in allflashcards){
      
          setState(() {
            inCards= false;
          });
      for(var today in _todayResults){
        if(cards['questionID']==today['questionID']){
          if(cards['level']!=today['level']){
          finalresults.add({
            'questionID': cards['questionID'],
            'level':today['level'],
          });
          setState(() {
            inCards= true;
          });
          break;
          }
        }
        
      }
      if(inCards==false){
      finalresults.add({
            'questionID': cards['questionID'],
            'level':cards['level'],
          });
      }
    }
    for(int i=0; i<_others.length; i++){
      if(!qis.contains(_others[i])){
          finalresults.add({
            'questionID': _others[i],
            'level':1,
          });
          qis.add(_others[i]);
      cc+=1;
      if(cc>=3){
      break;
      }  
    }}
  cc=0;
  return users
    .doc(widget.uid)
    .update({'flashcards': finalresults,'day':day,'lastplayed_flashcard': format.format(now)})
    .then((value) => print("User Updated"))
    .catchError((error) => print("Failed to update user: $error"));
}
 var counter=0;
  //Check if the student got the correct answer
  checkWin(String userChoice , BuildContext context )
  { 
  if(counter==0){

  }
  else{
  if(userChoice==_tryflashcards[counter]['multiple_choice'][_tryflashcards[counter]['answer']])
  { 
    print("correct");
     
     score= score+1;
    _todayResults.add({
       'questionID':_tryflashcards[counter]['questionID'],
       'level': _tryflashcards[counter]['level']+=1,
     }); 
    final snackbar = SnackBar(
      duration: Duration(milliseconds : 500), 
      backgroundColor: Colors.green,
      content: Text("Correct!"),);
    
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
     
 }
 else 
 {print("false");
        score = score+0;
    _todayResults.add({
       'questionID':_tryflashcards[counter]['questionID'],
       'level': 1,
     }); 
    final snackbar = SnackBar(
      duration: Duration(milliseconds : 500),
      backgroundColor: Colors.red,
      content: Text("Incorrect!"),
      );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
     
 }}
    setState(() {
 
   if(counter<_tryflashcards.length-1)
   {
     counter = counter +1;
     
   }
   else{
         counter=0;
     
      updateUser();
       setState(() {
         _doneforday = !_doneforday;
         score=0;
         day=0;
       });
         read();
   }
  });
} 
Future<void> _readUser() async{
  var data = await FirebaseFirestore.instance
    .collection('users')
    .where('uid',isEqualTo: widget.uid)
    .get();
}

List listShuffle (List choices, int ans, String answer){
  List a =[];
  setState(() {
    choices.removeAt(ans);
    choices.shuffle();
    a = [answer,choices[0]];
    a.shuffle();
  });
 return a;
}
  int _currentIndex = 0;
  bool start_flashcard=true;
  @override
  void initState() {
    super.initState();
    read();
    _readUser();
  }
  @override
  Widget build(BuildContext context) {
        var screenSize = MediaQuery.of(context).size;
    var screenSizeW = screenSize.width;
    var screenSizeH = screenSize.height;
    return  Center(child: Stack(children: [
          Container(
            //constraints: BoxConstraints.expand(),
            width: screenSizeW,
            height: screenSizeH,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: screenSizeW <= 649
                      ? NetworkImage("https://i.ibb.co/YBzRfyT/background.png")
                      : NetworkImage(
                          "https://i.ibb.co/rMgVF9T/background.png"),
                  fit: BoxFit.fill),
            ),
          ),
          format.format(now) == lastgame? 
        Column(children: [
          Container(
            child:Container(margin: EdgeInsets.only(left: 50, right:50, top: 120, bottom: 20),
        width: screenSizeW <= 649 ? 300 : 400,
        height: screenSizeW <= 649 ? 300 : 400,
            //Pabs Paedit Design
            //Eto yung sa FLipcard pag same date yung lastflashcard_played sa database natin sa day ngayon eto lilitaw
            child: Container(child: FlipCard(
              front: FlashcardView(
              text: _todayFlashcards[_currentIndex]['question'],
            ),
            back: FlashcardView(
              text: _todayFlashcards[_currentIndex]['answer'],)
            )))),
          Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  OutlinedButton.icon(
                      onPressed: showPreviousCard,
                      style:  ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.white.withOpacity(0.8)),),
                      icon: Icon(Icons.chevron_left),
                      label: Text('Prev', style: TextStyle(fontFamily: 'Evil', fontSize: 25),)),
                  OutlinedButton.icon(
                      onPressed: showNextCard,
                      style:  ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.white.withOpacity(0.8)),),
                      icon: Icon(Icons.chevron_right),
                      label: Text('Next', style: TextStyle(fontFamily: 'Evil', fontSize: 25),)),
                ],
              )
        ],)
        :
        //Pabs Paedit Design
            //Eto yung sa pagnagsasagot
            //pag hindi same date yung lastflashcard_played sa database natin sa day ngayon eto lilitaw
          
         Center(child: Column( 
           
      children:[
        Container(margin: EdgeInsets.only(left: 50, right:50, top: 50, bottom: 20),
        width: screenSizeW <= 649 ? 300 : 400,
        height: screenSizeW <= 649 ? 300 : 400,
        child: Container(child: Container(
          child: FlashcardView(
          text: _tryflashcards[counter]['question'] + '\n\n' + _tryflashcards[counter]['translation'],
          
        ),
        ),
        ),),
        
        Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                
                ElevatedButton(onPressed:()=> checkWin(_tryflashcards[counter]['choice'][0], context),
               style: ElevatedButton.styleFrom(
              elevation: 5,
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20))),
          child: Ink(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [orange, orange]),
                borderRadius: BorderRadius.circular(20)),
            child: Container(
              width: MediaQuery.of(context).size.width/1.5,
              height: 50,
              alignment: Alignment.center,
              child: AutoSizeText( 
              _tryflashcards[counter]['choice'][0], presetFontSizes: [30, 20],
                style: 
                      TextStyle(color: Colors.white, fontSize: 30, fontFamily: 'Evil'),
                    
              ),
            ),  
          )
                ),
                
                SizedBox(height: 15,),
                _tryflashcards[counter]['choice'][1]!= 'Cancel'?ElevatedButton(onPressed:()=> checkWin(_tryflashcards[counter]['choice'][1], context),

               style: ElevatedButton.styleFrom(
              elevation: 5,
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20))),
          child: Ink(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [orange, orange]),
                borderRadius: BorderRadius.circular(20)),
            child: Container(
              width: MediaQuery.of(context).size.width/1.5,
              height: 50,
              alignment: Alignment.center,
              child: AutoSizeText(
               _tryflashcards[counter]['choice'][1], presetFontSizes: [30,20],
                style:  TextStyle(color: Colors.white, fontSize: 30, fontFamily: 'Evil'),
                    
              ),
            ),
          )) : Container(),

                   
       ])
      
      ]))]));
  }
    void showNextCard() {
    setState(() {
      _currentIndex =
          (_currentIndex + 1 < _todayFlashcards.length) ? _currentIndex + 1 : 0;
    });
  }

  void showPreviousCard() {
    setState(() {
      _currentIndex =
          (_currentIndex - 1 >= 0) ? _currentIndex - 1 : _todayFlashcards.length - 1;
    });
  }
}