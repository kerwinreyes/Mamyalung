import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mamyalung/components/routes.dart';
import 'package:mamyalung/materials.dart';
import 'package:mamyalung/model/users.dart';
import 'package:mamyalung/responsive.dart';
import 'package:mamyalung/screens/achievements.dart';
import 'package:mamyalung/loginpage.dart';
import 'package:mamyalung/screens/students/cards.dart';
import 'package:mamyalung/screens/students/leaderboard.dart';
import 'package:mamyalung/screens/students/quiz.dart';
import 'package:mamyalung/widgets/buttons.dart';
import 'package:mamyalung/widgets/usertable.dart';
import 'package:mamyalung/extension.dart';

class StudentHomePage extends StatefulWidget {
  static const String routeName = '/student';
  final String? uid;
  const StudentHomePage({ Key? key, this.uid }) : super(key: key);

  @override
  _StudentHomePageState createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {

  @override
  Widget build(BuildContext context) {
    return StudentsMobile(uid: widget.uid);
  }
}

class StudentsMobile extends StatefulWidget {
  final String? uid;
  const StudentsMobile({ Key? key, required this.uid  }) : super(key: key);

  @override
  _StudentsMobileState createState() => _StudentsMobileState();
}

class _StudentsMobileState extends State<StudentsMobile> {

  String imagePath= '';
    int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState(){
    super.initState();
    _pageController = PageController();
    FirebaseFirestore.instance
    .collection('users')
    .where('uid',isEqualTo:widget.uid)
    .get()
    .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
            setState((){
             imagePath = doc["image"];
            });
        });
    });
  }

  @override
  void dispose(){
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
     appBar: AppBar(
       leading: Container(
         margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
         decoration: BoxDecoration(
           shape: BoxShape.circle,
           color: Colors.white
         ),
         child: imagePath ==''? CircularProgressIndicator(
    backgroundColor: Colors.cyanAccent,
    valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
  ):Image(image: NetworkImage(imagePath),height: 25.0,fit:BoxFit.cover,)),
       title: Container(
         child: Image(height: 50.0,image: NetworkImage('https://i.ibb.co/gghzqTq/mamyalung-logo.png'),fit: BoxFit.cover,),
       ),
       centerTitle: true,
       elevation: 0,
       shadowColor: primaryBlue,
       backgroundColor: Colors.white.withOpacity(0.2),
       actions: [
          IconButton(
              icon: Icon(
                Icons.exit_to_app,
                color: Colors.black,
              ),
              onPressed: () {
                FirebaseAuth auth = FirebaseAuth.instance;
                auth.signOut().then((res) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                      (Route<dynamic> route) => false);
                });
              },
            )
       ],
     ),
     body:  SizedBox.expand(
      child: PageView(
        controller: _pageController,
        onPageChanged: (index){
          setState(() => _currentIndex = index);
        },
        children: [
          QuizState(uid: widget.uid,),
          QuizCard(uid: widget.uid),
          Achievement(uid: widget.uid),
          LeaderBoard(),
        ],
      ),),
    bottomNavigationBar: BottomNavyBar(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      showElevation: true,
        itemCornerRadius: 24,
        curve: Curves.easeIn,
      selectedIndex: _currentIndex,
      onItemSelected: (index){
        setState(()=> _currentIndex = index);
        _pageController.jumpToPage(index);
      },
      items: [
       BottomNavyBarItem(
            title: Text('Home', textAlign: TextAlign.center),
            icon: Icon(Icons.school_outlined),
            activeColor: kGrayColor,
            inactiveColor: Color.fromRGBO(74, 104, 116 , 1)
          ),
          BottomNavyBarItem(
            title: Text('Games', textAlign: TextAlign.center),
            icon: Icon(Icons.sports_esports_outlined),
            activeColor: kGrayColor,
            inactiveColor: Color.fromRGBO(74, 104, 116 , 1)
          ),
          BottomNavyBarItem(
            title: Text('Badges', textAlign: TextAlign.center),
            icon: Icon(Icons.emoji_events_outlined),
            activeColor: kGrayColor,
            inactiveColor: Color.fromRGBO(74, 104, 116 , 1)
          ),
          BottomNavyBarItem(
            title: Text('Leaderboard', textAlign: TextAlign.center),
            icon: Icon(Icons.leaderboard_outlined),
            activeColor: kGrayColor,
            inactiveColor: Color.fromRGBO(74, 104, 116 , 1)
          ),
      ],
    ),
    );
  }
}