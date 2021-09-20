import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mamyalung/components/routes.dart';
import 'package:mamyalung/materials.dart';
import 'package:mamyalung/utils/validator.dart';

class RegisterPage extends StatefulWidget {
  static const String routeName = '/register';
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _registerFormKey = GlobalKey<FormState>();
  List image = [
    "https://i.ibb.co/FwpghZ7/cheetah.png",
    "https://i.ibb.co/ZRs4ddz/cat.png",
    "https://i.ibb.co/VSWqTd3/bird.png",
    "https://i.ibb.co/xgcfSBR/bear.png",
    "https://i.ibb.co/3TB9HXg/Asset-11char.png",
    "https://i.ibb.co/ZxWpJ7k/Asset-10char.png",
    "https://i.ibb.co/v49Xd6Q/turtle.png",
    "https://i.ibb.co/6DQYsxR/ninja.png",
    "https://i.ibb.co/qD6QHVp/dino.png",
    "https://i.ibb.co/sgJQPVw/dog.png",
  ];
  final _nameTextController = TextEditingController();
  final _lnameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _confirmpasswordController = TextEditingController();
  String dropdownvalue = 'Student';
  int _gradeLevel = 0;
  int _studLevel = 2;
  var items = ['Student', 'Teacher'];
  var grade_levels = ['Grade 1','Grade 2', 'Grade 3'];
  Random random = new Random();
  //Flashcards list
  List _flashcards = [{'questionID':0,'level':1}];
  List _flashcards_3 = [];
  final _focusName = FocusNode();
  final _focusLname = FocusNode();
  final _focusEmail = FocusNode();
  final _focusgradelvl = FocusNode();
  final _focusPassword = FocusNode();
  final _focusConfirmPassword = FocusNode();

