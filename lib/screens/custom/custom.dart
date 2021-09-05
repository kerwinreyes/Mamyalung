import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mamyalung/materials.dart';

class Consts {
  Consts._();

  static double padding = 16.0;
  static double avatarRadius = 66.0;
}

class CustomDialog extends StatelessWidget {
  final String title, description, buttonText;

  final String path;
  

  CustomDialog({
    required this.title,
    required this.description,
    required this.buttonText,
    required this.path
  });

  dialogContent(BuildContext context) {
  return Stack(
    children: <Widget>[
      Container(
  padding: EdgeInsets.only(
    top: Consts.avatarRadius + Consts.padding,
    bottom: MediaQuery.of(context).padding.bottom,
    left: Consts.padding,
    right: Consts.padding,
  ),
  margin: EdgeInsets.only(top: Consts.avatarRadius),
  decoration: new BoxDecoration(
    color: Colors.white,
    shape: BoxShape.rectangle,
    borderRadius: BorderRadius.circular(Consts.padding),
    boxShadow: [
      BoxShadow(
        color: Colors.black26,
        blurRadius: 10.0,
        offset: const Offset(0.0, 10.0),
      ),
    ],
  ),

    child: 
      Column(
    mainAxisSize: MainAxisSize.min, // To make the card compact
    children: <Widget>[
      Text(
        title,
        style: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.w700,
          color: Colors.black
        ),
      ),
      SizedBox(height: 16.0),
      Text(
        description,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20.0,
          color: Colors.black
        ),
      ),
      Align(
        alignment: Alignment.bottomRight,
        child: TextButton(
          onPressed: () { 
            Navigator.of(context).pop(); // To close the dialog
          },
          child: Text(buttonText,
          style: TextStyle(color: Colors.black)),
        ),
      ),
      
    ],
  ),
),

Positioned(
  left: Consts.padding,
  right: Consts.padding,
  child: CircleAvatar(
    backgroundColor: Colors.white,
    radius: Consts.avatarRadius,
    child: Image(image: NetworkImage(path),
      fit: BoxFit.cover,)

  ),
),
    ],
  );
}

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Consts.padding),
      ),      
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }
}

class BadgeTap extends StatelessWidget {

  final String title, description, buttonText,path, trueMsg, falseMsg;
  final int points,min,max;
  final bool lock;
  BadgeTap({
    required this.lock,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.path,
    required this.points,
    required this.min,
    required this.max,
    required this.trueMsg,
    required this.falseMsg,
  });
  @override
  Widget build(BuildContext context) {
    if(lock == true){
      return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) => CustomDialog(
            title: title,
            description: points >= min && points <= max ? "$trueMsg" : "$falseMsg",
            buttonText: buttonText,
            path: path,
          ),
        );
      },
      child: Image(image: NetworkImage('$path'),
         width: 110.0, height: 110.0));        
  }
  else{
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) => CustomDialog(
            title: title,
            description: points >= min && points <= max ? "$trueMsg" : "$falseMsg",
            buttonText: buttonText,
            path: 'https://i.ibb.co/BtzTdHq/locked.png',
          ),
        );
      },
      child: Image(image: NetworkImage('https://i.ibb.co/BtzTdHq/locked.png'),
         width: 110.0, height: 110.0));
 
  }       
  }
}
class PopupDialog extends StatelessWidget {
  final String title, description, buttonText;

  final String path;


  PopupDialog({
    required this.title,
    required this.description,
    required this.buttonText,
    required this.path
  });

  dialogContent(BuildContext context) {
  return Stack(
    children: <Widget>[
      Container(
  width: 250,
  padding: EdgeInsets.only(
    top: Consts.avatarRadius + Consts.padding,
    bottom: MediaQuery.of(context).padding.bottom,
    left: Consts.padding,
    right: Consts.padding,
  ),
  margin: EdgeInsets.only(top: Consts.avatarRadius),
  decoration: new BoxDecoration(
    color: Colors.white,
    shape: BoxShape.rectangle,
    borderRadius: BorderRadius.circular(Consts.padding),
    boxShadow: [
      BoxShadow(
        color: Colors.black26,
        blurRadius: 10.0,
        offset: const Offset(0.0, 10.0),
      ),
    ],
  ),

    child: 
      Column(
    mainAxisSize: MainAxisSize.min, // To make the card compact
    children: <Widget>[
      Text(
        title,
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w700,
          color: Colors.black
        ),
      ),
      SizedBox(height: 16.0),
      Text(
        description,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.black
        ),
      ),
      Align(
        alignment: Alignment.bottomRight,
        child: TextButton(
          onPressed: () { 
            Navigator.of(context).pop(); // To close the dialog
          },
          child: Text(buttonText,
          style: TextStyle(color: Colors.black)),
        ),
      ),
      
    ],
  ),
),

Positioned(
  height:250,
  width: 250,
  left: Consts.padding,
  right: Consts.padding,
  child: CircleAvatar(
    backgroundColor: green,
    radius: Consts.avatarRadius,
    child: Icon(Icons.check_circle_sharp)

  ),
),
    ],
  );
}

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Consts.padding),
      ),      
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }
}