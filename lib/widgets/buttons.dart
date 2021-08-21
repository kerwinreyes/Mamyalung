import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mamyalung/materials.dart';
import 'package:mamyalung/extension.dart';
Widget button({required Color first, required Color second, 
required double size, required double height, required double width, required String text,GestureTapCallback? onTap}){
  return ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
              elevation: 5,
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20))),
          child: Ink(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [first, second]),
                borderRadius: BorderRadius.circular(20)),
            child: Container(
              width: width,
              height: height,
              alignment: Alignment.center,
              child: Text(
                text,
                style: GoogleFonts.lato(
                      textStyle: TextStyle(color: Colors.white, fontSize: size, fontWeight: FontWeight.bold),
                    ),
              ),
            ),
          )).addNeumorphism();
}
Widget buttonwithIcon({required Icon ic, required Color first, required Color second, 
required double size, required double height, required double width, required String text,GestureTapCallback? onTap}){
  return ElevatedButton.icon(
          
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20))),
          icon: ic,
                label: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Ink(
            decoration: BoxDecoration(
              

                gradient: LinearGradient(colors: [first, second]),
                borderRadius: BorderRadius.circular(20)),
            child: Container(
              width: width,
              height: height,
              alignment: Alignment.center,
              child: Text(
                text,
                style: GoogleFonts.lato(
                      textStyle: TextStyle(color: gray, letterSpacing: .5),
                    ),
              ),
            ),
          )));
}

  
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