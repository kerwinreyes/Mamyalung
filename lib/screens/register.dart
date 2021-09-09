import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mamyalung/components/routes.dart';
import 'package:mamyalung/materials.dart';
import 'package:mamyalung/responsive.dart';
import 'package:mamyalung/screens/profile.dart';
import 'package:mamyalung/utils/fire_auth.dart';
import 'package:mamyalung/utils/validator.dart';

class RegisterPage extends StatefulWidget {
  static const String routeName = '/register';
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _registerFormKey = GlobalKey<FormState>();

  final _nameTextController = TextEditingController();
  final _lnameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _confirmpasswordController = TextEditingController();
    String dropdownvalue = 'Student';
  int _gradeLevel = 2;
  var items =  ['Student','Teacher'];
  var grade_levels = ['Grade 1','Grade 2','Grade 3'];

  //Flashcards list
  List _flashcards = [
    {
    "question": "Ano sa Kapampangan ang July?" ,
    "choices": [
        "Hunyu",
        "Hulyu"],
    "answer" : 1,
    "level": 1
    },

    {
    "question": "Ano ang Kapampangan ng birthday?" ,
    "choices": [
        "Kebaytan",
        "Banwa"],
    "answer" : 0,
    "level": 1
    },

    {
    "question": "Ano sa Kapampangan ang Tatay?" ,
    "choices": [
        "Tatang",
        "Itay"],
    "answer" : 0,
    "level": 1
    },

    {
    "question": "Ano sa Kapampangan ang 'Tuloy po kayo'?" ,
    "choices": [
        "Malawus kayu pu",
        "Mayap a bengi"],
    "answer" : 1,
    "level": 1
    },
    {
    "question": "Ano ang Kapampangan ng 'Maligayang Bagong Taon'?" ,
    "choices": [
        "Masayang aldo ning kebaytan",
        "Masayang Bayung Banwa"],
    "answer" : 1,
    "level": 1
    },

    {
    "question": "Alin sa mga sumusunod na makikatni na naguumpisa 'g' ang hindi Kapampangan?" ,
    "choices": [
        "gas",
        "gamat"],
    "answer" : 1,
    "level": 1
    },
    
    {
    "question": "Alin sa mga sumusunod na kakatni na naguumpisa sa 'i' ang hindi Kapampangan?" ,
    "choices": [
        "itlog",
        "ima"],
    "answer" : 1,
    "level": 1
    },
    
    {
    "question": "Alin ang hindi nagpapakita ng paggalang?" ,
    "choices": [
        "Makilabas ku pu",
        "Pasensya"],
    "answer" : 1,
    "level": 1
    },


    {
    "question": "Ano ang iyong sasabihin kapag may nagawa kang kasalanan?" ,
    "choices": [
        "Pasensya na pu",
        "Mayap a bengi"],
    "answer" : 0,
    "level": 1
    },

    {
    "level": 1,
    "question": "Ano ang ibig sabihin ng 'Mayap a ugtu pu' sa tagalog?",
    "topic" : "Pagtukoy ng magagalang Magagalang na Pananalita at Pagbati",
    "multiple_choice": [
    "Magandang Gabi po",
    "Magandang Tanghali po"],
    "answer": 1}
        
];
List _otherflashcard = [
        {
        "level": 1,
        "question": "Kung ang Kapampangan ng Tatang ay tatay, ano naman sa Kapampangan ang nanay?",
        "choices": [
        "Ima",
        "Apu"],
        "answer": 0},

      
        {
        "level": 1,
        "question": "Ano sa Kapampangan ang paaralan?",
        "choices": [
        "Paaralan",
        "Iskwela"],
        "answer": 1},
        
        {
        "level": 1,
        "question": "Ano ang ibig sabihin ng lagyu sa ingles?",
        "choices": [
        "address",
        "name"],
        "answer": 1},

        {
        "level": 1,
        "question": "Alin sa mga sumusunod ang hindi Kapampangan na salita?",
        "choices": [
        "kebaytan",
        "baitang"],
        "answer": 1},

        {
        "level": 1,
        "question": "Alin sa mga sumusunod ang hindi Kapampangan na salita?",
        "choices": [
        "ima",
        "usok"],
        "answer": 1},

        {
        "level": 1,
        "question": "Alin sa mga Buwan na ito ang hindi Kapampangan?",
        "choices": [
        "oktubri",
        "may"],
        "answer": 1},
        
        {
        "level": 1,
        "question": "Ano sa tagalog ang 'Makatuknang ku king'?",
        "choices": [
        "Nakatira ako sa",
        "Ako ay kabilang sa"],
        "answer": 0},

        {
        "level": 1,
        "question": "Ano sa Kapampangan ang 'Magandang hapon po'?",
        "choices": [
        "Mayap a ugtu pu",
        "Mayap a gatpanapun pu"],
        "answer": 1},

        {
        "level": 1,
        "question": "Alin ang hindi nagpapakita ng paggalang?",
        "choices": [
        "Makilabas ku pu",
        "Lumayas na ka"],
        "answer": 1},

        {
        "level": 1,
        "question": "Alin ang hindi nagpapakita ng paggalang?",
        "choices": [
        "Salamat",
        "Alang nanu man pu"],
        "answer": 0},

        {
        "level": 1,
        "question": "Ano sa Kapampangan ang Happy Birthday?",
        "choices": [
        "Masayang bayung banwa pu",
        "Masayang aldo ning kebaytan pu"],
        "answer": 1},

        {
        "level": 1,
        "question": "Ano sa Kapampangan ang Paki abot po?",
        "choices": [
        "Pakiabut pu",
        "Salamat pu"],
        "answer": 0},


        {
        "level": 1,
        "question": "Alin sa mga sumusunod na kakatni na naguumpisa sa 'a' ang hindi Kapampangan?",
        "choices": [
        "asbuk",
        "apple"],
        "answer": 1},

        {
        "level": 1,
        "question": "Alin sa mga sumusunod na kakatni na naguumpisa sa 'e' ang hindi Kapampangan?",
        "choices": [
        "egg",
        "elepanti"],
        "answer": 0},

        {
        "level": 1,
        "question": "Alin sa mga sumusunod na kakatni na naguumpisa sa 'o' ang hindi Kapampangan?",
        "choices": [
        "osu",
        "open"],
        "answer": 1},

        {
        "level": 1,
        "question": "Alin sa mga sumusunod na kakatni na naguumpisa 'u' ang hindi Kapampangan?",
        "choices": [
        "ulunan",
        "usok"],
        "answer": 1},


        {
        "level": 1,
        "question": "Alin sa mga sumusunod na makikatni na naguumpisa 'm' ang hindi Kapampangan?",
        "choices": [
        "matsing",
        "maganda"],
        "answer": 1},

        {
        "level": 1,
        "question": "Alin sa mga sumusunod na makikatni na naguumpisa 'p' ang hindi Kapampangan?",
        "choices": [
        "patawad",
        "pesus"],
        "answer": 0},

        {
        "level": 1,
        "question": "Alin sa mga sumusunod na makikatni na naguumpisa 's' ang hindi Kapampangan?",
        "choices": [
        "salol",
        "saronggola"],
        "answer": 1},

        {
        "level": 1,
        "question": "Alin sa mga sumusunod na makikatni na naguumpisa 'd' ang hindi Kapampangan?",
        "choices": [
        "dikut",
        "daga"],
        "answer": 1}
    ];
    
