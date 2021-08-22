import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mamyalung/components/routes.dart';
import 'package:mamyalung/materials.dart';
import 'package:mamyalung/model/users.dart';
import 'package:mamyalung/responsive.dart';
import 'package:mamyalung/widgets/buttons.dart';
import 'package:mamyalung/widgets/usertable.dart';
import 'package:mamyalung/extension.dart';

class AdminHomePage extends StatefulWidget {
  static const String routeName = '/admin/home';
  final User user;
  const AdminHomePage({ Key? key, required this.user }) : super(key: key);

  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int currentIndex = 0;

  
  
  Widget _createDrawerItem(
    {required IconData icon, required String text, GestureTapCallback? onTap}) {
  return ListTile(
    title: Row(
      children: <Widget>[
        Icon(icon),
        Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(text),
        )
      ],
    ),
    onTap: onTap,
  );
}
Widget _createHeader() {
  return DrawerHeader(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      
      child: Stack(children: <Widget>[
        Positioned(
            bottom: 12.0,
            left: 16.0,
            child: Text("Flutter Step-by-Step",
                style: TextStyle(
                    color: primaryBlue,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500))),
      ]));
}
  void changePage(int index) {
    setState(() {
      currentIndex = index;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Row(children: [
            Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.label,size: 15.0,),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),),
            Text('Mamyalung',style:TextStyle(color:Colors.black54))
            ])
        ),
        backgroundColor: currentIndex == 3 ? Color(0xffF7F8FA) : Colors.white,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0,
      ),
      drawer: Container(
        width: 300,
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children:[
          _createHeader(),
          _createDrawerItem(icon: Icons.home,text: 'Home',
          onTap: () =>
          Navigator.pushReplacementNamed(context, Routes.adminprofile),),
          _createDrawerItem(icon: Icons.face, text: 'Profile',),
          _createDrawerItem(icon: Icons.settings, text: 'Settings',),
          Divider(),
          ListTile(
            title: Text('Logout'),
            onTap: () {},
          ),
        ],
          ),
        )
      ),
      
      body: Responsive(
        desktop: Padding(
          
          padding: EdgeInsets.symmetric(horizontal: 100,vertical: 20.0),
          child: Column(
          
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            button(first: lightBlue, second:primaryBlue, 
                        size:12.0, height:40.0, width:160.0, text:'Add Users',
                        onTap: () =>
                    Navigator.pushReplacementNamed(context, Routes.addUser)),

            Expanded(
              flex: _size.width > 1340 ? 2 : 4,
              child: TableViewUsers(),
            ),
        ],),),
        mobile: 
          ListTileUsers(),
        tablet:  Padding(
          
          padding: EdgeInsets.symmetric(horizontal: 0,vertical: 20.0),
          child: Column(
          
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            button(first: lightBlue, second:primaryBlue, 
                        size:12.0, height:40.0, width:160.0, text:'Add Users',
                        onTap: () =>
                    Navigator.pushReplacementNamed(context, Routes.adminprofile)),

            Expanded(
              flex: 6,
              child: TableViewUsers(),
            ),
        ],),),
        )
      
    );
  }
}

//TableVIewUsers
class TableViewUsers extends StatefulWidget {
  const TableViewUsers({ Key? key }) : super(key: key);

  @override
  _TableViewUsersState createState() => _TableViewUsersState();
}

