import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
class AddUser extends StatefulWidget {
  static const String routeName = '/admin/adduser';
  const AddUser({ Key? key }) : super(key: key);

  @override
  _AddUserState createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  
  
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
            child: Text("Flutter Step-by-Step",
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
            Text('Mamyalung',style:TextStyle(color:Colors.black54))
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
          Navigator.pushReplacementNamed(context, Routes.adminprofile),),
          _createDrawerItem(icon: Icons.face, text: 'Profile',),
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
  final _role = TextEditingController();
  final _email = TextEditingController();
  final _token = TextEditingController();
  
  final _focusFname = FocusNode();
  final _focusLname = FocusNode();
  final _focusEmail = FocusNode();
  final _focusToken = FocusNode();
  String dropdownvalue = 'Student';
  var items =  ['Student','Teacher'];
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  Future<void> addUser() {
      // Call the user's CollectionReference to add a new user
      return users
          .add({
           'fname': _fname.text,
            'lname':_lname.text,
            'email':_email.text,
            'role':dropdownvalue.toLowerCase(),
            'uid':'',
            'invite':0,

          })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
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
      },
      child:Container(
        padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
        color: Colors.white70,
        height: MediaQuery.of(context).size.height/1.5,
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
                        }})
                              
      ]))
    ).addNeumorphism());
  }
}
