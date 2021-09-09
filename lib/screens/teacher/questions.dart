import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mamyalung/screens/custom/badges.dart';
import 'package:mamyalung/responsive.dart';
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
    return Responsive(
        desktop: Container(),
        tablet: Container(),
        //For mobile 
        mobile: QuestionsDashboard(uid: widget.uid),
    );
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
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('questions')
  .where('grade_level', isEqualTo: 2)
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
TextEditingController _ans1Controller = new TextEditingController();
TextEditingController _ans2Controller = new TextEditingController();
TextEditingController _ans3Controller = new TextEditingController();
TextEditingController _ans4Controller = new TextEditingController();
TextEditingController _correctAnsController = new TextEditingController();
String _questionTopic = '';
String _question = '';
String _answer1 = '';
String _answer2 = '';
String _answer3 = '';
String _answer4 = '';
String _correctAnswer = '';
int _ans = 0;
int? _value = 0;
String? _topic = "Select a Topic";
CollectionReference question = FirebaseFirestore.instance.collection('questions');

Future<void> deleteUser(id) {
  return question
    .doc('$id')
    .delete()
    .then((value) => print("User Deleted"))
    .catchError((error) => print("Failed to delete user: $error"));
    
}




  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        
        return Container(
            color: green,
            child: ListView(
              children: <Widget>[
            Column(
            children: [
              Padding(padding: EdgeInsets.fromLTRB(60, MediaQuery.of(context).size.height * .10, 60, 0),
                child: Row(
                  children: [
                    Text(""),
                    Spacer(),
                    Text("")
                  ],
                )
              ),
              Container(
                color: green,
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index){
                    DocumentSnapshot doc = snapshot.data!.docs[index];
                    return Padding(
                      padding: EdgeInsets.fromLTRB(10,20,10,0),
                      child: Card(
                        
                        child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          ListTile(
                            leading: Icon(Icons.topic_outlined),
                            title: Text("Topic: ${snapshot.data!.docs[index]['topic']}"),
                            subtitle: Text("Question: ${snapshot.data!.docs[index]['question']}"),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              TextButton(
                                child: Text("Edit"),
                                onPressed: (){

                                  setState((){
                                    _questionTopic = snapshot.data!.docs[index]['topic'];
                                    _question = snapshot.data!.docs[index]['question'];
                                    _ans = snapshot.data!.docs[index]['answer'];
                                    _answer1 = snapshot.data!.docs[index]['multiple_choice'][0];
                                    _answer2 = snapshot.data!.docs[index]['multiple_choice'][1];
                                    _answer3 = snapshot.data!.docs[index]['multiple_choice'][2];
                                    _answer4 = snapshot.data!.docs[index]['multiple_choice'][3];
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
                                  // final collection = FirebaseFirestore.instance.collection('questions');
                                  // collection 
                                  //     .doc('${doc.id}')  
                                  //     .delete()
                                  //     .then((_) => print('Deleted'))
                                  //     .catchError((error) => print('Delete failed: $error'));
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
        );
      }
    ),
    floatingActionButton: 
      FloatingActionButton( onPressed: (){
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
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(),
                              focusedBorder: UnderlineInputBorder(),
                              hintText: "Input the Question to be added"
                            ),
                            onTap:(){},
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: _ans1Controller,
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(),
                              focusedBorder: UnderlineInputBorder(),
                              hintText: "Input Answer 1"
                            ),
                            onTap:(){},
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: _ans2Controller,
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(),
                              focusedBorder: UnderlineInputBorder(),
                              hintText: "Input Answer 2"
                            ),
                            onTap:(){},
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: _ans3Controller,
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(),
                              focusedBorder: UnderlineInputBorder(),
                              hintText: "Input Answer 3"
                            ),
                            onTap:(){},
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: _ans4Controller,
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(),
                              focusedBorder: UnderlineInputBorder(),
                              hintText: "Input Answer 4"
                            ),
                            onTap:(){},
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: _correctAnsController,
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(),
                              focusedBorder: UnderlineInputBorder(),
                              hintText: "Input Correct Answer"
                            ),
                            onTap:(){},
                          ),
                        ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      TextButton(
                        child: Text("Back"),
                        onPressed: (){
                          Navigator.pop(context);
                        },
                      ),
                      Spacer(),
                      TextButton(
                        child: Text("Add"),
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
                              hintText: "Question: $_question"
                            ),
                            onTap:(){},
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: _ans1Controller,
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(),
                              focusedBorder: UnderlineInputBorder(),
                              hintText: "Answer 1: $_answer1"
                            ),
                            onTap:(){},
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: _ans2Controller,
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(),
                              focusedBorder: UnderlineInputBorder(),
                              hintText: "Answer 2: $_answer2"
                            ),
                            onTap:(){},
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: _ans3Controller,
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(),
                              focusedBorder: UnderlineInputBorder(),
                              hintText: "Answer 3: $_answer3"
                            ),
                            onTap:(){},
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: _ans4Controller,
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(),
                              focusedBorder: UnderlineInputBorder(),
                              hintText: "Answer 4: $_answer4"
                            ),
                            onTap:(){},
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: _correctAnsController,
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(),
                              focusedBorder: UnderlineInputBorder(),
                              hintText: "Correct Answer: $_correctAnswer"
                            ),
                            onTap:(){},
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
                        child: Text("Back"),
                        onPressed: (){
                          Navigator.pop(context);
                        },
                      ),
                      Spacer(),
                      TextButton(
                        child: Text("Edit"),
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

