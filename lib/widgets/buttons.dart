import 'package:flutter/material.dart';
import 'package:mamyalung/materials.dart';

Widget button(Color first, Color second, String font, double size, double height, double width, String text,
  final GestureTapCallback onPressed){
  return ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
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
Widget buttonwithIcon(Icon ic,Color first, Color second, String font, double size, double height, double width, String text,final GestureTapCallback onPressed){
  return ElevatedButton.icon(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.zero,
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
                style: TextStyle(fontSize: size,),
              ),
            ),
          )));
}