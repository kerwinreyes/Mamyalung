import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mamyalung/screens/custom/badges.dart';
import 'package:mamyalung/responsive.dart';
import 'package:mamyalung/utils/validator.dart';
import '../../loginpage.dart';
import '../../materials.dart';
import 'dart:math';


class Questions extends StatefulWidget {
  final String? uid;
  const Questions({ Key? key, required this.uid }) : super(key: key);

  @override
  _QuestionsState createState() => _QuestionsState();
}

class _QuestionsState extends State<Questions> {
  @override
  Widget build(BuildContext context) {
    return QuestionsDashboard(uid: widget.uid);
  }
}

class QuestionsDashboard extends StatefulWidget {
  final String? uid;
  const QuestionsDashboard({ Key? key,required this.uid }) : super(key: key);

  @override
  _QuestionsDashboardState createState() => _QuestionsDashboardState();
}

class _QuestionsDashboardState extends State<QuestionsDashboard> {
  
  int gradeLevel = 0;
  String _filter='';
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('questions')
  // .orderBy("grade_level", descending: false)
  // .orderBy("questionID", descending: false)
  .snapshots();

  // final Stream<QuerySnapshot> _grade2Stream = FirebaseFirestore.instance.collection('questions')
  // .where("grade_level", isEqualTo: 2)
  // .orderBy("questionID", descending: false)
  // .snapshots();

  // final Stream<QuerySnapshot> _grade3Stream = FirebaseFirestore.instance.collection('questions')
  // .where("grade_level", isEqualTo: 3)
  // .orderBy("questionID", descending: false)
  // .snapshots();
final _formKey = GlobalKey<FormState>();

TextEditingController _questionController = new TextEditingController();
TextEditingController _topicControlller = new TextEditingController();
TextEditingController _searchController = new TextEditingController();
TextEditingController _ans1Controller = new TextEditingController();
TextEditingController _ans2Controller = new TextEditingController();
TextEditingController _ans3Controller = new TextEditingController();
TextEditingController _ans4Controller = new TextEditingController();
TextEditingController _correctAnsController = new TextEditingController();
TextEditingController _translateController = new TextEditingController();

String _questionTopic = '';
String _updateID='';
String _question = '';
String _answer1 = '';
String _answer2 = '';
String _answer3 = '';
String _answer4 = '';
int _grlevel =2;
bool _isProcessing=false;
String _correctAnswer = '';
List<String> answerlist =['Answer 1','Answer 2','Answer 3','Answer 4'];
int _ans = 1;
int? _value = 0;
String? _topic = "Select a Topic";
CollectionReference question = FirebaseFirestore.instance.collection('questions');
_onSearchChanged(){

}

