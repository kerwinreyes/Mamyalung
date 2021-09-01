import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mamyalung/widgets/buttons.dart';
import '../../materials.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';





class StudentCard extends StatefulWidget {
  final String? uid;
  const StudentCard({ Key? key, this.uid }) : super(key: key);

  @override
  _StudentCardState createState() => _StudentCardState();
}

class _StudentCardState extends State<StudentCard> {
  
  @override
  Widget build(BuildContext context) {
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
        ),
      ),
    );
  }
}
class Flashcard {
  final String question;
  final int answer;
  final List choices;
  int level;

  Flashcard({required this.choices,required this.level,required this.question,required this.answer});
}
class QuizState extends StatefulWidget {
  final String? uid;
  const QuizState({ Key? key, this.uid }) : super(key: key);

  @override
  _QuizStateState createState() => _QuizStateState();
}

class _QuizStateState extends State<QuizState> {
  late int day;
  bool _Start = false;
  List flashcards=[];
  bool _doneforday= false;
  var score=0;
  List others=[];
  List<Flashcard> _flashcards=[
  ];
  Map<int, List> days = {
    1: [2,1], 2: [3,1], 3: [2,1],4: [4,1], 
    5: [2,1], 6: [3,1], 7: [2,1],8: [1], 
    9: [2,1], 10: [3,1], 11: [2,1],12: [5,1],
    13: [4,2,1], 14: [3,1], 15: [2,1],16: [1],  
    };
  void read(){
    print(widget.uid);
    FirebaseFirestore.instance
    .collection('users')
    .where('uid',isEqualTo: widget.uid)
    .get()
    .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
           
      setState(() {
        
           flashcards=doc['flashcards'];
           day = doc['day'];
           others = doc['other_flashcards'];
      for (int i = 0; i < flashcards.length; i++) {
        if(days[day]!.contains(flashcards[i]['level'])){
        _flashcards.add(
              Flashcard(
                choices:flashcards[i]['choices'], 
                level:flashcards[i]['level'], 
                question:flashcards[i]['question'], 
                answer: flashcards[i]['answer'])
            );
        }
	  }
    });
        });
    });
  }
    CollectionReference users = FirebaseFirestore.instance.collection('users');

Future<void> updateUser() {
  if(day==16){
    setState((){
    day = 1;
    });
  }
  else{
    day+=1;
  }
  return users
    .doc(widget.uid)
    .update({'flashcards': flashcards,'day':day})
    .then((value) => print("User Updated"))
    .catchError((error) => print("Failed to update user: $error"));
}
 var counter=0;
  checkWin(String userChoice , BuildContext context )
  { 
 print(_flashcards.length);

  if(userChoice==_flashcards[counter].choices[_flashcards[counter].answer])
  { 
    print("correct");
     
     score= score+1;
    final snackbar = SnackBar(
      duration: Duration(milliseconds : 500),
      backgroundColor: Colors.green,
      content: Text("Correct!"),);
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
     flashcards[counter]['level'] = flashcards[counter]['level']+ 1; 
 }
 else 
 {print("false");
        score = score+0;
    final snackbar = SnackBar(
      duration: Duration(milliseconds : 500),
      backgroundColor: Colors.red,
      content: Text("Incorrect!"),
      );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
     flashcards[counter]['level'] =  1; 
 }
    setState(() {
 
   if(counter<_flashcards.length-1)
   {
     counter = counter +1;
     
   }
   else if(counter==_flashcards.length-1){
     
      updateUser();
       setState(() {
         _doneforday = !_doneforday;
         counter=0;
         score=0;
         day=0;
         flashcards=[];
         _flashcards=[];
       });
         read();
        
   }
 print(counter);
    
  });
  
  
} 
  int _currentIndex = 0;
  @override
  void initState() {
    read();
    
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  _doneforday == true ? Container(
            child: button(first: lightBlue, second: primaryBlue, size: 18, height: 50, width: 250, text: 'Continue to next day',
            onTap: (){
              setState(() {
                _doneforday = !_doneforday;
              }); 
            } 
            )
        ): flashcards.isEmpty?
        CircularProgressIndicator(
          backgroundColor: Colors.cyanAccent,
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
        )
        :Column( 
      children:[
        Container(margin: EdgeInsets.only(left: 50, right:50, top: 50, bottom: 20),
        width: 250,
        child: Neumorphic(child: FlipCard(
          front: FlashcardView(
          text: _flashcards[counter].question,
        ),
        back: FlashcardView(
          text: _flashcards[counter].choices[_flashcards[counter].answer],)
        ),
        ),),
        
        Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                
                ElevatedButton(onPressed:()=> checkWin(_flashcards[counter].choices[0], context),
               style: ElevatedButton.styleFrom(
              elevation: 5,
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20))),
          child: Ink(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [lightBlue, primaryBlue]),
                borderRadius: BorderRadius.circular(20)),
            child: Container(
              width: MediaQuery.of(context).size.width/1.5,
              height: 50,
              alignment: Alignment.center,
              child: Text(
               _flashcards[counter].choices[0],
                style: GoogleFonts.lato(
                      textStyle: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
              ),
            ),
          )
                ),
                SizedBox(height: 5,),
                ElevatedButton(onPressed:()=> checkWin(_flashcards[counter].choices[1], context),

               style: ElevatedButton.styleFrom(
              elevation: 5,
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20))),
          child: Ink(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [lightBlue, primaryBlue]),
                borderRadius: BorderRadius.circular(20)),
            child: Container(
              width: MediaQuery.of(context).size.width/1.5,
              height: 50,
              alignment: Alignment.center,
              child: Text(
               _flashcards[counter].choices[1],
                style: GoogleFonts.lato(
                      textStyle: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
              ),
            ),
          ))

                   
       ])
      
      ]);
  }
void showNextCard() {
    setState(() {
      _currentIndex =
          (_currentIndex + 1 < _flashcards.length) ? _currentIndex + 1 : 0;
    });
  }

  void showPreviousCard() {
    setState(() {
      _currentIndex =
          (_currentIndex - 1 >= 0) ? _currentIndex - 1 : _flashcards.length - 1;
    });
  }
}
