import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mamyalung/screens/custom/badges.dart';
import 'package:mamyalung/responsive.dart';
import 'package:mamyalung/screens/students/leaderboard.dart';
import 'package:mamyalung/screens/teacher/questions.dart';
import '../../loginpage.dart';
import '../../materials.dart';


class TeacherHomePage extends StatefulWidget {
  final String? uid;
  const TeacherHomePage({ Key? key, required this.uid }) : super(key: key);

  @override
  _TeacherHomePageState createState() => _TeacherHomePageState();
}

class _TeacherHomePageState extends State<TeacherHomePage> {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('questions').snapshots();
  @override
  Widget build(BuildContext context) {
    return TeacherDashboard(uid: widget.uid);
  }
}


class TeacherDashboard extends StatefulWidget {
  final String? uid;
  const TeacherDashboard({ Key? key, required this.uid }) : super(key: key);

  @override
  _TeacherDashboardState createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
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
       elevation: 5,
       shadowColor: primaryBlue,
       backgroundColor: lightBlue,
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
          Questions(uid: widget.uid),
          Container(),
          Container(),
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