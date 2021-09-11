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
    return SingleChildScrollView(
      child: Column(children: [
        Container(
          child: Text('Topics',
          style: TextStyle(color: Colors.white, fontSize: 18.0,fontFamily: 'Evil'),
          )
          ),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            child:TextField(
            
            controller: _searchController,
            decoration: InputDecoration(
              
              focusColor: lightBlue,
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              
              ),
              hintText: 'Enter a search term'
            ),
          )),
      Container(
      height: MediaQuery.of(context).size.height*.70,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child:ListView.builder(
          itemCount: _resultsList.length,
        itemBuilder: (BuildContext context, int index)=>
         viewTopic(context, _resultsList[index])
        ))
      ],)
    );
  }
}

Widget viewTopic(BuildContext context, DocumentSnapshot document) {
  final topic = Topics.fromSnapshot(document);

  return new Container(
    child: InkWell(
      focusColor: white,
      hoverColor: Colors.grey,
        child: Container(
      padding: EdgeInsets.symmetric(horizontal:2, vertical:20),
      width: MediaQuery.of(context).size.width,
      child:Row(
        
        children: [
        Container(
          width: MediaQuery.of(context).size.width/9,
          child:Text('')
        ),
        Container(
          width: MediaQuery.of(context).size.width/5,
          child:Text(topic.topic_name,
          style: GoogleFonts.lato(
                      textStyle: TextStyle(color: gray,fontSize: 16, ),
                    ),)
        ),
        Container(
          width: MediaQuery.of(context).size.width/5,
          child: Text(topic.grade_level.toString(),
          style: GoogleFonts.lato(
                      textStyle: TextStyle(color: gray,fontSize: 16, ),
                    ),)
        ),
        Container(
          width: MediaQuery.of(context).size.width/7,
          child: Text(topic.publish.toString(),
          style: GoogleFonts.lato(
                      textStyle: TextStyle(color: gray,fontSize: 16, ),
                    ),)
        ),
        
        Container(
          width: MediaQuery.of(context).size.width/7,
          child: Text('Action',
          style: GoogleFonts.lato(
                      textStyle: TextStyle(color: gray,fontSize: 16, ),
                    ),)
        ),
      ],),),
        onTap: () {
          /*Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailTripView(trip: trip)),
          );*/
        },
      )
  );
}