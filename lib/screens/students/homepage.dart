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
import 'package:mamyalung/screens/login.dart';
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
    return Responsive(
        desktop: Container(),
        tablet: Container(),
        //For mobile 
        mobile: StudentsMobile(),
    );
  }
}

class StudentsMobile extends StatefulWidget {
  const StudentsMobile({ Key? key }) : super(key: key);

  @override
  _StudentsMobileState createState() => _StudentsMobileState();
}

class _StudentsMobileState extends State<StudentsMobile> {
    int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState(){
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose(){
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(

       elevation: 5,
       backgroundColor: primaryBlue,
       actions: [
          IconButton(
              icon: Icon(
                Icons.exit_to_app,
                color: Colors.white,
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
          StudentCard(),
          QuizCard(),
          Achievement(),
          LeaderBoard(),
        ],
      ),),
    bottomNavigationBar: BottomNavyBar(
      selectedIndex: _currentIndex,
      onItemSelected: (index){
        setState(()=> _currentIndex = index);
        _pageController.jumpToPage(index);
      },
      items: [
       BottomNavyBarItem(
            title: Text('Home'),
            icon: Icon(Icons.school_outlined)
          ),
          BottomNavyBarItem(
            title: Text('Games'),
            icon: Icon(Icons.sports_esports_outlined)
          ),
          BottomNavyBarItem(
            title: Text('Badges'),
            icon: Icon(Icons.emoji_events_outlined)
          ),
          BottomNavyBarItem(
            title: Text('Leaderboard'),
            icon: Icon(Icons.leaderboard_outlined)
          ),
      ],
    ),
    );
  }
}