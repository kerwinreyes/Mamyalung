import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:mamyalung/screens/admin/homepage.dart';
import 'package:mamyalung/utils/fire_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mamyalung/components/routes.dart';
import 'package:mamyalung/materials.dart';
import 'package:mamyalung/model/users.dart';
import 'package:mamyalung/responsive.dart';
import 'package:mamyalung/utils/validator.dart';
import 'package:mamyalung/widgets/buttons.dart';
import 'package:mamyalung/widgets/usertable.dart';
import 'package:mamyalung/extension.dart';
import 'package:mamyalung/screens/custom/custom.dart';
class AddUser extends StatefulWidget {
  static const String routeName = '/admin/adduser';
  const AddUser({ Key? key }) : super(key: key);

  @override
  _AddUserState createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  
    User? user = FirebaseAuth.instance.currentUser;

  Widget _createDrawerItem(
    {required IconData icon, required String text, GestureTapCallback? onTap}) {
  return ListTile(
    title: Row(
      children: <Widget>[
        Icon(icon),
        Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(text),
        )
      ],
    ),
    onTap: onTap,
  );
}
Widget _createHeader() {
  return DrawerHeader(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      
      child: Stack(children: <Widget>[
        Positioned(
            bottom: 12.0,
            left: 16.0,
            child: Text('Admin HomePage',
                style: TextStyle(
                    color: primaryBlue,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500))),
      ]));
}
  @override
  Widget build(BuildContext context) {
  int _sizeW = MediaQuery.of(context).size.width as int;
  int _sizeH = MediaQuery.of(context).size.height as int;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Row(children: [
            Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.label,size: 15.0,),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),),
            Text('Create User',style:TextStyle(color:Colors.black54))
            ])
        ),
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0,
      ),
      drawer: Container(
        width: 300,
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children:[
          _createHeader(),
          _createDrawerItem(icon: Icons.home,text: 'Home',
          onTap: () =>
           Navigator.pushReplacementNamed(context, Routes.adminprofile)),
          _createDrawerItem(icon: Icons.face, text: 'Profile',
          onTap: () =>
          Navigator.pushReplacementNamed(context, Routes.adminprofile),),
          _createDrawerItem(icon: Icons.settings, text: 'Settings',),
          Divider(),
          ListTile(
            title: Text('Logout'),
            onTap: () {},
          ),
        ],
          ),
        )
      ),
      body: Responsive(
        desktop: Center(child:Container(
          width: MediaQuery.of(context).size.width*.7,
          child:Add())),
        mobile: Add(),
        tablet: Add(),
      )
      
    );
  }
}
class Add extends StatefulWidget {
  const Add({ Key? key }) : super(key: key);

  @override
  _AddState createState() => _AddState();
}

class _AddState extends State<Add> {
  final _formKey = GlobalKey<FormState>();
  final _fname = TextEditingController();
  final _lname = TextEditingController();
  final _pass = TextEditingController();
  final _role = TextEditingController();
  final _email = TextEditingController();
  final _token = TextEditingController();
  
