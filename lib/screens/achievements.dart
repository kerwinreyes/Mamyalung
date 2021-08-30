import 'package:flutter/material.dart';
import 'package:mamyalung/screens/custom/badges.dart';
import 'package:mamyalung/responsive.dart';

import '../materials.dart';


class Achievement extends StatefulWidget {
  final String? uid;
  const Achievement({ Key? key, required this.uid }) : super(key: key);
  @override
  _AchievementState createState() => _AchievementState();
}

class _AchievementState extends State<Achievement> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:lightBlue.withOpacity(0.5),
      body: Responsive(
        desktop: Badges(uid: widget.uid),
        mobile: Badges(uid: widget.uid),
        tablet: Badges(uid: widget.uid)
      )
    );
   
  }
}  
    