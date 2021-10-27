
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mamyalung/utils/validator.dart';
import 'components/routes.dart';
import 'materials.dart';

class ForgotPassword extends StatefulWidget {
  static const String routeName = '/forgotpassword';
  const ForgotPassword({ Key? key }) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  static final _email = FocusNode();
  bool isProcessing = false;
  static final _formKey = new GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var screenSizeW = screenSize.width;
    var screenSizeH = screenSize.height;
    return GestureDetector(
      onTap: () {
        _email.unfocus();
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

                                            controller: emailController,
                                            focusNode: _email,
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
                                       
                                        SizedBox(height: 15.0),
                                        
                                            isProcessing
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
                                                              isProcessing =
                                                                  true;
                                                            });
                                                          if (_formKey
                                                              .currentState!
                                                              .validate()) {
                                                          try {
                                                          await auth.sendPasswordResetEmail(email: emailController.text);
                                                          showDialog(
                                                          context: context,
                                                          builder: (BuildContext context) {
                                                            return AlertDialog(
                                                              title: Text("Message"),
                                                              content: Text('We have send a reset password email to your email address'),
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
                                                          } on FirebaseAuthException catch (e) {
                                                            showDialog(
                                                          context: context,
                                                          builder: (BuildContext context) {
                                                            return AlertDialog(
                                                              title: Text("Message"),
                                                              content: Text('$e.message'),
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
                                                          print(e.code);
                                                          print(e.message);
                                                          // show the snackbar here
                                                          }
                                                            setState(() {
                                                              isProcessing =
                                                                  false;
                                                            });
                                                          }
                                                          setState(() {
                                                              isProcessing =
                                                                  false;
                                                            });
                                                        },
                                                  color: lightBlue,
                                                  child: Text(
                                                    'Send Email',
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
                                
                              ),
                              ),
                        
                    ),
                ],
              ),
            ),
          )
        ]
            )
            )
    );
  }
}