  int a =0;
  List _allResults=[];
Future<void> deleteUser(id) {
  
  return question
    .doc('$id')
    .delete()
    .then((value) => print("User Deleted"))
    .catchError((error) => print("Failed to delete user: $error"));
    
}
Future<void> updateQuestion(String id,String question,String topic, int ans, List choices, int level ) async{
  CollectionReference quess = FirebaseFirestore.instance.collection('questions');    
  
 return quess.doc(id)
                .update({
                  'question':question,
                  'topic': topic,
                  'answer': ans ,
                  'multiple_choice':choices,
                  'grade_level': level,

                })
                .then((value){
                  
            showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Message"),
              content: Text('Question Updated'),
              actions: [
                ElevatedButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            );
          });
                print("Question Updated");
                setState(() {
                _questionController.text = "";
                _ans1Controller.text = "";
                _ans2Controller.text = "";
                _ans3Controller.text = "";
                _ans4Controller.text="";
                });
                })
            .catchError((error) => print('failed'));

}
Future<void> deleteQuestion(String id) async{
  CollectionReference quess = FirebaseFirestore.instance.collection('questions');    
   return quess.doc(id)
                .delete()
                .then((value){
                  
            showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Message"),
              content: Text('Question Deleted'),
              actions: [
                ElevatedButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            );
          });
                print("Question Delete");
                })
            .catchError((error) => print('failed'));
}
Future<void> _createquestion() async{
  CollectionReference quess = FirebaseFirestore.instance.collection('questions');    
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
    .collection('questions')
    .get();
  setState(() {
  _allResults = querySnapshot.docs.map((doc) => doc['questionID']).toList();
    
  }); 
  var largest_value= _allResults[0];
   for (var i = 0; i < _allResults.length; i++) { 
     if (_allResults[i] > largest_value) {
    setState(() {
      largest_value = _allResults[i];
    });
    }
  }
  setState(() {
  largest_value+=1;
  });
   return quess.doc(largest_value.toString())
   .set({
     'questionID':largest_value,
     'answer': _ans,
     'translation': _translateController.text,
     'grade_level':_value,
     'multiple_choice':[_ans1Controller.text,_ans2Controller.text,_ans3Controller.text,_ans4Controller.text,],
     'question': _questionController.text,
     'topic': _topic,
   }).then((value){
            showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Message"),
              content: Text('Create Question Success'),
              actions: [
                ElevatedButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            );
          });
            print('success');
          })
          // ignore: invalid_return_type_for_catch_error
          .catchError((error) => print('failed'));
}
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        
        return Stack(children: [
          Image(image: NetworkImage('https://i.ibb.co/YBzRfyT/background.png'),height: MediaQuery.of(context).size.height, width: MediaQuery.of(context).size.width,fit: BoxFit.fill,),
          Container(
            //color: green,
            child: ListView(
              children: <Widget>[
            Column(
            children: [
              Padding(padding: EdgeInsets.fromLTRB(60, 10, 60, 0),
                child: Row(
                  children: [
                    Text(""),
                    Spacer(),
                    Text("")
                  ],
                )
              ),
              Container(
                //color: green,
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index){
                    DocumentSnapshot doc = snapshot.data!.docs[index];
                    return Padding(
                      padding: EdgeInsets.fromLTRB(10,7,10,0),
                      child: Card(
                        color: Colors.white.withOpacity(0.7),
                        child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          ListTile(
                            contentPadding: EdgeInsets.all(10),
                            leading: Icon(Icons.topic_outlined),
                            title: Text("Topic: ${snapshot.data!.docs[index]['topic']}",style: TextStyle(fontFamily: 'Sans'),),
                            subtitle: Text("Question: ${snapshot.data!.docs[index]['question']}", style: TextStyle(fontFamily: 'Evil', fontSize:20, color: black),),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              TextButton(
                                child: Text("Edit"),
                                onPressed: (){

                                  setState((){
                                    _updateID = snapshot.data!.docs[index]['questionID'].toString();
                                    _questionTopic = snapshot.data!.docs[index]['topic'];
                                    _questionController.text = snapshot.data!.docs[index]['question'];
                                    _ans = snapshot.data!.docs[index]['answer'];
                                    _ans1Controller.text = snapshot.data!.docs[index]['multiple_choice'][0];
                                    _ans2Controller.text = snapshot.data!.docs[index]['multiple_choice'][1];
                                    _ans3Controller.text = snapshot.data!.docs[index]['multiple_choice'][2];
                                    _ans4Controller.text = snapshot.data!.docs[index]['multiple_choice'][3];
                                    _correctAnswer = snapshot.data!.docs[index]['multiple_choice'][_ans];
                                  });
                                  showDialog(context: context,
                                    builder: (BuildContext context) => editContent(context));
                                },
                              ),
                              SizedBox(width: 10),
                              TextButton(
                                child: Text("Delete"),
                                onPressed: (){
                                 showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Alert Message"),
                                      content: Text('Are you sure you want to delete this data?'),
                                      actions: [
                                        ElevatedButton(
                                          child: Text("Delete"),
                                          onPressed: () {
                                            deleteQuestion(snapshot.data!.docs[index]['questionID'].toString());
                                            Navigator.pop(context);
                                          },
                                        ),
                                        ElevatedButton(
                                          child: Text("Cancel"),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        )
                                      ],
                                    );
                                  });
                                },
                              )
                            ],
                          )
                        ],
                      )
                    ));
                  }
                )
              )
            ],
          )
          
          ]
          
          ),
          ),
        ],
        );
      }
    ),
    floatingActionButton: 
      FloatingActionButton( onPressed: (){
        setState(() {
        _questionController.text = "";
        _translateController.text='';
        _ans1Controller.text = "";
        _ans2Controller.text = "";
        _ans3Controller.text = "";
        _ans4Controller.text="";
        _ans=0;
        });
         showDialog(context: context,
          builder: (BuildContext context) => addContent(context));
      },
      child: Icon(Icons.add_comment),
      backgroundColor: Colors.blue,
    ) 
    ,);
  }

