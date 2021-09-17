import 'dart:async';
import 'dart:convert';

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mamyalung/screens/custom/badges.dart';
import 'package:mamyalung/responsive.dart';
import 'package:mamyalung/utils/validator.dart';
import '../../loginpage.dart';
import '../../materials.dart';
import 'package:mamyalung/model/question.dart';
import 'dart:math';
import 'package:http/http.dart';

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
  //Filter Starts
  TextEditingController _controller = new TextEditingController();
  List searchlist=[];
  String _searchString = '';
  List _allResults = [];
  List _resultsList = [];

  //End Search Filter 
final _formKey = GlobalKey<FormState>();

TextEditingController _questionController = new TextEditingController();
TextEditingController _topicControlller = new TextEditingController();
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

  int a =0;
Future<void> deleteUser(id) {
  
  return question
    .doc('$id')
    .delete()
    .then((value) => print("User Deleted"))
    .catchError((error) => print("Failed to delete user: $error"));
    
}
Future<void> updateQuestion(String id,String question,String topic, int ans, List choices, int level, String translate ) async{
  CollectionReference quess = FirebaseFirestore.instance.collection('questions');    
  
 return quess.doc(id)
                .update({
                  'question':question,
                  'topic': topic,
                  'translation': translate,
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
                _translateController.text = "";
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
TextEditingController _searchkey = new TextEditingController();
String searchTxt='';
    TextEditingController _searchQuesController = TextEditingController();

  late Future resultsLoaded;
  List _allQuestions = [];
  List _resultsListQues = [];
  var topicList=[''];
  String tCode ='';
  @override
  void initState() {
    super.initState();
    _searchQuesController.addListener(_onSearchChanged);
    getTopicList();
  }

  @override
  void dispose() {
    _searchQuesController.removeListener(_onSearchChanged);
    _searchQuesController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resultsLoaded = getQuestion();
  }

  _onSearchChanged() {
    searchResultsList();
  }
  Future<void> getTopicList() async{
  await FirebaseFirestore.instance
      .collection('topics')
      .get()
      .then((QuerySnapshot querySnapshot){
         querySnapshot.docs.forEach((DocumentSnapshot doc) {
            topicList.add(doc['topic_name']+ ' | Grade ' + doc['grade_level'].toString() );
          
        }); 
      });
  }
   getQuestion() async{
       var data = await FirebaseFirestore.instance
        .collection('questions')
        .get();
    setState(() {
      _allQuestions = data.docs;
    });
    searchResultsList();
  }
  searchResultsList() {
    var showResults = [];

    if(_searchQuesController.text != "") {
      for(var quesSnapshot in _allQuestions){
        var question = QuestionsModel.fromSnapshot(quesSnapshot).question.toLowerCase();
        var topic = QuestionsModel.fromSnapshot(quesSnapshot).topic.toLowerCase();
        var level = QuestionsModel.fromSnapshot(quesSnapshot).grade_level;

        if(question.contains(_searchQuesController.text.toLowerCase()) || topic.contains(_searchQuesController.text.toLowerCase())) {
          showResults.add(quesSnapshot);
        }
      }

    } else {
      showResults = List.from(_allQuestions);
    }
    setState(() {
      _resultsListQues = showResults;
    });
  }      
  @override
  Widget build(BuildContext context) {
     var screenSize = MediaQuery.of(context).size;
    var screenSizeW = screenSize.width;
    var screenSizeH = screenSize.height;
    final _formKey = GlobalKey<FormState>();
    return Scaffold(
      extendBodyBehindAppBar: true,
      body:
      Stack(children: [
          Container(
          width: screenSizeW,
          height: screenSizeH,
          decoration: BoxDecoration(
        image: DecorationImage(
          image: screenSizeW <= 649 ? NetworkImage('https://i.ibb.co/YBzRfyT/background.png') : NetworkImage("https://i.ibb.co/Zfs8zLR/mobilebg.png"), fit: BoxFit.fill),
          ),),
           
              
          Column(children: [
            SizedBox(height:50),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            child:TextField(
            
            controller: _searchQuesController,
            decoration: InputDecoration(
              
              focusColor: lightBlue,
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              
              ),
              hintText: 'Enter a search term'
            ),
          )),
      SingleChildScrollView(child:Container(
      height: MediaQuery.of(context).size.height*.70,
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ListView.builder(
        itemCount: _resultsListQues.length,
        itemBuilder: (BuildContext context, int index)=>
         questionView(context, _resultsListQues[index])
        )
    
    ))])
          
        ],
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
                    //
                    Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Select a topic'),
                                    Container(
                                  decoration: BoxDecoration(
                                    color: whitey.withOpacity(0.25),
                                    borderRadius: new BorderRadius.circular(10.0),
                                  ),
                                  child:Container(
                                    padding: EdgeInsets.only(left: 15),
                                      width: MediaQuery.of(context).size.width,
                                      child:DropdownButton(
                                      value: tCode,
                                        icon: Icon(Icons.keyboard_arrow_down),
                                        items:topicList.map((String items) {
                                            return DropdownMenuItem(
                                                value:items,
                                                child: Text(items)
                                            );
                                        }
                                        ).toList(),
                                      onChanged: (String? newValue) {
                                          setState(() {
                                            tCode = newValue!;
                                          });
                                        },
                                    ),))
                                  ],
                                ),
                    //
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
                              hintText: "EnterKapampangan Question",
                              
                            ),
                            onTap:(){},
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: _translateController,
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(),
                              focusedBorder: UnderlineInputBorder(),
                              hintText: "Enter Question Translation",
                              
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
                          updateQuestion(_updateID, _questionController.text, _questionTopic, _ans, [_ans1Controller.text,_ans2Controller.text,_ans3Controller.text,_ans4Controller.text], _grlevel,_translateController.text);
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
questionView(BuildContext context, resultsList){
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
                            title: Text("Topic: ${resultsList['topic']}",style: TextStyle(fontFamily: 'Sans'),),
                            subtitle: Text("Question: ${resultsList['question']}", style: TextStyle(fontFamily: 'Evil', fontSize:20, color: black),),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              TextButton(
                                child: Text("Edit"),
                                onPressed: (){

                                  setState((){
                                    _updateID = resultsList['questionID'].toString();
                                    _questionTopic = resultsList['topic'];
                                    _questionController.text = resultsList['question'];
                                    _translateController.text = resultsList['translation'];
                                    _ans =resultsList['answer'];
                                    _ans1Controller.text = resultsList['multiple_choice'][0];
                                    _ans2Controller.text =resultsList['multiple_choice'][1];
                                    _ans3Controller.text = resultsList['multiple_choice'][2];
                                    _ans4Controller.text = resultsList['multiple_choice'][3];
                                    _correctAnswer = resultsList['multiple_choice'][_ans];
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
                                            deleteQuestion(resultsList['questionID'].toString());
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
}


class Consts {
  Consts._();

  static double padding = 16.0;
  static double avatarRadius = 66.0;
}