  final _focusName = FocusNode();
  final _focusLname = FocusNode();
  final _focusEmail = FocusNode();
  final _focusgradelvl = FocusNode();
  final _focusPassword = FocusNode();
  final _focusConfirmPassword = FocusNode();

  bool _isProcessing = false;
  CollectionReference _users = FirebaseFirestore.instance.collection('users');
  Future<void> addUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailTextController.text,
        password: _passwordTextController.text,
      );
      user = userCredential.user;
      return _users.doc(user!.uid)
            .set({
           'fname': _nameTextController.text,
            'lname':_lnameTextController.text,
            'email':_emailTextController.text,
            'role':dropdownvalue,
            'uid':user.uid,
            'points': 0,
            'grade_level': _gradeLevel,
            'flashcards':_flashcards,
            'other_flashcards': _otherflashcard,
            'day': 1,
            'image':'',

          })
          .then((value){
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
        resizeToAvoidBottomInset: false, //fix for bottom overflow
        body: Stack(children: [
        Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                 image: AssetImage("assets/images/mamyalungwithpets.png"),
                 fit: BoxFit.cover
                 ),
                ),
              ),
        Center(
          child:  SingleChildScrollView(child:Column(
            children: [
              
                  Container(
                    width: 550.0,
                    padding: EdgeInsets.only(top: screenSizeH*.20),
                    child: Center(
                      child:Column(
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
                                    labelStyle: TextStyle(color: black),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    filled: true,
                                    fillColor: white.withOpacity(0.25),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: white),),
                                    errorBorder: UnderlineInputBorder(
                                      borderRadius: BorderRadius.circular(6.0),
                                      borderSide: BorderSide(
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 16.0,),

                                Row(
                                        children: [
                                          Expanded(
                                            child: SizedBox(height: 45.0, child:
                                TextFormField(
                                  controller: _nameTextController,
                                  focusNode: _focusName,
                                  validator: (value) => Validator.validateName(
                                    name: value,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "Type your First Name",
                                    labelText: "First Name",
                                    labelStyle: TextStyle( color: Colors.black),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    filled: true,
                                    fillColor: white.withOpacity(0.25),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: white),),
                                    errorBorder: UnderlineInputBorder(
                                      borderRadius: BorderRadius.circular(6.0),
                                      borderSide: BorderSide(
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ))),
                                SizedBox(width: 10.0),
                                Expanded(
                                    child: SizedBox(height: 45.0, child:TextFormField(
                                  controller: _lnameTextController,
                                  focusNode: _focusLname,
                                  validator: (value) => Validator.validateName(
                                    name: value,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "Type your Last Name",
                                    labelText: "Last Name",
                                    labelStyle: TextStyle( color: Colors.black),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    filled: true,
                                    fillColor: white.withOpacity(0.25),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: white),),
                                    errorBorder: UnderlineInputBorder(
                                      borderRadius: BorderRadius.circular(6.0),
                                      borderSide: BorderSide(
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                )))]),
                                SizedBox(height: 16.0,),
                                Row(
                                        children: [
                                  Expanded(
                                    child: SizedBox(height: 45.0,
                                child:TextFormField(
                                  controller: _passwordTextController,
                                  focusNode: _focusPassword,
                                  obscureText: true,
                                  validator: (value) => Validator.validatePassword(
                                    password: value,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "Type your Password",
                                    labelText: "Password",
                                    labelStyle: TextStyle( color: black),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    filled: true,
                                    fillColor: white.withOpacity(0.25),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: white),),
                                    errorBorder: UnderlineInputBorder(
                                      borderRadius: BorderRadius.circular(6.0),
                                      borderSide: BorderSide(
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ))),
                                SizedBox(width: 15.0,),
                                Expanded(
                                    child: SizedBox(height: 45.0,
                                child:TextFormField(
                                  controller: _confirmpasswordController,
                                  focusNode: _focusConfirmPassword,
                                  obscureText: true,
                                  validator: (value) => Validator.validatePassword(password: value),
                                  decoration: InputDecoration(
                                    hintText: "Type your Password",
                                    labelText: " Confirm Password",
                                    labelStyle: TextStyle( color: Colors.black),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    filled: true,
                                    fillColor: white.withOpacity(0.25),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: white),),
                                    errorBorder: UnderlineInputBorder(
                                      borderRadius: BorderRadius.circular(6.0),
                                      borderSide: BorderSide(
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ))),
                                ]),
                                SizedBox(height: 16.0,),
                              
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
                                SizedBox(height: 32.0),
                                _isProcessing
                                    ? CircularProgressIndicator()
                                    : Row(
                                        children: [
                                          Expanded(
                                            child: SizedBox(height: 35.0,
                                            child: ElevatedButton(
                                              onPressed: () async {
                                                setState(() {
                                                  _isProcessing = true;
                                                });

                                                if (_registerFormKey.currentState!
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
                                              style: ElevatedButton.styleFrom(shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15.0))),
                                      child: Text(
                                        'Sign up',
                                        style: TextStyle(color: Colors.white, fontSize: 18.0),
                                              ),
                                            ),
                                          ),
                                          ),
                                          SizedBox(width: 10),
                                      Expanded(
                                        child: SizedBox( height: 35.0,
                                        child: ElevatedButton(
                                          onPressed: ()=> Navigator.pushReplacementNamed(context, Routes.loginPage),
                                          style: ElevatedButton.styleFrom(shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15.0))),
                                          child: Text(
                                            'Login',
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