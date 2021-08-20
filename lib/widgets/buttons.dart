import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mamyalung/materials.dart';

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
                style: TextStyle(fontSize: size,),
              ),
            ),
          ));
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