
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mamyalung/materials.dart';
import 'package:mamyalung/screens/admin/homepage.dart';
import 'package:mamyalung/screens/students/homepage.dart';
import 'package:mamyalung/utils/validator.dart';

import 'screens/teacher/homepage.dart';
import 'components/routes.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = '/login';
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static final _formKey = new GlobalKey<FormState>();

  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  static final _focusEmail = FocusNode();
  static final _focusPassword = FocusNode();

  bool _isProcessing = false;

 
  void logIn() async{
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: _emailTextController.text,
            password: _passwordTextController.text)
        .then((result) {
      _isProcessing = false;
      if (result != null) {
        FirebaseFirestore.instance
            .collection('/users')
            .where('uid', isEqualTo: result.user!.uid)
            .get()
            .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            if (identical(doc['role'], 'Admin')) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        AdminHomePage(user: result.user!.uid)),
              );
            } else if (identical(doc['role'], 'teacher')) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        TeacherHomePage(uid: result.user!.uid)),
              );
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        StudentHomePage(uid: result.user!.uid)),
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
  bool  _passwordVisible= true;
@override
  void initState() {
    _passwordVisible = true;
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
      child: Scaffold(
            resizeToAvoidBottomInset: true,
            body: Stack(
        children: [
         
          Container(
            width: screenSizeW,
            height: screenSizeH,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: screenSizeW <= 649
                      ? NetworkImage("https://i.ibb.co/W22cm6d/mobilelogin.png")
                      : NetworkImage(
                          "https://i.ibb.co/4Mn4Mh5/mamyalungnamepets.png"),
                  fit: BoxFit.fill),
            ),
          ),

          Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  
                     Container(
                        width: screenSizeW <= 649 ? 400 : 500,
                      padding: EdgeInsets.only(top: screenSizeH * .10),
                      
                              //padding: const EdgeInsets.only(left:50.0, right: 50.0, top: 25.0),
                              child: Container(child:Column(
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
                                              prefixIcon: Icon(Icons.email),

                                            ),
                                            
                                          ),
                                        SizedBox(height: 10.0),
                                        TextFormField(
                                          controller: _passwordTextController,
                                          focusNode: _focusPassword,
                                          obscureText: _passwordVisible,
                                          
                                          validator: (value) =>
                                              Validator.validateLoginPassword(
                                            password: value,
                                          ),
                                          decoration: InputDecoration(
                                              hintText: "Type your Password",
                                              labelText: "Password",
                                              labelStyle: TextStyle(
                                                  color: black,
                                                  fontFamily: 'Evil',
                                                  fontSize: 22),
                                              filled: true,
                                              fillColor:
                                                  Colors.white.withOpacity(0.8),
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  borderSide: BorderSide.none),
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  borderSide: BorderSide.none),
                                              errorBorder: UnderlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30.0),
                                                borderSide: BorderSide(
                                                  color: Colors.red,
                                                ),
                                              ),
                                              prefixIcon: Icon(Icons.lock),
                                              suffixIcon: IconButton(
                                                onPressed: (){
                                                  setState(() {
                                                    _passwordVisible=!_passwordVisible;
                                                  });
                                                }, 
                                                icon: Icon(Icons.remove_red_eye),
                                              )),
                                              
                                        ),
                                        SizedBox(height: 15.0),
                                        Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  TextButton(
                                                    onPressed: () => Navigator
                                                            .pushReplacementNamed(
                                                                context,
                                                                Routes
                                                                    .forgotpassword),
                                                    child: Text(
                                                      'Forgot Password?',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18.0,
                                                        fontFamily: 'Evil'
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 15,
                                              ),
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
                                                              _isProcessing =
                                                                  true;
                                                            });
                                                          if (_formKey
                                                              .currentState!
                                                              .validate()) {
                                                            logIn();
                                                            setState(() {
                                                              _isProcessing =
                                                                  false;
                                                            });
                                                          }
                                                          setState(() {
                                                              _isProcessing =
                                                                  false;
                                                            });
                                                        },
                                                  color: lightBlue,
                                                  child: Text(
                                                    'Login',
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
                                                  '''Don't have an account? ''',
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
                                                                    .registerPage),
                                                  child: Text('Register Now', style: TextStyle(color: primaryBlue,
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
                                
                              ),
                              ),
                        
                    ),
                ],
              ),
            ),
          )
        ],
      )),
    );
  }
}