class _TableViewUsersState extends State<TableViewUsers> {
  final Stream<QuerySnapshot> _studStream = FirebaseFirestore.instance
                                                .collection('users')
                                                .where('role',isEqualTo: 'student')
                                                .snapshots();
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
  getUser() async{
    /* await  FirebaseFirestore.instance
      .collection('users')
      .get()
      .then((QuerySnapshot querySnapshot){
         querySnapshot.docs.forEach((DocumentSnapshot doc) {
            _allResult.add(doc.data());
          
        }); 
      });*/
       var data = await FirebaseFirestore.instance
        .collection('users').where('role',isNotEqualTo: 'Admin')
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
        var title = Users.fromSnapshot(tripSnapshot).fname.toLowerCase();
        var lname = Users.fromSnapshot(tripSnapshot).lname.toLowerCase();

        if(title.contains(_searchController.text.toLowerCase()) || lname.contains(_searchController.text.toLowerCase())) {
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
    return Column(children: [
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
      color: lightBlue,
      padding: EdgeInsets.symmetric(horizontal: 2, vertical:20),
      width: MediaQuery.of(context).size.width,
      child:Row(
        
        children: [
        Container(
          width: MediaQuery.of(context).size.width/9,
          child:Text('')
        ),
        Container(
          width: MediaQuery.of(context).size.width/5,
          child:Text('Email Address',     
          style: GoogleFonts.lato(
                      textStyle: TextStyle(color: gray,fontSize: 16, fontWeight: FontWeight.bold),
                    ),)
        ),
        Container(
          width: MediaQuery.of(context).size.width/5,
          child: Text('Name',     
          style: GoogleFonts.lato(
                      textStyle: TextStyle(color: gray,fontSize: 16, fontWeight: FontWeight.bold),
                    ),)
        ),
        Container(
          width: MediaQuery.of(context).size.width/7,
          child: Text('Role',          
          style: GoogleFonts.lato(
                      textStyle: TextStyle(color: gray,fontSize: 16, fontWeight: FontWeight.bold),
                    ),)
        ),
        
        Container(
          width: MediaQuery.of(context).size.width/8,
          child: Text('Action',     
          style: GoogleFonts.lato(
                      textStyle: TextStyle(color: gray,fontSize: 16, fontWeight: FontWeight.bold),
                    ),)
        ),
      ],),),
      Container(
      height: MediaQuery.of(context).size.height/1.7,
      child: 
      
      ListView.builder(
        itemCount: _resultsList.length,
        itemBuilder: (BuildContext context, int index)=>
          buildTripCard(context, _resultsList[index])
        ).addNeumorphism()
      /*StreamBuilder<QuerySnapshot>(
      stream: _studStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }
        final data =snapshot.requireData;
        return ListView.builder(
          itemCount: data.size,
          itemBuilder: (context, index){
            print(data.docs[index]['fname']);
            return Row(
              children: [
                Container(
                  child: Text(data.docs[index]['fname']),
                ),
                
                Container(
                  child: Text(data.docs[index]['lname']),
                ),
                Container(
                  child: Text(data.docs[index]['email']),
                )
              ],
            );
          },
        );
      },
    )*/
    )
    ]);
  }
}


//ListTIleUers
class ListTileUsers extends StatefulWidget {
  const ListTileUsers({ Key? key }) : super(key: key);

  @override
  _ListTileUsersState createState() => _ListTileUsersState();
}

class _ListTileUsersState extends State<ListTileUsers> {
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
  getUser() async{
    /* await  FirebaseFirestore.instance
      .collection('users')
      .get()
      .then((QuerySnapshot querySnapshot){
         querySnapshot.docs.forEach((DocumentSnapshot doc) {
            _allResult.add(doc.data());
          
        }); 
      });*/
       var data = await FirebaseFirestore.instance
        .collection('users').where('role',isNotEqualTo: 'Admin')
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
        var title = Users.fromSnapshot(tripSnapshot).fname.toLowerCase();
        var lname = Users.fromSnapshot(tripSnapshot).lname.toLowerCase();

        if(title.contains(_searchController.text.toLowerCase()) || lname.contains(_searchController.text.toLowerCase())) {
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
    return Column(children: [
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
      child: /*ListView.builder(
          itemCount: data.size,
          itemBuilder: (context, index){
            print(data.docs[index]['fname']);
            return ListTile(
              title: Padding(
                padding: EdgeInsets.all(5),
                child: Text(data.docs[index]['fname']+' '+data.docs[index]['lname']),
              ),
              subtitle: Text('  '+data.docs[index]['role']),
              leading: Icon(Icons.verified_user),
              trailing: Icon(Icons.arrow_forward),
              onTap: (){

              },
            );
      },
    )*/
    ListView.builder(
        itemCount: _resultsList.length,
        itemBuilder: (BuildContext context, int index)=>
         moblieViewUsers(context, _resultsList[index])
        )
    
    )]);
  }
}