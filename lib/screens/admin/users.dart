import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mamyalung/components/header.dart';
import 'package:mamyalung/materials.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:mamyalung/responsive.dart';
import 'package:mamyalung/extension.dart';
import 'package:mamyalung/screens/admin/studcard.dart';
import 'sidemenu.dart';
import 'package:mamyalung/screens/admin/sidemenu.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
class ListOfUsers extends StatefulWidget {
  const ListOfUsers({ Key? key }) : super(key: key);

  @override
  _ListOfUsersState createState() => _ListOfUsersState();
}

class _ListOfUsersState extends State<ListOfUsers> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 250),
        child: AdminSideMenu(),
      ),
      body: Container(
        padding: EdgeInsets.only(top: kIsWeb ? kDefaultPadding : 0),
        color: kBgDarkColor,
        child: SafeArea(
          right: false,
          child: Column(
            children: [
              // This is our Seearch bar
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: Row(
                  children: [
                    // Once user click the menu icon the menu shows like drawer
                    // Also we want to hide this menu icon on desktop
                    if (!Responsive.isDesktop(context))
                      IconButton(
                        icon: Icon(Icons.menu),
                        onPressed: () {
                          _scaffoldKey.currentState!.openDrawer();
                        },
                      ),
                    if (!Responsive.isDesktop(context)) SizedBox(width: 5),
                    Expanded(
                      child: TextField(
                        onChanged: (value) {},
                        decoration: InputDecoration(
                          hintText: "Search",
                          fillColor: kBgLightColor,
                          filled: true,
                          suffixIcon: Padding(
                            padding: const EdgeInsets.all(
                                kDefaultPadding * 0.75), //15
                            child: Icon(Icons.search)
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: kDefaultPadding),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: Row(
                  children: [

                    Container(
                      child:Icon(Icons.arrow_downward),
                      width: 16,
                      color: Colors.black,
                    ),
                    SizedBox(width: 5),
                    Text(
                      "Sort by date",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Spacer(),
                    MaterialButton(
                      minWidth: 20,
                      onPressed: () {},
                      child: Container(
                      child:Icon(Icons.sort),
                      width: 16,
                      color: Colors.black,
                    ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: kDefaultPadding),
              Expanded(
                child: 
                UserInformation(),
               
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserInformation extends StatefulWidget {
  @override
    _UserInformationState createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
                                                .collection('users')
                                                .where('role',isEqualTo: 'teacher')
                                                .snapshots();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
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
          itemBuilder: (context,index)=>
          StudCard(
                    isActive: Responsive.isMobile(context) ? false : index == 0,
                    
                    press: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              UsersScreen(user: data.docs[index]['uid']),
                        ),
                      );
                    },
                  ),
          /*(context, index){
            
              print(data.docs[index]['fname']);
            return ListTile(
              title: Padding(
                padding: EdgeInsets.all(5),
                child: Text(data.docs[index]['fname']+' '+data.docs[index]['lname']),
              ),
              subtitle: Text(data.docs[index]['role']),
              leading: Icon(Icons.verified_user),
              trailing: Icon(Icons.arrow_forward),
              onTap: (){
                
            if(Responsive.isMobile(context)){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        UsersScreen(user: data.docs[index]['uid']),
                  ),
                );
              }
              },
            );}
            */
        );
      },
    ));
  }
}

class UsersScreen extends StatelessWidget {
  const UsersScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  final String user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: Column(
            children: [
              Header(),
              Divider(thickness: 1),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(kDefaultPadding),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        maxRadius: 24,
                        backgroundColor: Colors.transparent,
                      ),
                      SizedBox(width: kDefaultPadding),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text.rich(
                                        TextSpan(
                                          text: 'Title',
                                          style: Theme.of(context)
                                              .textTheme
                                              .button,
                                          children: [
                                            TextSpan(
                                                text:
                                                    "  <elvia.atkins@gmail.com> to Jerry Torp",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .caption),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        "Inspiration for our new home",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6,
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(width: kDefaultPadding / 2),
                                Text(
                                  "Today at 15:32",
                                  style: Theme.of(context).textTheme.caption,
                                ),
                              ],
                            ),
                            SizedBox(height: kDefaultPadding),
                            LayoutBuilder(
                              builder: (context, constraints) => SizedBox(
                                width: constraints.maxWidth > 850
                                    ? 800
                                    : constraints.maxWidth,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Hello my love, \n \nSunt architecto voluptatum esse tempora sint nihil minus incidunt nisi. Perspiciatis natus quo unde magnam numquam pariatur amet ut. Perspiciatis ab totam. Ut labore maxime provident. Voluptate ea omnis et ipsum asperiores laborum repellat explicabo fuga. Dolore voluptatem praesentium quis eos laborum dolores cupiditate nemo labore. \n \nLove you, \n\nElvia",
                                      style: TextStyle(
                                        height: 1.5,
                                        color: Color(0xFF4D5875),
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                    SizedBox(height: kDefaultPadding),
                                    Row(
                                      children: [
                                        Text(
                                          "6 attachments",
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        Spacer(),
                                        Text(
                                          "Download All",
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption,
                                        ),
                                        SizedBox(width: kDefaultPadding / 4),
                                        
                                      ],
                                    ),
                                    Divider(thickness: 1),
                                    SizedBox(height: kDefaultPadding / 2),
                                    SizedBox(
                                      height: 200,
                                      
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}