

import 'package:flutter/material.dart';
import 'package:mamyalung/materials.dart';
import 'package:mamyalung/responsive.dart';

class AddLesson extends StatefulWidget {
  const AddLesson({ Key? key }) : super(key: key);

  @override
  _AddLessonState createState() => _AddLessonState();
}

class _AddLessonState extends State<AddLesson> {
  @override
  Widget build(BuildContext context) {
    return Responsive(
      desktop: Container(),
      tablet: Container(),
      mobile: AddLessonBody(),
    );
  }
}
class AddLessonBody extends StatefulWidget {
  const AddLessonBody({ Key? key }) : super(key: key);

  @override
  _AddLessonBodyState createState() => _AddLessonBodyState();
}



class _AddLessonBodyState extends State<AddLessonBody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.transparent,
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * .17,
                horizontal: MediaQuery.of(context).size.width * .17
              ),
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      //color
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20))
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          Text("hello"),
                        ],
                      ),
                      Row(
                        children: [
                          Text("hello"),
                        ],
                      ),
                      Row(
                        children: [
                          Text("hello"),
                        ],
                      )
                      
                    ],
                  ),
                ),
              ),
            )
          )  
        ]
      )
    );
  }
}