  bool _isProcessing = false;
  CollectionReference _users = FirebaseFirestore.instance.collection('users');
  Future<void> addUser() async {
    List<int> qis = [];
    FirebaseFirestore.instance
        .collection('questions')
        .where('grade_level', isEqualTo: _gradeLevel)
        .get()
        .then((QuerySnapshot queryQuestion) {
      queryQuestion.docs.forEach((ques) {
        if (!qis.contains(ques['questionID'])) {
          _flashcards.add({'questionID': ques['questionID'], 'level': 1});
          qis.add(ques['questionID']);
        }
      });
    });
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailTextController.text,
        password: _passwordTextController.text,
      );
      user = userCredential.user;
      return _users.doc(user!.uid).set({
        'fname': _nameTextController.text,
        'lname': _lnameTextController.text,
        'email': _emailTextController.text,
        'role': dropdownvalue,
        'uid': user.uid,
        'points': 0,
        'grade_level': _studLevel,
        'flashcards': _flashcards.sublist(0, 10),
        
        'badge_count': 0,
        'day': 1,
        'image': image[random.nextInt(image.length)],
        'lastplayed_flashcard': '0',
      }).then((value) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Message"),
                content: Text('Registration Success'),
                actions: [
                  ElevatedButton(
                    child: Text("Ok"),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, Routes.loginPage);
                    },
                  )
                ],
              );
            });
        print('success');
        _flashcards = [];
      })
          // ignore: invalid_return_type_for_catch_error
          .catchError((error) => print('failed'));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var screenSizeW = screenSize.width;
    var screenSizeH = screenSize.height;

    return GestureDetector(
      onTap: () {
        _focusName.unfocus();
        _focusEmail.unfocus();
        _focusPassword.unfocus();
        _focusLname.unfocus();
        _focusgradelvl.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true, //fix for bottom overflow
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: screenSizeW <= 649
                        ? NetworkImage(
                            "https://i.ibb.co/2hb4nvM/mobileregister.png")
                        : NetworkImage(
                            "https://i.ibb.co/KrgnK8Z/Mamyalungwithpets.png"),
                    fit: BoxFit.fill),
              ),
            ),
            Center(
                child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: 400.0,
                    padding: EdgeInsets.only(top: screenSizeH * .2),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Form(
                            key: _registerFormKey,
                            child: Column(
                              children: <Widget>[
                                TextFormField(
                                  controller: _emailTextController,
                                  focusNode: _focusEmail,
                                  validator: (value) => Validator.validateEmail(
                                    email: value,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "Type your Email Address",
                                    labelText: "Email",
                                    labelStyle: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Evil',
                                        fontSize: 22),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide.none),
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.8),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide(color: white),
                                    ),
                                    errorBorder: UnderlineInputBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      borderSide: BorderSide(
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 16.0,
                                ),
                                Row(children: [
                                  Expanded(
                                      child: SizedBox(
                                          height: 45.0,
                                          child: TextFormField(
                                            controller: _nameTextController,
                                            focusNode: _focusName,
                                            validator: (value) =>
                                                Validator.validateName(
                                              name: value,
                                            ),
                                            decoration: InputDecoration(
                                              hintText: "Type your First Name",
                                              labelText: "First Name",
                                              labelStyle: TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: 'Evil',
                                                  fontSize: 22),
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  borderSide: BorderSide.none),
                                              filled: true,
                                              fillColor:
                                                  Colors.white.withOpacity(0.8),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                borderSide:
                                                    BorderSide(color: white),
                                              ),
                                              errorBorder: UnderlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30.0),
                                                borderSide: BorderSide(
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ),
                                          ))),
                                  SizedBox(width: 10.0),
                                  Expanded(
                                      child: SizedBox(
                                          height: 45.0,
                                          child: TextFormField(
                                            controller: _lnameTextController,
                                            focusNode: _focusLname,
                                            validator: (value) =>
                                                Validator.validateName(
                                              name: value,
                                            ),
                                            decoration: InputDecoration(
                                              hintText: "Type your Last Name",
                                              labelText: "Last Name",
                                              labelStyle: TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: 'Evil',
                                                  fontSize: 22),
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  borderSide: BorderSide.none),
                                              filled: true,
                                              fillColor:
                                                  Colors.white.withOpacity(0.8),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                borderSide:
                                                    BorderSide(color: white),
                                              ),
                                              errorBorder: UnderlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30.0),
                                                borderSide: BorderSide(
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ),
                                          )))
                                ]),
                                SizedBox(
                                  height: 16.0,
                                ),
                                Row(children: [
                                  Expanded(
                                      child:  TextFormField(
                                            controller: _passwordTextController,
                                            focusNode: _focusPassword,
                                            obscureText: true,
                                            validator: (value) =>
                                                Validator.validatePassword(
                                              password: value,
                                            ),
                                            decoration: InputDecoration(
                                              hintText: "Type your Password",
                                              labelText: "Password",
                                              labelStyle: TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: 'Evil',
                                                  fontSize: 22),
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  borderSide: BorderSide.none),
                                              filled: true,
                                              fillColor:
                                                  Colors.white.withOpacity(0.8),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                borderSide:
                                                    BorderSide(color: white),
                                              ),
                                              errorBorder: UnderlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30.0),
                                                borderSide: BorderSide(
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ),
                                          )),
                                  SizedBox(
                                    width: 15.0,
                                  ),
                                  Expanded(
                                      child:TextFormField(
                                            controller:
                                                _confirmpasswordController,
                                            focusNode: _focusConfirmPassword,
                                            obscureText: true,
                                            validator: (value) =>
                                                Validator.validatePassword(
                                                    password: value),
                                            decoration: InputDecoration(
                                              hintText: "Type your Password",
                                              labelText: " Confirm Password",
                                              labelStyle: TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: 'Evil',
                                                  fontSize: 22),
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  borderSide: BorderSide.none),
                                              filled: true,
                                              fillColor:
                                                  Colors.white.withOpacity(0.8),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                borderSide:
                                                    BorderSide(color: white),
                                              ),
                                              errorBorder: UnderlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30.0),
                                                borderSide: BorderSide(
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ),
                                          )),
                                ]),
                                SizedBox(
                                  height: 16.0,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.8),
                                          borderRadius:
                                              new BorderRadius.circular(10.0),
                                        ),
                                        child: Container(
                                          padding: EdgeInsets.only(left: 15),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: DropdownButton(
                                            value: _gradeLevel,
                                            icon:
                                                Icon(Icons.keyboard_arrow_down),
                                            items: grade_levels
                                                .map((String items) {
                                              return DropdownMenuItem(
                                                  value: grade_levels
                                                          .indexOf(items),
                                                  child: Text(items));
                                            }).toList(),
                                            onChanged: (int? newValue) {
                                              setState(() {
                                                _gradeLevel = newValue!;
                                                if(_gradeLevel== 0){
                                                  _studLevel =2;
                                                }
                                                else{
                                                  _studLevel =3;
                                                }
                                              });
                                            },
                                          ),
                                        ))
                                  ],
                                ),
                                SizedBox(height: 32.0),
                                _isProcessing
                                    ? CircularProgressIndicator()
                                    : Row(
                                        children: [
                                          Expanded(
                                            child: SizedBox(
                                              height: 35.0,
                                              child: ElevatedButton(
                                                onPressed: () async {
                                                  setState(() {
                                                    _isProcessing = true;
                                                  });

                                                  if (_registerFormKey
                                                      .currentState!
                                                      .validate()) {
                                                    addUser();

                                                    setState(() {
                                                      _isProcessing = false;
                                                    });
                                                  }
                                                  setState(() {
                                                    _isProcessing = false;
                                                  });
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    shape:
                                                        new RoundedRectangleBorder(
                                                            borderRadius:
                                                                new BorderRadius
                                                                        .circular(
                                                                    15.0))),
                                                child: Text(
                                                  'Sign up',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20.0, 
                                                      fontFamily: 'Evil'),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Expanded(
                                            child: SizedBox(
                                              height: 35.0,
                                              child: ElevatedButton(
                                                onPressed: () => Navigator
                                                    .pushReplacementNamed(
                                                        context,
                                                        Routes.loginPage),
                                                style: ElevatedButton.styleFrom(
                                                    shape:
                                                        new RoundedRectangleBorder(
                                                            borderRadius:
                                                                new BorderRadius
                                                                        .circular(
                                                                    15.0))),
                                                child: Text(
                                                  'Login',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20.0, 
                                                      fontFamily: 'Evil'),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
