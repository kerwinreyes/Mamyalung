import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mamyalung/responsive.dart';
import 'package:mamyalung/screens/custom/badge_message.dart';
import '../../materials.dart';
import 'package:mamyalung/widgets/buttons.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'homepage.dart';

class MultipleChoice extends StatefulWidget {
  final String? uid;
  const MultipleChoice({ Key? key, required this.uid }) : super(key: key);

  @override
  _MultipleChoiceState createState() => _MultipleChoiceState();
}
  
class _MultipleChoiceState extends State<MultipleChoice> {


  int gradeLevel = 2;
  @override
  Widget build(BuildContext context) {
  //List<dynamic> getLevel;
  //getLevel = readJson() as List;
  //print(getLevel);
    // setState(() {
    // FirebaseFirestore.instance
    // .collection('users')
    // .where('uid', isEqualTo: widget.uid)
    // .get()
    // .then((QuerySnapshot querySnapshot) {  
    //     querySnapshot.docs.forEach((doc) {
    //       gradeLevel = doc.data()['grade_level'];
    // });
    // });
    // });
    
    return Scaffold(
      appBar: AppBar(title: Text("Topic")),
      backgroundColor:Color(0xFFF4F3E3),
      body: Container(
        child: Responsive(
          desktop: Container(),
          tablet: Container(),
          mobile: MultipleBody(uid: widget.uid)
        )
      )
    );
  }
}

  
class MultipleBody extends StatefulWidget {
  final String? uid;
  
  const MultipleBody({ Key? key, required this.uid }) : super(key: key);
  
  @override
  _MultipleBodyState createState() => _MultipleBodyState();
}




class _MultipleBodyState extends State<MultipleBody> {
  int finalScore = 0;
  int index = 0;
  String next = "Next";
  bool answer = false;
  bool isButtonPressed0 = false , isButtonPressed1 = false,isButtonPressed2 = false,isButtonPressed3 = false;
  reset()
 {
   setState(() {
     index = 0;
     finalScore =0;
   });
 }

 check(int index, int length){
   if(index + 1 == length){
       setState(() {
         next = "Submit";
       });
      }
 }
 correct(bool check){
   if(check){
     final snackbar = SnackBar(
      duration: Duration(milliseconds : 500),
      backgroundColor: Colors.green,
      content: Text("Correct!"),);
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
    
    if(next == "Submit"){

    }
    else{
      setState(() {
      index+= 1;
      finalScore += 10;
      isButtonPressed0 = false;  
      isButtonPressed1 = false;
      isButtonPressed2 = false;
      isButtonPressed3 = false;
      answer = false;
    });
    }
    
    
     
   }
   else{
     final snackbar = SnackBar(
      duration: Duration(milliseconds : 500),
      backgroundColor: Colors.red,
      content: Text("Wrong!"),);
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
   }
 }


