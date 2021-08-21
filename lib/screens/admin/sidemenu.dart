import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:mamyalung/responsive.dart';
import 'package:mamyalung/extension.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../../materials.dart';
class AdminSideMenu extends StatefulWidget {
  const AdminSideMenu({ Key? key }) : super(key: key);

  @override
  _AdminSideMenuState createState() => _AdminSideMenuState();
}

class _AdminSideMenuState extends State<AdminSideMenu> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      key: _scaffoldKey,
     
      body: Container(
        padding: EdgeInsets.only(top: kIsWeb ? kDefaultPadding : 0),
        color: kBgLightColor,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: Column(
              children: [
                Row(
                  children: [
                    Spacer(),
                    if(!Responsive.isDesktop(context)) CloseButton(),
                  ],
                ),
                SizedBox(height: kDefaultPadding,),
                TextButton.icon(
                 
                onPressed: () {},
                icon: Icon(Icons.ac_unit),
                label: Text(
                  "New message",
                  style: TextStyle(color: Colors.white),
                ),).addNeumorphism(
                  topShadowColor: Colors.white,
                  botShadowColor: Color(0xFF234395).withOpacity(0.2),
                ),
                SizedBox(height: kDefaultPadding),
                TextButton.icon(
                 
                onPressed: () {},
                icon: Icon(Icons.ac_unit),
                label: Text(
                  "Get message",
                  style: TextStyle(color: Colors.white),
                ),).addNeumorphism(
                ),
                SizedBox(height: kDefaultPadding * 2),
              // Menu Items
              

              SizedBox(height: kDefaultPadding * 2),
              // Tags
              ],
            ),
          ),
        )
      ),
    );
  }
}