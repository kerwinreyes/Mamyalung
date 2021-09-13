import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mamyalung/materials.dart';
import 'package:mamyalung/model/topic.dart';
import 'package:mamyalung/utils/validator.dart';
class Topic extends StatefulWidget {
  const Topic({ Key? key }) : super(key: key);

  @override
  _TopicState createState() => _TopicState();
}

class _TopicState extends State<Topic> {
final _formKey = GlobalKey<FormState>();
bool _isProcessing = false;
      TextEditingController topicName = TextEditingController();
      String topicImage = '';
      TextEditingController topiclevel= TextEditingController();
      int grLevel = 0;
      int topicpublish =0;
List _listImage=[
'https://i.ibb.co/XY3pv1p/tile-image4.png'
];
  Random random = new Random();

      TextEditingController _searchController = TextEditingController();
      TextEditingController topicCode = TextEditingController();
   
  Future<void> createTopic() async{
    CollectionReference collectionTopic = FirebaseFirestore.instance.collection('topics'); 
  await FirebaseFirestore.instance.collection('tiles_images').get()
      .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
            _listImage.add(doc['image']);
        });
    });
  return collectionTopic.doc(topicCode.text)
   .set({
     'code':topicCode.text,
     'topic_name':topicName.text,
     'grade_level': grLevel==0 ? 2 : 3,
     'image': _listImage[random.nextInt(_listImage.length)],
     'publish':topicpublish
   }).then((value){
            showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Message"),
              content: Text('Create Topic Success'),
              actions: [
                ElevatedButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            );
          });
            print('success');
          })
          // ignore: invalid_return_type_for_catch_error
          .catchError((error) {
            showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Message"),
              content: Text('Error'),
              actions: [
                ElevatedButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            );
          });
          print('failed');
          } );
  }
  addContent(BuildContext context){
    return AlertDialog(
      contentPadding: EdgeInsets.only(bottom: 16, top: 16),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Consts.padding),
      ),      
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState){
          return SingleChildScrollView(child:Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(
                  top: Consts.avatarRadius + Consts.padding,
                  bottom: Consts.padding,
                  left: Consts.padding,
                  right: Consts.padding
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
                      offset: const Offset(0.0,10.0)
                    )
                  ]
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                    "Create Topic" + "\n",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                   
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: topicName,
                            validator: (value) => Validator.validateQuestion(ques: value),
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(),
                              focusedBorder: UnderlineInputBorder(),
                              hintText: "Enter Topic Name"
                            ),
                            onTap:(){},
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: topicCode,
                            validator: (value) => Validator.validateQuestion(ques: value),
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(),
                              focusedBorder: UnderlineInputBorder(),
                              hintText: "Enter Topic Code"
                            ),
                            onTap:(){},
                          ),
                          SizedBox(height: 20),
                          Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                  decoration: BoxDecoration(
                                    color: whitey.withOpacity(0.25),
                                    borderRadius: new BorderRadius.circular(10.0),
                                  ),
                                  child:Container(
                                    padding: EdgeInsets.only(left: 15),
                                      width: MediaQuery.of(context).size.width,
                                      child:DropdownButton(
                                      value: grLevel,
                                        icon: Icon(Icons.keyboard_arrow_down),
                                        items:['Grade 2','Grade 3'].map((String items) {
                                            return DropdownMenuItem(
                                                value:['Grade 2','Grade 3'].indexOf(items),
                                                child: Text(items)
                                            );
                                        }
                                        ).toList(),
                                      onChanged: (int? newValue) {
                                          setState(() {
                                            grLevel = newValue!;
                                          });
                                        },
                                    ),))
                                  ],
                                ),
                          Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                  decoration: BoxDecoration(
                                    color: whitey.withOpacity(0.25),
                                    borderRadius: new BorderRadius.circular(10.0),
                                  ),
                                  child:Container(
                                    padding: EdgeInsets.only(left: 15),
                                      width: MediaQuery.of(context).size.width,
                                      child:DropdownButton(
                                      value: topicpublish,
                                        icon: Icon(Icons.keyboard_arrow_down),
                                        items:['Unublish','Publish'].map((String items) {
                                            return DropdownMenuItem(
                                                value:['Unublish','Publish'].indexOf(items),
                                                child: Text(items)
                                            );
                                        }
                                        ).toList(),
                                      onChanged: (int? newValue) {
                                          setState(() {
                                            topicpublish = newValue!;
                                          });
                                        },
                                    ),))
                                  ],
                                ),
                        ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      TextButton(
                        child: Text("Create Topic"),
                        onPressed: ()  async {
                          setState(() {
                            _isProcessing = true;
                          });

                          if (_formKey.currentState!
                              .validate()) {
                             createTopic();

                            setState(() {
                              _isProcessing = false;
                            });
                          Navigator.pop(context);

                          }
                          setState(() {
                      _isProcessing = false;
                    });

                        },
                      ),
                      Spacer(),
                      TextButton(
                        child: Text("Cancel"),
                        onPressed: (){
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20)
                  ],
                )
              ),
              Positioned(
                left: Consts.padding,
                right: Consts.padding,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: Consts.avatarRadius,
                  child: Image(image: NetworkImage("https://i.ibb.co/gghzqTq/mamyalung-logo.png"),
                    fit: BoxFit.fill,)
                )
              )
            ],
          ));
        },
      ),
    );  
  }
  late Future resultsLoaded;
  List _allResults = [];
  List _resultsList = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resultsLoaded = getUser();
  }


  _onSearchChanged() {
    searchResultsList();
  }
  Future getUser() async{
    /* await  FirebaseFirestore.instance
      .collection('users')
      .get()
      .then((QuerySnapshot querySnapshot){
         querySnapshot.docs.forEach((DocumentSnapshot doc) {
            _allResult.add(doc.data());
          
        }); 
      });*/
       var data = await FirebaseFirestore.instance
        .collection('topics')
        .get();
    setState(() {
      _allResults = data.docs;
    });
    searchResultsList();
  }
  searchResultsList() {
    var showResults = [];

    if(_searchController.text != "") {
      for(var tripSnapshot in _allResults){
        var topic_name = Topics.fromSnapshot(tripSnapshot).topic_name.toLowerCase();
        var grade_level = Topics.fromSnapshot(tripSnapshot).grade_level;

        if(topic_name.contains(_searchController.text.toLowerCase()) || grade_level.toString().contains(_searchController.text)) {
          showResults.add(tripSnapshot);
        }
      }

    } else {
      showResults = List.from(_allResults);
    }
    setState(() {
      _resultsList = showResults;
    });
  }           
  @override
  Widget build(BuildContext context) {
    return Scaffold(body:SingleChildScrollView(
      child: Column(children: [
        Container(
          child: Text('Topics',
          style: TextStyle(color: Colors.white, fontSize: 18.0,fontFamily: 'Evil'),
          )
          ),
      Container(
      height: MediaQuery.of(context).size.height*.70,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child:
          GridView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              primary: false,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width < 480 ? 2 :4,
              ),
            itemBuilder: (BuildContext context, int index)=>
                  viewTopic(context, _resultsList[index]),
            itemCount: _resultsList.length,
          ))
      ],)),
    floatingActionButton: 
      FloatingActionButton( onPressed: (){
        showDialog(context: context,
          builder: (BuildContext context) => addContent(context));
      },
      child: Icon(Icons.add),
      backgroundColor: Colors.blue,
     
    ));
  }
}
Widget viewTopic(BuildContext context, DocumentSnapshot document) {
  List randomColor=[lightBlue, primaryBlue, green, lightgreen, orange, red];
  final topic = Topics.fromSnapshot(document);
 final _formKey1 = GlobalKey<FormState>();
  TextEditingController code = TextEditingController();
  TextEditingController name = TextEditingController();
  int level =topic.grade_level==3? 1 : 0;
  int publish = topic.publish;
  
    code.text= topic.code;
    name.text = topic.topic_name;
    String nameTopic = topic.topic_name;
  updateTopic(BuildContext context){
          return AlertDialog(
        contentPadding: EdgeInsets.only(bottom: 16, top: 16),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Consts.padding),
        ),      
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState){
            return SingleChildScrollView(child:Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,

                  padding: EdgeInsets.only(
                    top: Consts.avatarRadius + Consts.padding,
                    bottom: Consts.padding,
                    left: Consts.padding,
                    right: Consts.padding
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
                        offset: const Offset(0.0,10.0)
                      )
                    ]
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                      "Edit Topic:" + code.text,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                      Form(
                        key: _formKey1,
                        child: Column(
                          children: [
                            
                            SizedBox(height: 20),
                            TextFormField(
                              controller: name,
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(),
                                focusedBorder: UnderlineInputBorder(),
                                hintText: "Enter Topic Name"
                              ),
                              onTap:(){},
                            ),
                            SizedBox(height: 20),
                            Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                    Text('Grade Level'),
                                      Container(
                                    decoration: BoxDecoration(
                                      color: whitey.withOpacity(0.25),
                                      borderRadius: new BorderRadius.circular(10.0),
                                    ),
                                    child:Container(
                                      padding: EdgeInsets.only(left: 15),
                                        width: MediaQuery.of(context).size.width,
                                        child:DropdownButton(
                                        value: level,
                                          icon: Icon(Icons.keyboard_arrow_down),
                                          items:['Grade Level 2', 'Grade Level 3'].map((String items) {
                                              return DropdownMenuItem(
                                                  value: ['Grade Level 2', 'Grade Level 3'].indexOf(items),
                                                  child: Text(items)
                                              );
                                          }
                                          ).toList(),
                                        onChanged: (int? newValue) {
                                            setState(() {
                                              level = newValue!;
                                            });
                                          },
                                      ),))
                                    ],
                                  ),
                            SizedBox(height: 20),
                            Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                    decoration: BoxDecoration(
                                      color: whitey.withOpacity(0.25),
                                      borderRadius: new BorderRadius.circular(10.0),
                                    ),
                                    child:Container(
                                      padding: EdgeInsets.only(left: 15),
                                        width: MediaQuery.of(context).size.width,
                                        child:DropdownButton(
                                        value: publish,
                                          icon: Icon(Icons.keyboard_arrow_down),
                                          items:['Unpublish', 'Publish'].map((String items) {
                                              return DropdownMenuItem(
                                                  value: ['Unpublish', 'Publish'].indexOf(items),
                                                  child: Text(items)
                                              );
                                          }
                                          ).toList(),
                                        onChanged: (int? newValue) {
                                            setState(() {
                                              publish = newValue!;
                                            });
                                          },
                                      ),))
                                    ],
                                  ),
                            SizedBox(height: 20),
                          ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        TextButton(
                          child: Text("Update Topic"),
                          onPressed: () async{

                            List _listImage=[
                            'https://i.ibb.co/XY3pv1p/tile-image4.png'
                            ];
                              Random random = new Random();
                            await FirebaseFirestore.instance.collection('tiles_images').get()
                                  .then((QuerySnapshot querySnapshot) {
                                    querySnapshot.docs.forEach((doc) {
                                        _listImage.add(doc['image']);
                                    });});
                            await FirebaseFirestore.instance.collection('topics').doc(code.text)
                          .update({
                            'topic_name':name.text,
                            'grade_level':level==0 ? 2 : 3,
                            'publish': publish,
                          }).then((value){
                       
            showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Message"),
              content: Text('Topic Updated'),
              actions: [
                ElevatedButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            );
          });
                print("Topic Updated");
                setState(() {
                nameTopic = name.text;
                });
                })
            .catchError((error) => print('failed'));
                            
                          },
                        ),
                        Spacer(),
                        TextButton(
                          child: Text("Cancel"),
                          onPressed: (){
                            
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 20)
                    ],
                  )
                ),
                Positioned(
                  left: Consts.padding,
                  right: Consts.padding,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: Consts.avatarRadius,
                    child: Image(image: NetworkImage("https://i.ibb.co/gghzqTq/mamyalung-logo.png"),
                      fit: BoxFit.fill,)
                  )
                )
              ],
            ));
          },
        ),
      ); 
  }
  return new Container(
    //Pabs Paedit Design
    child: Container(
                        margin: EdgeInsets.only(left:20,right: 20,top:10,bottom:20),
                        width: double.infinity,
                        height: 100.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(topic.img), fit: BoxFit.cover),
                          color: white,
                          borderRadius: BorderRadius.circular(20.0),
                          boxShadow: [
                            BoxShadow(
                              color: black.withOpacity(0.5),spreadRadius: 3,
                              blurRadius: 7,offset:Offset(2, 5)
                            )
                          ]
                        ),
                        child: Padding(padding: EdgeInsets.only(top: 10),
                        child: Container(child:Column(
                          children:[
                            AutoSizeText(nameTopic,style:TextStyle(fontSize: 20), textAlign: TextAlign.center,),
                            SizedBox(height:150),
                            Center(child: Row(children:[
                              
                            ElevatedButton(
                              child:Text('Edit',style:TextStyle(fontSize: 12), textAlign: TextAlign.center,),
                              onPressed:() async{
                                //Edit Content
                                showDialog(context: context,
                                    builder: (BuildContext context) => updateTopic(context));
                              
                              }

                            ),
                            SizedBox(width: 20,),
                            ElevatedButton(
                              child: publish == 0 ? Text('Publish',style:TextStyle(fontSize: 12), textAlign: TextAlign.center,): Text('Unpublish',style:TextStyle(fontSize: 12), textAlign: TextAlign.center,),
                              onPressed:() async{
                                
                                await FirebaseFirestore.instance.collection('topics').doc(topic.code)
                                .update({
                                  'publish': topic.publish == 0 ? 1 : 0,
                                }).then((value){
                            showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Message"),
                              content: Text('Publish Change'),
                              actions: [
                                ElevatedButton(
                                  child: Text("Ok"),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                )
                              ],
                            );
                          });
                            print('success');
                          })
                          // ignore: invalid_return_type_for_catch_error
                          .catchError((error) => print('failed'));
                              }
                            ),
                            ]))
                          ])
                        )
                        )
   
  ));

}



class Consts {
  Consts._();

  static double padding = 16.0;
  static double avatarRadius = 66.0;
}
