import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import '../../materials.dart';

class StudentCard extends StatefulWidget {
  final String? uid;
  const StudentCard({ Key? key, this.uid }) : super(key: key);

  @override
  _StudentCardState createState() => _StudentCardState();
}

class _StudentCardState extends State<StudentCard> {
  late int day;
  bool _Start = false;
  List flashcards=[];
  List others=[];
  var _flashcards=[];
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
           flashcards=doc['flashcards'];
           day = doc['day'];
           others = doc['other_flashcards'];
           for (int i = 0; i < flashcards.length; i++) {
	  _flashcards.add(
      Flashcard(
        choices: flashcards[i]['choices'], 
        level: flashcards[i]['level'], 
        question: flashcards[i]['question'], 
        answer: flashcards[i]['answer'])
    );}
      print(day);
      print(flashcards[0]['questions']);
        });
    });
  }
  bool _isVisible = false;
  
    void showToast() {
      setState(() {
        _isVisible = !_isVisible;
        _addflashcards();
      });
    }
 _addflashcards(){
    
}
  
  int _currentIndex = 0;
  @override
  void initState() {
    read();
    _addflashcards();
    print(flashcards);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  Column( 
      children:[
        Container(
        margin: EdgeInsets.only(left: 50, right:50, top: 50, bottom: 50),
        height: 250,
        width: 250,
        color: Colors.white,
        child: Neumorphic(
          
      child:Visibility(
        visible: _isVisible,
        
        child: FlipCard(
        front: FlashcardView(
                        text: 'Click the button to begin',
                      ),
                      back: FlashcardView(
                        text: 'Goodluck!')
        ), 
        replacement:FlipCard(
        front: FlashcardView(
          text: _flashcards[_currentIndex].question,
        ),
        back: FlashcardView(
          text: _flashcards[_currentIndex].choices[_flashcards[_currentIndex].answer],)
        ), 
      ),),),
      Center(child: ElevatedButton(
        
          onPressed: (){
              setState(() {
                _isVisible = !_isVisible;
                
              });
            },
           
          child: Text('Click to Begin'),
          
        ),),
      ]
      
    );
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
  final int level;

  Flashcard({required this.choices, required this.level, required this.question, required this.answer});
}