  final _focusFname = FocusNode();
  final _focusLname = FocusNode();
  final _focusEmail = FocusNode();
  final _focusPass = FocusNode();
  final _focusToken = FocusNode();
  bool _success= true;
  String dropdownvalue = 'Student';
  int _gradeLevel = 2;
  var items =  ['Student','Teacher'];
  var grade_levels = ['Grade 1','Grade 2','Grade 3'];
  var _flashcards=[];
  Future<void> readJson() async {
    final String response = await rootBundle.loadString('assets/questions/10questions_grade2FC.json');
    final data = await json.decode(response);
      return data;
  }
  CollectionReference _users = FirebaseFirestore.instance.collection('users');
  Future<void> addUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _email.text,
        password: _pass.text,
      );
      user = userCredential.user;
      return _users.doc(user!.uid)
            .set({
           'fname': _fname.text,
            'lname':_lname.text,
            'email':_email.text,
            'role':dropdownvalue,
            'uid':user.uid,
            'points': 0,
            'grade_level': 0,
            'flashcards': readJson(),
            'other_flashcards':_flashcards,
            'day': 1,

          })
          .then((value){
            setState(() {
             

            });
            print('success');
          })
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
  bool _isProcessing = false;
 
  @override
  
  Widget build(BuildContext context) {
    List<bool> isSelected = [false, true, false];
    return GestureDetector(
      onTap: () {
        _focusFname.unfocus();
        _focusLname.unfocus();
        _focusEmail.unfocus();
        _focusToken.unfocus();
        _focusPass.unfocus();
      },
      child:Container(
        padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
        color: Colors.white70,
        height: MediaQuery.of(context).size.height,
      child: Form(
        
    key: _formKey,
    child: Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(vertical: 20),
          alignment: Alignment.center,
          child:Text('Create User',
        style: GoogleFonts.lato(
                      textStyle: TextStyle(color: gray, letterSpacing: .5,fontSize:20),
                    ),)),
        Container(
            decoration: BoxDecoration(
              color: whitey.withOpacity(0.25),
              borderRadius: new BorderRadius.circular(10.0),
            ),
            child: Padding(
                padding:
                    EdgeInsets.only(left: 15, right: 15, top: 5),
                child: TextFormField(
                  controller: _fname,
                  focusNode: _focusFname,
                  validator: (value) => Validator.validateName(
                    name: value,
                  ),
                    obscureText: false,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: 'First Name',
                      hoverColor: Colors.black54,
                      focusColor: Colors.black45,
                    )))),
        SizedBox(height: 8.0),
        Container(
            decoration: BoxDecoration(
              color: whitey.withOpacity(0.25),
              borderRadius: new BorderRadius.circular(10.0),
            ),
            child: Padding(
                padding:
                    EdgeInsets.only(left: 15, right: 15, top: 5),
                child: TextFormField(
                  controller: _lname,
                  focusNode: _focusLname,
                  validator: (value) => Validator.validateName(
                    name: value,
                  ),
                    obscureText: false,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Last Name',
                      hoverColor: Colors.black54,
                      focusColor: Colors.black45,
                    )))),
        SizedBox(height: 8.0),
        
         Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
            decoration: BoxDecoration(
              color: whitey.withOpacity(0.25),
              borderRadius: new BorderRadius.circular(10.0),
            ),
            child:Container(
              padding: EdgeInsets.only(left: 15),
                width: MediaQuery.of(context).size.width,
                child:DropdownButton(
                
                value: dropdownvalue,
                  icon: Icon(Icons.keyboard_arrow_down),
                  items:items.map((String items) {
                       return DropdownMenuItem(
                           value: items,
                           child: Text(items)
                       );
                  }
                  ).toList(),
                onChanged: (String? newValue) {
                    setState(() {
                      dropdownvalue = newValue!;
                    });
                  },
              ),))
            ],
          ),
          
          SizedBox(height: 8.0),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
            decoration: BoxDecoration(
              color: whitey.withOpacity(0.25),
              borderRadius: new BorderRadius.circular(10.0),
            ),
            child:Container(
              padding: EdgeInsets.only(left: 15),
                width: MediaQuery.of(context).size.width,
                child:DropdownButton(
                
                value: _gradeLevel,
                  icon: Icon(Icons.keyboard_arrow_down),
                  items:grade_levels.map((String items) {
                       return DropdownMenuItem(
                           value: grade_levels.indexOf(items),
                           child: Text(items)
                       );
                  }
                  ).toList(),
                onChanged: (int? newValue) {
                    setState(() {
                      _gradeLevel = newValue!;
                    });
                  },
              ),))
            ],
          ),
          
          SizedBox(height: 8.0),
          Container(
            decoration: BoxDecoration(
              color: whitey.withOpacity(0.25),
              borderRadius: new BorderRadius.circular(10.0),
            ),
            child: Padding(
                padding:
                    EdgeInsets.only(left: 15, right: 15, top: 5),
                child: TextFormField(
                  controller: _email,
                  focusNode: _focusEmail,
                  validator: (value) => Validator.validateEmail(
                    email: value,
                  ),
                    obscureText: false,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Email Address',
                      hoverColor: Colors.black54,
                      focusColor: Colors.black45,
                    )))),
          SizedBox(height: 8.0),
          Container(
            decoration: BoxDecoration(
              color: whitey.withOpacity(0.25),
              borderRadius: new BorderRadius.circular(10.0),
            ),
            child: Padding(
                padding:
                    EdgeInsets.only(left: 15, right: 15, top: 5),
                child: TextFormField(
                  controller: _pass,
                  focusNode: _focusPass,
                  validator: (value) => Validator.validatePassword(
                    password: value,
                  ),
                    obscureText: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Password',
                      hoverColor: Colors.black54,
                      focusColor: Colors.black45,
                    )))),
          SizedBox(height: 8.0),
        _isProcessing ? CircularProgressIndicator()
          :button(first: lightgreen, second:green, 
                        size:16.0, height:50.0, width:MediaQuery.of(context).size.width*.5, text:'Create User',
                        onTap: () async{
                          _focusFname.unfocus();
                          _focusFname.unfocus();

                              if (_formKey.currentState!
                                  .validate()) {
                                setState(() {
                                  _isProcessing = true;
                                });
                              
                                addUser();
                                setState(() {
                                  _isProcessing = false;
                                });
                              // showDialog(
                              //   context:context,
                              //   builder: (BuildContext context)=>
                              //   PopupDialog(title: 'Sucess', description: 'Account Created Successfully', buttonText: 'Continue', path: 'assets/images/explorer.png'));
                                
                              //   setState(() {
                              //     _isProcessing = false;
                              //   });
                                
                        }})
                              
      ]))
    ).addNeumorphism());
  }
  
}