  @override
  Widget build(BuildContext context) {
    return Container(
          child: Center(
            // Use future builder and DefaultAssetBundle to load the local JSON file
            child: FutureBuilder(
                future: DefaultAssetBundle
                    .of(context)
                    .loadString('assets/questions/Pagpapakilala_sa_Sarili.json'),
                builder: (context, snapshot) {

                  if(snapshot.hasError){
                    print('error');
                  }
                  if(snapshot.hasData){
                   
                  // Decode the JSON
                  var data = json.decode(snapshot.data.toString());
                  return Container(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,

            children: <Widget>[

              // Container(height: 400,
              // width: 500,
              // decoration: BoxDecoration(
              //   image: DecorationImage(image: AssetImage("images/png.png"),
              //   fit: BoxFit.fill ),
              //   ),
              // ),

              Padding(padding: EdgeInsets.only(top: 30)),
              Container(
                child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text("Question ${index + 1} / ${data.length}",style: TextStyle(color : Colors.brown , 
                    fontSize: 20,fontWeight: FontWeight.bold),),
                    Text("Score : $finalScore",style: TextStyle(color : Colors.brown , 
                    fontSize: 20,fontWeight: FontWeight.bold),),
                    
                
                    InkWell(
                     child: Text("Reset Game",style: TextStyle(fontSize: 18,color: Colors.redAccent,fontWeight: FontWeight.bold),),
                     onTap: reset,
                   )

                 ],
               ),
              
              ),

             Padding(padding: EdgeInsets.only(top: 30)),
              
              Container(
                    decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(color: Color(0xFFF7C229))
                  ),
                  height: 90.0,
                  width: 400,
                     child: Column(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: <Widget>[
                         Padding(
                           padding: EdgeInsets.only(left: 20, right: 20),
                           child: 
                            AutoSizeText(data[index]['question'],textAlign: TextAlign.center,style: TextStyle(fontSize: 30.0,height: 0),maxLines: 2,maxFontSize: 18,
                         
                         )),
                       ],
                     ),             
                     
               ),

              Padding(padding: EdgeInsets.only(top: 30)),
                      
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                   
                button(first: isButtonPressed0 ? green : lightBlue, 
                     second: isButtonPressed0 ? green : primaryBlue, 
                     size: 15, 
                     height: 60, 
                     width: 100, 
                     text:"${data[index]['multiple_choice'][0]}",
                     onTap: (){
                       
                       setState(() {
                        isButtonPressed0 = true;  
                        isButtonPressed1 = false;
                        isButtonPressed2 = false;
                        isButtonPressed3 = false;
                       });
                       if(data[index]['multiple_choice'][0] == data[index]['multiple_choice'][data[index]['answer']]){
                         answer = true;
                       }
                       
                     }
                    ),
                 
                button(first: isButtonPressed1 ? green : lightBlue, 
                     second: isButtonPressed1 ? green : primaryBlue, 
                     size: 15, 
                     height: 60, 
                     width: 100, 
                     text:"${data[index]['multiple_choice'][1]}",
                     onTap: (){
                       setState(() {

                        isButtonPressed0 = false;  
                        isButtonPressed1 = true;
                        isButtonPressed2 = false;
                        isButtonPressed3 = false;
                       });
                       if(data[index]['multiple_choice'][1] == data[index]['multiple_choice'][data[index]['answer']]){
                         answer = true;
                       }
                       
                     }
                    ),
                ],
              ),
              
              
              Padding(padding: EdgeInsets.only(top: 30)),
                      
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                   
                 button(first: isButtonPressed2 ? green : lightBlue, 
                     second: isButtonPressed2 ? green : primaryBlue, 
                     size: 15, 
                     height: 60, 
                     width: 100, 
                     text:"${data[index]['multiple_choice'][2]}",
                     onTap: (){
                       setState(() {
                        isButtonPressed0 = false;  
                        isButtonPressed1 = false;
                        isButtonPressed2 = true;
                        isButtonPressed3 = false;
                       });
                       if(data[index]['multiple_choice'][2] == data[index]['multiple_choice'][data[index]['answer']]){
                         answer = true;
                       }
                       
                     }
                    ),


               button(first: isButtonPressed3 ? green : lightBlue, 
                     second: isButtonPressed3 ? green : primaryBlue, 
                     size: 15, 
                     height: 60, 
                     width: 100, 
                     text:"${data[index]['multiple_choice'][3]}",
                     onTap: (){
                       setState(() {
                        isButtonPressed0 = false;  
                        isButtonPressed1 = false;
                        isButtonPressed2 = false;
                        isButtonPressed3 = true;
                       });
                       if(data[index]['multiple_choice'][3] == data[index]['multiple_choice'][data[index]['answer']]){
                         answer = true;
                       }
                     }
                    ),
                ],
              ),

              Padding(padding: EdgeInsets.only(top: 30,)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                   
                button(first: lightBlue, 
                     second: primaryBlue, 
                     size: 15, 
                     height: 60, 
                     width: 100, 
                     text:"$next",
                     onTap: (){
                       if(next == "Submit" && index + 1 == data.length){
                          finalScore += 10;
                          Navigator.pushReplacement(
                            context,
                            //MaterialPageRoute(builder: (context) => BadgeMsg(uid: widget.uid)),\
                            MaterialPageRoute(builder: (context) => StudentHomePage(uid: widget.uid)),
                        );
                       }
                          correct(answer);
                          check(index, data.length);
                       
                    }
                  ),
                ],
              ),
             ],
          ),
      );
                } return CircularProgressIndicator();
                }),
        ));
          //         return ListView.builder(
          //           // Build the ListView
          //           itemCount: data == null ? 0 : data.length,
          //           itemBuilder: (BuildContext context, int index) {
          //             return Container(
          //                 margin: const EdgeInsets.all(10.0),
          //                 alignment: Alignment.topCenter,
          //                 child: new Column(
          //                   children: <Widget>[
          //                     new Padding(padding: EdgeInsets.all(20.0)),

          //                       new Container(
          //                         alignment: Alignment.centerRight,
          //                         child: new Row(
          //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                           children: <Widget>[

          //                             new Text("Question ${index + 1} of ${data.length}",
          //                             style: new TextStyle(
          //                                 fontSize: 22.0
          //                             ),),

          //                             new Text("Score: $finalScore",
          //                               style: new TextStyle(
          //                                   fontSize: 22.0
          //                               ),)
          //                           ],
          //                         ),
          //                       ),
          //       //image
          //       new Padding(padding: EdgeInsets.all(10.0)),
          //       Container(
          //         child:
          //       new Image(image: NetworkImage(
          //         "https://i.ibb.co/kVT8hHn/Artboard-1flashcards.png",
          //       ))),

          //       new Padding(padding: EdgeInsets.all(10.0)),

          //       new Text(data[index]['question'],
          //         style: new TextStyle(
          //           fontSize: 20.0,
          //         ),),

          //       new Padding(padding: EdgeInsets.all(10.0)),

          //       new Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //         children: <Widget>[

          //           //button 1
          //           new MaterialButton(
          //             minWidth: 120.0,
          //             color: Colors.blueGrey,
          //             onPressed: (){
          //               if(data[index]['multiple_choice'][0] == data[index]['multiple_choice'][data[index]['answer']]){
          //                 debugPrint("Correct");
          //                 finalScore++;
          //               }else{
          //                 debugPrint("Wrong");
          //               }
          //             },
          //             child: new Text(data[index]['multiple_choice'][0],
          //               style: new TextStyle(
          //                   fontSize: 20.0,
          //                   color: Colors.white
          //               ),),
          //           ),

          //           //button 2
          //           new MaterialButton(
          //             minWidth: 120.0,
          //             color: Colors.blueGrey,
          //             onPressed: (){
          //               if(data[index]['multiple_choice'][1] == data[index]['multiple_choice'][data[index]['answer']]){
          //                 debugPrint("Correct");
          //                 finalScore++;
          //               }else{
          //                 debugPrint("Wrong");
          //               }
          //             },
          //             child: new Text(data[index]['multiple_choice'][1],
          //               style: new TextStyle(
          //                   fontSize: 20.0,
          //                   color: Colors.white
          //               ),),
          //           ),

          //         ],
          //       ),

          //       new Padding(padding: EdgeInsets.all(10.0)),

          //       new Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //         children: <Widget>[

          //           //button 3

                    
          //           new MaterialButton(
          //             minWidth: 120.0,
          //             color: Colors.blueGrey,
          //             onPressed: (){
          //               if(data[index]['multiple_choice'][2] == data[index]['multiple_choice'][data[index]['answer']]){
          //                 debugPrint("Correct");
          //                 finalScore++;
          //               }else{
          //                 debugPrint("Wrong");
          //               }
          //             },
          //             child: new Text(data[index]['multiple_choice'][2],
          //               style: new TextStyle(
          //                   fontSize: 20.0,
          //                   color: Colors.white
          //               ),),
          //           ),

          //           //button 4
          //           new MaterialButton(
          //             minWidth: 120.0,
          //             color: Colors.blueGrey,
          //             onPressed: (){
          //               if(data[index]['multiple_choice'][3] == data[index]['multiple_choice'][data[index]['answer']]){
          //                 debugPrint("Correct");
          //                 finalScore++;
          //               }else{
          //                 debugPrint("Wrong");
          //               }
          //             },
          //             child: new Text(data[index]['multiple_choice'][3],
          //               style: new TextStyle(
          //                   fontSize: 20.0,
          //                   color: Colors.white
          //               ),),
          //           ),

          //         ],
          //       ),

          //       new Padding(padding: EdgeInsets.all(15.0)),

          //       // new Container(
          //       //   alignment: Alignment.bottomCenter,
          //       //   child:  new MaterialButton(
          //       //       minWidth: 240.0,
          //       //       height: 30.0,
          //       //       color: Colors.red,
          //       //       onPressed: resetQuiz,
          //       //       child: new Text("Quit",
          //       //         style: new TextStyle(
          //       //             fontSize: 18.0,
          //       //             color: Colors.white
          //       //         ),)
          //       //   )
          //       // ),
          //     ],
          //   ),
          // );
          //           },

                    
          //         );
          //       }),
     
  }
}