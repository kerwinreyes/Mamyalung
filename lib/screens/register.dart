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
  int? _gradeLevel = 0;
  String? gradeLevel = "Select a Grade Level";
  var items = ['Student', 'Teacher'];
  var grade_levels = ["Select a Grade Level",'Grade 2', 'Grade 3'];
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
        'grade_level': _gradeLevel,
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
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Message"),
                content: Text('The password provided is too weak.'),
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
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Message"),
                content: Text('The account already exists for that email.'),
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
        print('The account already exists for that email.');
      }
    } catch (e) {
      showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Message"),
                content: Text('$e'),
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
                    width: screenSizeW <= 649 ? 400 : 500,
                    padding: EdgeInsets.only(top: screenSizeH * .25),
                    child: Center(
                      child: Container(child:Column(
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
                                          )),
                                  SizedBox(width: 10.0),
                                  Expanded(
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
                                          ))
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
                                          child: DropdownButton<String>(
                                            value: gradeLevel,
                                            icon:
                                                Icon(Icons.keyboard_arrow_down),
                                            items: grade_levels
                                                .map((String items) {
                                              return DropdownMenuItem<String>(
                                                  value: items,
                                                  child: Text(items));
                                            }).toList(),
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                if(newValue == "Grade 2"){
                                                  _gradeLevel = 2;
                                                  gradeLevel = newValue;
                                                }
                                                else if(newValue =="Grade 3"){
                                                  _gradeLevel = 3;
                                                  gradeLevel = newValue;
                                                }
                                                else{
                                                  _gradeLevel = 0;
                                                  gradeLevel = "Select a Grade Level";
                                                }
                                              });
                                            },
                                          ),
                                        ))
                                  ],
                                ),
                                SizedBox(height: 15.0),
                                _isProcessing
                                            ? CircularProgressIndicator()
                                            : Container(
                                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                                width: double.infinity,
                                                height: 60,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(100),
                                                ),
                                                child: MaterialButton(
                                                  onPressed: () async {
                                                  setState(() {
                                                    _isProcessing = true;
                                                  });
                                                  if(_gradeLevel == 2 || _gradeLevel == 3){
                                                    if (_registerFormKey
                                                      .currentState!
                                                      .validate()) {
                                                    addUser();

                                                    setState(() {
                                                      _isProcessing = false;
                                                    });
                                                  }
                                                  

                                                  }
                                                  else{
                                                    final snackbar = SnackBar(
                                                      duration: Duration(milliseconds : 500),
                                                      backgroundColor: Colors.orange,
                                                      content: Text("Select a Grade Level!"),);
                                                    ScaffoldMessenger.of(context).showSnackBar(snackbar);

                                                  }  
                                                  setState(() {
                                                    _isProcessing = false;
                                                  }); 
                                                },
                                                  color: lightBlue,
                                                  child: Text(
                                                    'Sign Up',
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.white,
                                                        fontFamily: 'Evil'
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Divider(
                                                color: Colors.black,
                                                height: 30,
                                              ),
                                              Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  '''Already Have an account? ''',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily: 'Evil',
                                                    fontSize:18.0,
                                                  ),
                                                ),
                                                TextButton(
                                                 onPressed: () => Navigator
                                                            .pushReplacementNamed(
                                                                context,
                                                                Routes
                                                                    .loginPage),
                                                  child: Text('Login', style: TextStyle(color: primaryBlue,
                                                    fontSize:18.0,),),
                                                  
                                                )
                                              ],
                                            ),
                              ],
                            ),
                          )
                        ],
                      ),
                    padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(.8),
                                borderRadius: BorderRadius.circular(20),
                                
                              ),),
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
