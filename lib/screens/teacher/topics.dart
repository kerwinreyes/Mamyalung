import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mamyalung/materials.dart';
import 'package:mamyalung/model/topic.dart';
class Topic extends StatefulWidget {
  const Topic({ Key? key }) : super(key: key);

  @override
  _TopicState createState() => _TopicState();
}

class _TopicState extends State<Topic> {
      TextEditingController _searchController = TextEditingController();

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
                crossAxisCount: MediaQuery.of(context).size.width < 480 ? 2 :6,
              ),
            itemBuilder: (BuildContext context, int index)=>
                  viewTopic(context, _resultsList[index]),
            itemCount: _resultsList.length,
          ))
      ],)),
    floatingActionButton: 
      FloatingActionButton( onPressed: (){
        
      },
      child: Icon(Icons.add),
      backgroundColor: Colors.blue,
     
    ));
  }
}
Widget viewTopic(BuildContext context, DocumentSnapshot document) {
  List randomColor=[lightBlue, primaryBlue, green, lightgreen, orange, red];
  final topic = Topics.fromSnapshot(document);
  editTopic(){

  }
  publish(){

  }
  return new Container(
    child: Container(
                        margin: EdgeInsets.only(left:20,right: 20,top:10,bottom:20),
                        width: double.infinity,
                        height: 100.0,
                        decoration: BoxDecoration(
                          
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
                        child: AutoSizeText(topic.topic_name,style:TextStyle(fontFamily: 'Poppins',fontSize: 20), textAlign: TextAlign.center,))
   
  ));

}