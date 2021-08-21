import 'package:flutter/material.dart';
import 'package:mamyalung/materials.dart';
import 'package:mamyalung/screens/custom/custom.dart';

class Badges extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return 
     Container(
          child: ListView(
            children: <Widget>[
              Container(
                color: primaryBlue,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    border: Border.all(width: 5.0, color: Colors.white),
                    //borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child:  BadgeTap(
                            buttonText: "PAKYU KERWIN",
                            description: "TANIDAMO KERWIN",
                            path: 'assets/images/explorer.png',
                            title: "PAKYU",
                          ),
                        ),
                        Expanded(
                          child:  BadgeTap(
                            buttonText: "PAKYU KERWIN",
                            description: "TANIDAMO KERWIN",
                            path: 'assets/images/explorer.png',
                            title: "PAKYU",
                          ),
                        ),
                        Expanded(
                          child:  BadgeTap(
                            buttonText: "PAKYU KERWIN",
                            description: "TANIDAMO KERWIN",
                            path: 'assets/images/explorer.png',
                            title: "PAKYU",
                          ),
                        )
                      ],
                    ),
                  )
                ),
              ),
              Container(
                color: primaryBlue,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    border: Border.all(width: 5.0, color: Colors.white),
                    //borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child:  BadgeTap(
                            buttonText: "PAKYU KERWIN",
                            description: "TANIDAMO KERWIN",
                            path: 'assets/images/explorer.png',
                            title: "PAKYU",
                          ),
                        ),
                        Expanded(
                          child:  BadgeTap(
                            buttonText: "PAKYU KERWIN",
                            description: "TANIDAMO KERWIN",
                            path: 'assets/images/explorer.png',
                            title: "PAKYU",
                          ),
                        ),
                        Expanded(
                          child:  BadgeTap(
                            buttonText: "PAKYU KERWIN",
                            description: "TANIDAMO KERWIN",
                            path: 'assets/images/explorer.png',
                            title: "PAKYU",
                          ),
                        )
                      ],
                    ),
                  )
                ),
              ),
            ],
          ),
        );
  }
}