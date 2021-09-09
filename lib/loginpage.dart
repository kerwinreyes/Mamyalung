import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mamyalung/dashboard.dart';
import 'package:mamyalung/materials.dart';
import 'package:mamyalung/screens/admin/homepage.dart';
import 'package:mamyalung/screens/login.dart';
import 'package:mamyalung/screens/register.dart';
import 'package:mamyalung/screens/students/homepage.dart';
import 'package:mamyalung/utils/fire_auth.dart';
import 'package:mamyalung/utils/validator.dart';
import 'package:mamyalung/responsive.dart';

import 'screens/teacher/homepage.dart';
import 'components/routes.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = '/login';
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  bool _isProcessing = false;

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
    FirebaseFirestore.instance
        .collection('/users')
        .where('uid', isEqualTo: user.uid)
        .get()
        .then((QuerySnapshot querySnapshot){
          querySnapshot.docs.forEach((doc) {
            if(identical(doc['role'],'Admin')){
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => AdminHomePage(user:user.uid)),
            );
            }else if(identical(doc['role'],'teacher')){
              Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => TeacherDashboard(uid:user.uid)),
            );

            }
            else{
              Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => StudentHomePage(uid:user.uid)),
      );
            }
          }); 
        });
    }

    return firebaseApp;
  }
  void logIn() {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: _emailTextController.text, password: _passwordTextController.text)
        .then((result) {
      _isProcessing = false;
      if (result != null) {
        FirebaseFirestore.instance
        .collection('/users')
        .where('uid', isEqualTo: result.user!.uid)
        .get()
        .then((QuerySnapshot querySnapshot){
          querySnapshot.docs.forEach((doc) {
            if(identical(doc['role'],'Admin')){
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => AdminHomePage(user: result.user!.uid)),
              );
            }else if(identical(doc['role'],'teacher')){
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => TeacherHomePage(uid: result.user!.uid)),
              );
            }
            else{
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => StudentHomePage(uid: result.user!.uid)),
              );
            }
          }); 
        });
          
      }
      
    }).catchError((err) {
      print(err.message);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text(err.message),
              actions: [
                ElevatedButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    });
  }
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var screenSizeW = screenSize.width;
    var screenSizeH = screenSize.height;
    

    return GestureDetector(
      onTap: () {
        _focusEmail.unfocus();
        _focusPassword.unfocus();
      },
      
      
      child: Stack(
        children: [
          //FittedBox(
          // child: Image.asset('assets/scenefinal.png',
          //   height: screenSizeH,
          //    width: screenSizeW, 
          //   fit: BoxFit.cover,),
         //   ),
          // Container(
          //   //constraints: BoxConstraints.expand(),
          //    decoration: BoxDecoration(
          //     image: DecorationImage(
          //        //image: AssetImage("assets/image/mamyalungnamepets.png"),
          //        fit: BoxFit.cover),
          //       ),
          // ),
          Container(
            //constraints: BoxConstraints.expand(),
            width: screenSizeW,
            height: screenSizeH,
             decoration: BoxDecoration(
              image: DecorationImage(
                 image: screenSizeW <= 649 ? NetworkImage("https://i.ibb.co/pv1VtZV/Mobile-Login.png") : NetworkImage("https://i.ibb.co/0M3g5RQ/scenefinal.png"),
                 fit: BoxFit.fill),
                ),
          ),
              
          Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.transparent,
          body: Center(
            child: Column(
              children: [ 
                Responsive(
                  desktop: Container(
                    width: 550.0, 
                    padding: EdgeInsets.only(top: screenSizeH*.38),
                    //padding: EdgeInsets.fromLTRB(screenSizeW*.25, screenSizeH*.25, screenSizeW*.25, screenSizeH*.25),

                    child: FutureBuilder(

                future: _initializeFirebase(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Container(
                      //padding: const EdgeInsets.only(left:50.0, right: 50.0, top: 25.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          
                          Form(
                            key: _formKey,
                            child: Column(
                              children: <Widget>[
                                TextFormField(
                                  controller: _emailTextController,
                                  focusNode: _focusEmail,
                                  validator: (value) => Validator.validateEmail(
                                    email: value,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: "Email",
                                    labelStyle: TextStyle(color: black),
                                    hintText: "Type your Email Address",
                                    filled: true,
                                    
                                    fillColor: whitey.withOpacity(0.25),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: whitey)
                                    ),
                                    errorBorder: UnderlineInputBorder(
                                      borderRadius: BorderRadius.circular(6.0),
                                      borderSide: BorderSide(
                                        color: Colors.red,
                                      ),
                                    ),
                                    prefixIcon: Icon(Icons.email)
                                  ),
                                ),
                                
                                SizedBox(height: 10.0),
                                TextFormField(
                                  controller: _passwordTextController,
                                  focusNode: _focusPassword,
                                  obscureText: true,
                                  validator: (value) => Validator.validatePassword(
                                    password: value,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "Type your Password",
                                    labelText: "Password",
                                    labelStyle: TextStyle(color: black),
                                    filled: true,
                                    fillColor: whitey.withOpacity(0.25),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: white)
                                    ),
                                    errorBorder: UnderlineInputBorder(
                                      borderRadius: BorderRadius.circular(6.0),
                                      borderSide: BorderSide(
                                        color: Colors.red,
                                      ),
                                    ),
                                    prefixIcon: Icon(Icons.lock)
                                  ),
                                ),
                                SizedBox(height: 15.0),
                                _isProcessing
                                    ? CircularProgressIndicator()
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: SizedBox(height: 35.0 ,
                                            child: ElevatedButton(
                                              onPressed: () async {
                                                _focusEmail.unfocus();
                                                _focusPassword.unfocus();

                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  setState(() {
                                                    _isProcessing = true;
                                                  });

                                                  logIn();
                                                  setState(() {
                                                    _isProcessing = false;
                                                  });
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15.0))),
                                              child: Text(
                                                'Sign In',
                                                style: TextStyle(color: Colors.white, fontSize: 18.0),
                                          ),
                                        ),
                                        
                                      ),
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: SizedBox( height: 35.0,
                                        child: ElevatedButton(
                                          onPressed: ()=> Navigator.pushReplacementNamed(context, Routes.registerPage),
                                          style: ElevatedButton.styleFrom(shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15.0))),
                                          child: Text(
                                            'Register',
                                            style: TextStyle(color: Colors.white, fontSize: 18.0),
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
              );
            }

              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
                  ),

                  //MOBILE
                  mobile: Container(
                    width: 350,
                    padding: EdgeInsets.only(top: screenSizeH*.38),
                    child: FutureBuilder(

                future: _initializeFirebase(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Container(
                      //padding: const EdgeInsets.only(left:50.0, right: 50.0, top: 25.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          
                          Form(
                            key: _formKey,
                            child: Column(
                              children: <Widget>[
                                TextFormField(
                                  controller: _emailTextController,
                                  focusNode: _focusEmail,
                                  validator: (value) => Validator.validateEmail(
                                    email: value,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: "Email",
                                    labelStyle: TextStyle(color: black),
                                    hintText: "Email Address",
                                    filled: true,
                                    
                                    fillColor: whitey.withOpacity(0.25),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: whitey)
                                    ),
                                    errorBorder: UnderlineInputBorder(
                                      borderRadius: BorderRadius.circular(6.0),
                                      borderSide: BorderSide(
                                        color: Colors.red,
                                      ),
                                    ),
                                    prefixIcon: Icon(Icons.email)
                                  ),
                                ),
                                
                                SizedBox(height: 10.0),
                                TextFormField(
                                  controller: _passwordTextController,
                                  focusNode: _focusPassword,
                                  obscureText: true,
                                  validator: (value) => Validator.validatePassword(
                                    password: value,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "Password",
                                    labelText: "Password",
                                    labelStyle: TextStyle(color: black),
                                    filled: true,
                                    fillColor: whitey.withOpacity(0.25),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: white)
                                    ),
                                    errorBorder: UnderlineInputBorder(
                                      borderRadius: BorderRadius.circular(6.0),
                                      borderSide: BorderSide(
                                        color: Colors.red,
                                      ),
                                    ),
                                    prefixIcon: Icon(Icons.lock)
                                  ),
                                ),
                                SizedBox(height: 15.0),
                                _isProcessing
                                    ? CircularProgressIndicator()
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: SizedBox(height: 35.0 ,
                                            child: ElevatedButton(
                                              onPressed: () async {
                                                _focusEmail.unfocus();
                                                _focusPassword.unfocus();

                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  setState(() {
                                                    _isProcessing = true;
                                                  });
                                                  logIn();
                                                  setState(() {
                                                    _isProcessing = false;
                                                  });

                                                }
                                              },
                                              style: ElevatedButton.styleFrom(shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15.0))),
                                              child: Text(
                                                'Sign In',
                                                style: TextStyle(color: Colors.white, fontSize: 18.0),
                                          ),
                                        ),
                                        
                                      ),
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: SizedBox( height: 35.0,
                                        child: ElevatedButton(
                                          onPressed: ()=> Navigator.pushReplacementNamed(context, Routes.registerPage),
                                          style: ElevatedButton.styleFrom(shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15.0))),
                                          child: Text(
                                            'Register',
                                            style: TextStyle(color: Colors.white, fontSize: 18.0),
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
              );
            }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
                  ),

              //TABLET
                  tablet: Container( 
                    width: 550,
                    padding: EdgeInsets.only(top: screenSizeH*.38),
                    child: FutureBuilder(
  
                future: _initializeFirebase(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Container(
                      //padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                         
                          Form(
                            key: _formKey,
                            child: Column(
                              children: <Widget>[
                                
                                  
                                SizedBox(height: 8.0),
                                TextFormField(
                                  controller: _passwordTextController,
                                  focusNode: _focusPassword,
                                  obscureText: true,
                                  validator: (value) => Validator.validatePassword(
                                    password: value,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: "Email",
                                    labelStyle: TextStyle(color: black),
                                    hintText: "Email Address",
                                    filled: true,
                                    
                                    fillColor: whitey.withOpacity(0.25),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: whitey)
                                    ),
                                    errorBorder: UnderlineInputBorder(
                                      borderRadius: BorderRadius.circular(6.0),
                                      borderSide: BorderSide(
                                        color: Colors.red,
                                      ),
                                    ),
                                    prefixIcon: Icon(Icons.email)
                                  ),
                                ),
                                
                                SizedBox(height: 10.0),
                                TextFormField(
                                  controller: _passwordTextController,
                                  focusNode: _focusPassword,
                                  obscureText: true,
                                  validator: (value) => Validator.validatePassword(
                                    password: value,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "Password",
                                    labelText: "Password",
                                    labelStyle: TextStyle(color: black),
                                    filled: true,
                                    fillColor: whitey.withOpacity(0.25),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: white)
                                    ),
                                    errorBorder: UnderlineInputBorder(
                                      borderRadius: BorderRadius.circular(6.0),
                                      borderSide: BorderSide(
                                        color: Colors.red,
                                      ),
                                    ),
                                    prefixIcon: Icon(Icons.lock)
                                  ),
                                ),
                                SizedBox(height: 15.0),
                                _isProcessing
                                    ? CircularProgressIndicator()
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: SizedBox(height: 35.0 ,
                                            child: ElevatedButton(
                                              onPressed: () async {
                                                _focusEmail.unfocus();
                                                _focusPassword.unfocus();

                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  setState(() {
                                                    _isProcessing = true;
                                                  });
                                                  logIn();
                                                  setState(() {
                                                    _isProcessing = false;
                                                  });
                                                
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15.0))),
                                        child: Text(
                                          'Sign In',
                                          style: TextStyle(color: Colors.white, fontSize: 18.0),
                                        ),
                                        
                                            ))),
                                    
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: SizedBox( height: 35.0,
                                        child: ElevatedButton(
                                          onPressed: ()=> Navigator.pushReplacementNamed(context, Routes.registerPage),
                                          style: ElevatedButton.styleFrom(shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15.0))),
                                          child: Text(
                                            'Register',
                                            style: TextStyle(color: Colors.white, fontSize: 18.0),
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
              );
            }

              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
                  ),
                ),
                
        ],
        ),
        ),
        ),
        ],
        ),
      );
      
    }
    
  }