addContent(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.only(bottom: 16, top: 16),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Consts.padding),
      ),      
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState){
          return SingleChildScrollView(child:Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(
                  top: Consts.avatarRadius + Consts.padding,
                  bottom: Consts.padding,
                  left: Consts.padding,
                  right: Consts.padding
                ),
                margin: EdgeInsets.only(top: Consts.avatarRadius),
                decoration: new BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(Consts.padding),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      offset: const Offset(0.0,10.0)
                    )
                  ]
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                    "Add Quiz Question" + "\n",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                    Container(
                      padding: EdgeInsets.all(20.0),
                      child: DropdownButton(
                        value: _value,
                        items: [
                          DropdownMenuItem(
                            child: Text("Select Grade Level"),
                            value: 0
                          ),
                          DropdownMenuItem(
                            child: Text("Grade-2"),
                            value: 2
                          ),
                          DropdownMenuItem(
                            child: Text("Grade-3"),
                            value: 3
                          ),
                        ],
                        onChanged: (int? value){
                          setState(() {
                            _value = value;
                            _value == 2 || _value == 3 ? _topic = "Select a Topic" :
                            _topic = "Select a Topic";
                          });
                        },
                      )
                    ),
                    Container(
                      padding: EdgeInsets.all(20.0),
                      child: _value == 2? DropdownButton<String>(
                        value: _topic,
                        items: [
                          DropdownMenuItem(
                            child: Text("Select a Topic"),
                            value: "Select a Topic"
                          ),
                          DropdownMenuItem(
                            child: Text("Topic A1"),
                            value: "Topic A1"
                          ),
                          DropdownMenuItem(
                            child: Text("Topic B1"),
                            value: "Topic B1"
                          ),
                          DropdownMenuItem(
                            child: Text("Topic C1"),
                            value: "Topic C1"
                          ),
                          DropdownMenuItem(
                            child: Text("Topic D1"),
                            value: "Topic D1"
                          ),
                        ],
                        onChanged: (value){
                          setState(() {
                            _topic = value;
                          });
                        },
                      ): 
                      _value == 3 ? DropdownButton<String>(
                        value: _topic,
                        items: [
                          DropdownMenuItem(
                            child: Text("Select a Topic"),
                            value: "Select a Topic"
                          ),
                          DropdownMenuItem(
                            child: Text("Topic A2"),
                            value: "Topic A2"
                          ),
                          DropdownMenuItem(
                            child: Text("Topic B2"),
                            value: "Topic B2"
                          ),
                          DropdownMenuItem(
                            child: Text("Topic C2"),
                            value: "Topic C2"
                          ),
                          DropdownMenuItem(
                            child: Text("Topic D2"),
                            value: "Topic D2"
                          ),
                        ],
                        onChanged: (value){
                          setState(() {
                            _topic = value;
                          });
                        },
                      ):
                      DropdownButton<String>(
                        value: _topic,
                        items: [
                          DropdownMenuItem(
                            child: Text("Select Grade Level First"),
                            value: "Select a Topic"
                          ),
                        ],
                        onChanged: (value){
                          setState(() {
                            _topic = value;
                          });
                        },
                      )
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _questionController,
                            validator: (value) => Validator.validateQuestion(ques: value),
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(),
                              focusedBorder: UnderlineInputBorder(),
                              hintText: "Enter Kapampangan Question here"
                            ),
                            onTap:(){},
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: _translateController,
                            validator: (value) => Validator.validateQuestion(ques: value),
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(),
                              focusedBorder: UnderlineInputBorder(),
                              hintText: "Enter Question Translation here"
                            ),
                            onTap:(){},
                          ),
                          SizedBox(height: 20),
                          
                          TextFormField(
                            controller: _ans1Controller,
                            validator: (value) => Validator.validateAns(ans: value),
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(),
                              focusedBorder: UnderlineInputBorder(),
                              hintText: "Enter Answer 1"
                            ),
                            onTap:(){},
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: _ans2Controller,
                            validator: (value) => Validator.validateAns(ans: value),
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(),
                              focusedBorder: UnderlineInputBorder(),
                              hintText: "Enter Answer 2"
                            ),
                            onTap:(){},
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: _ans3Controller,
                            validator: (value) => Validator.validateAns(ans: value),
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(),
                              focusedBorder: UnderlineInputBorder(),
                              hintText: "Enter Answer 3"
                            ),
                            onTap:(){},
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: _ans4Controller,
                            validator: (value) => Validator.validateAns(ans: value),
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(),
                              focusedBorder: UnderlineInputBorder(),
                              hintText: "Enter Answer 4"
                            ),
                            onTap:(){},
                          ),
                          SizedBox(height: 20),
                          Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                  Text('Select the right answer'),
                                    Container(
                                  decoration: BoxDecoration(
                                    color: whitey.withOpacity(0.25),
                                    borderRadius: new BorderRadius.circular(10.0),
                                  ),
                                  child:Container(
                                    padding: EdgeInsets.only(left: 15),
                                      width: MediaQuery.of(context).size.width,
                                      child:DropdownButton(
                                      value: _ans,
                                        icon: Icon(Icons.keyboard_arrow_down),
                                        items:answerlist.map((String items) {
                                            return DropdownMenuItem(
                                                value: answerlist.indexOf(items),
                                                child: Text(items)
                                            );
                                        }
                                        ).toList(),
                                      onChanged: (int? newValue) {
                                          setState(() {
                                            _ans = newValue!;
                                          });
                                        },
                                    ),))
                                  ],
                                ),
                        ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      TextButton(
                        child: Text("Create Question"),
                        onPressed: ()  async {
                          setState(() {
                            _isProcessing = true;
                          });

                          if (_formKey.currentState!
                              .validate()) {
                             _createquestion();

                            setState(() {
                              _isProcessing = false;
                            });
                          Navigator.pop(context);

                          }
                          setState(() {
                      _isProcessing = false;
                    });

                        },
                      ),
                      Spacer(),
                      TextButton(
                        child: Text("Cancel"),
                        onPressed: (){
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20)
                  ],
                )
              ),
              Positioned(
                left: Consts.padding,
                right: Consts.padding,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: Consts.avatarRadius,
                  child: Image(image: NetworkImage("https://i.ibb.co/gghzqTq/mamyalung-logo.png"),
                    fit: BoxFit.fill,)
                )
              )
            ],
          ));
        },
      ),
    );  
}
editContent(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.only(bottom: 16, top: 16),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Consts.padding),
      ),      
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState){
          return SingleChildScrollView(child:Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,

                padding: EdgeInsets.only(
                  top: Consts.avatarRadius + Consts.padding,
                  bottom: Consts.padding,
                  left: Consts.padding,
                  right: Consts.padding
                ),
                margin: EdgeInsets.only(top: Consts.avatarRadius),
                decoration: new BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(Consts.padding),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      offset: const Offset(0.0,10.0)
                    )
                  ]
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                    "Edit Question",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  Text(
                    "Topic: $_questionTopic",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ), 
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Text(
                            "Input Question/Answer to be change",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ), 
                          TextFormField(
                            controller: _questionController,
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(),
                              focusedBorder: UnderlineInputBorder(),
                              hintText: "Enter Question",
                              
                            ),
                            onTap:(){},
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: _ans1Controller,
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(),
                              focusedBorder: UnderlineInputBorder(),
                              hintText: "Enter Answer 1"
                            ),
                            onTap:(){},
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: _ans2Controller,
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(),
                              focusedBorder: UnderlineInputBorder(),
                              hintText: "Enter Answer 2"
                            ),
                            onTap:(){},
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: _ans3Controller,
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(),
                              focusedBorder: UnderlineInputBorder(),
                              hintText: "Enter Answer 3"
                            ),
                            onTap:(){},
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: _ans4Controller,
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(),
                              focusedBorder: UnderlineInputBorder(),
                              hintText: "Enter Answer 4"
                            ),
                            onTap:(){},
                          ),
                          SizedBox(height: 20),
                          Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                  Text('Select the right answer'),
                                    Container(
                                  decoration: BoxDecoration(
                                    color: whitey.withOpacity(0.25),
                                    borderRadius: new BorderRadius.circular(10.0),
                                  ),
                                  child:Container(
                                    padding: EdgeInsets.only(left: 15),
                                      width: MediaQuery.of(context).size.width,
                                      child:DropdownButton(
                                      value: _ans,
                                        icon: Icon(Icons.keyboard_arrow_down),
                                        items:answerlist.map((String items) {
                                            return DropdownMenuItem(
                                                value: answerlist.indexOf(items),
                                                child: Text(items)
                                            );
                                        }
                                        ).toList(),
                                      onChanged: (int? newValue) {
                                          setState(() {
                                            _ans = newValue!;
                                          });
                                        },
                                    ),))
                                  ],
                                ),
                          SizedBox(height: 20),
                        ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      TextButton(
                        child: Text("Update Question"),
                        onPressed: (){
                          updateQuestion(_updateID, _questionController.text, _questionTopic, _ans, [_ans1Controller.text,_ans2Controller.text,_ans3Controller.text,_ans4Controller.text], _grlevel);
                          Navigator.pop(context);
                          
                        },
                      ),
                      Spacer(),
                      TextButton(
                        child: Text("Cancel"),
                        onPressed: (){
                          
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20)
                  ],
                )
              ),
              Positioned(
                left: Consts.padding,
                right: Consts.padding,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: Consts.avatarRadius,
                  child: Image(image: NetworkImage("https://i.ibb.co/gghzqTq/mamyalung-logo.png"),
                    fit: BoxFit.fill,)
                )
              )
            ],
          ));
        },
      ),
    );  
}
}


class Consts {
  Consts._();

  static double padding = 16.0;
  static double avatarRadius = 66.0;
}

