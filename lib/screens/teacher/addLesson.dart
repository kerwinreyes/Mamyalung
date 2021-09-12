

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mamyalung/materials.dart';
import 'package:mamyalung/responsive.dart';
import 'package:mamyalung/utils/validator.dart';

class AddLesson extends StatefulWidget {
  const AddLesson({ Key? key }) : super(key: key);

  @override
  _AddLessonState createState() => _AddLessonState();
}
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
  
  String? choice = 'Select Option';
  int? _value = 0;
  String? topicChoice = '';
  List<String> answerlist =['Answer 1','Answer 2','Answer 3','Answer 4'];
  List<String> topics = [];
  List<String> dupTopics = [];
  int _ans = 1;

  
  
class _AddLessonState extends State<AddLesson> {
  void get(){
    FirebaseFirestore.instance
    .collection('questions')
    .where('topics')
    .get()
    .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          setState(() {
            dupTopics.add(doc['topic'].toString());
            for(var x in dupTopics){
              if(topics.contains(x)){
                continue;
              }
              else{
                topics.add(x);
              }
              
            }
            topicChoice = topics[0];
 
          });
            
        });
    });
  }

  @override
  void initState() { 
    super.initState();
    get();
  }
  @override
  Widget build(BuildContext context) {
    get();

    var screenSize = MediaQuery.of(context).size;
    var screenSizeW = screenSize.width;
    var screenSizeH = screenSize.height;
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: screenSizeW <= 649 ? NetworkImage('https://i.ibb.co/YBzRfyT/background.png') : NetworkImage("https://i.ibb.co/Zfs8zLR/mobilebg.png"),
            fit: BoxFit.fill),
        ),
        child: Form(
          key: _formKey,
          child: Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * .17, bottom : MediaQuery.of(context).size.height * .17),
            child: Column(
            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column( children: [
                  Text("Add Topic and Question"), 
                  SizedBox(height: 20),
                  Text("Select Option"),
                    Container(
                      child: DropdownButton<String>(
                        value: choice,
                        items: [
                          DropdownMenuItem(
                            child: Text("Select Option"),
                            value: "Select Option"
                          ),
                          DropdownMenuItem(
                            child: Text("Add Topic & Question"),
                            value: "Add Topic & Question"
                          ),
                          DropdownMenuItem(
                            child: Text("Add Question to Existing Topic"),
                            value: "Add Question to Existing Topic"
                          ),
                        ],
                        onChanged: (String? value){
                          setState(() {
                            choice = value;
                          });
                        },
                      )
                    ),
                     Text("Select Grade Level"),
                      Container(
                        //padding: EdgeInsets.all(20.0),
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
                            });
                          },
                        )
                      ),
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * .20),
                      child: Column(
                        children: [
                          choice == "Add Topic & Question"
                          ?
                            TextFormField(
                              textAlign: TextAlign.center,
                              controller: _topicControlller,
                              validator: (value) => Validator.validateQuestion(ques: value),
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(),
                                focusedBorder: UnderlineInputBorder(),
                                hintText: "Enter Topic to add"
                              ),
                              onTap:(){},
                            )
                          : choice == "Add Question to Existing Topic"
                          ?
                            
                            Column(
                              children: [
                                Text("Select a Topic"),
                                SizedBox(height: 20),
                                Container(
                                    child: DropdownButton(
                                    
                                    value: topicChoice,
                                    items: topics.map((String items) {
                                            return DropdownMenuItem(
                                                value: items,
                                                child: Text(items)
                                            );
                                          }
                                        ).toList(),
                                        onChanged: (value){
                                          topicChoice = value.toString();
                                        },
                                  )
                                )
                              ],
                            )
                            
                          : 
                          SizedBox(height: 20),
                          TextFormField(
                            textAlign: TextAlign.center,
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
                            textAlign: TextAlign.center,
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
                            textAlign: TextAlign.center,
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
                            textAlign: TextAlign.center,
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
                            textAlign: TextAlign.center,
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
                            textAlign: TextAlign.center,
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
                              SizedBox(height: 20),
                              Container(
                                decoration: BoxDecoration(
                                  color: whitey.withOpacity(0.25),
                                  borderRadius: new BorderRadius.circular(10.0),
                                ),
                                child: Container(
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
                                  ),
                                )
                              )
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 15),
                            child: ElevatedButton(
                              onPressed: (){
                                print(topics[0]);
                              }, 
                              child: Text("Add Question")
                            )
                          ) 
                        ],
                      )
                    ),                    
                  ],
                )
              ],
            )
          )
        )
      )
    );
  }
}

