import 'package:flutter/material.dart';
import 'package:mamyalung/screens/custom/badges.dart';
import 'package:mamyalung/responsive.dart';



class Achievement extends StatefulWidget {

  @override
  _AchievementState createState() => _AchievementState();
}

class _AchievementState extends State<Achievement> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Responsive(
        desktop: Badges(id: 'asdas'),
        mobile: Badges(id: 'asda'),
        tablet: Badges(id: 'asdasd')
      ),
    );
  }
}  
    