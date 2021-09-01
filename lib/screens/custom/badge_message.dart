import 'package:flutter/material.dart';
import 'package:mamyalung/screens/custom/custom.dart';


class BadgeMsg extends StatefulWidget {
  final String? uid;
  const BadgeMsg({ Key? key, required this.uid }) : super(key: key);

  @override
  _BadgeMsgState createState() => _BadgeMsgState();
}

class _BadgeMsgState extends State<BadgeMsg> {
  @override
  Widget build(BuildContext context) {
    return Stack(
        children: <Widget>[
          Container(
            color: Colors.blue,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset('assets/images/explorer.png',
                height: MediaQuery.of(context).size.height * .5),
                Expanded(
                  child: Text("\t\tCongrats! \n You just unlocked New Badge"),
                ),
                Container(
                  padding: EdgeInsets.all(8.0),
                  color: Colors.green,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Center(
                              child:(Text("Collect")
                              )
                            )
                          ),                  
                        ]
                      )
                    )
                  )
                )
              ],
            )
          ),
          // GestureDetector(
          //   onTap:(){
          //     Navigator.pop(context);
          //  }
          //) 
        ],
      );
  }
}