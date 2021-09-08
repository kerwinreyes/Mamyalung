import 'dart:math';

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
  final String user;
  const AdminHomePage({ Key? key,required this.user }) : super(key: key);

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
  String genID(){
    List<String> id = [];
    FirebaseFirestore.instance
  .collection('flashcards')
  .get()
  .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
            id.add(doc['id']);
        });
    });
    final len = 20;
    final lowercase='abcdefghijklmnopqrstuvxyz';
    final uppercase='ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    final numbers='0123456789';
    String chars='';
    chars += '$uppercase$lowercase';
    chars+='$numbers';
    return List.generate(len, (index){
      final indexRandom = Random.secure().nextInt(chars.length);
      return chars[indexRandom];
    }).join('');

  }
  CollectionReference flashcards = FirebaseFirestore.instance.collection('questions');


  Future<void> getData() async {
    // Get docs from collection reference
    
}
    Future<void> _addflashcard(String a, List b, int c, int l, int v, String t) async {
    List id=[];
      // Call the user's CollectionReference to add a new user
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
    .collection('questions')
    .get();

    // Get data from docs and convert map to List
    setState(() {
    id = querySnapshot.docs.map((doc) => doc['questionID']).toList();
      
    });
    
    return flashcards
    .doc('$l')
    .set({
      "question": a,
        "multiple_choice": b,
        "answer": c,
        "questionID": l,
        "grade_level":v,
        "topic": t,
    })
    .then((value) => print("Questions Added"))
    .catchError((error) => print("Failed to add user: $error"));
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
          Navigator.pushReplacementNamed(context, Routes.adminHomePage),),
          _createDrawerItem(icon: Icons.face, text: 'Profile',
          onTap: () =>
          Navigator.pushReplacementNamed(context, Routes.adminHomePage)),
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
        mobile: Column(children: [
            button(first: lightBlue, second:primaryBlue, 
                        size:12.0, height:40.0, width:100.0, text:'Add Users',
                        onTap: () =>
                    Navigator.pushReplacementNamed(context, Routes.addUser)),
          ElevatedButton(
            onPressed: (){
              List lists = [
         {
        "questionID" : 11,
        "question": "Ano ang ibig sabihin ng 'Mayap a ugtu pu' sa tagalog?",
        "grade_level" : 2,
        "topic" : "Pagtukoy ng magagalang Magagalang na Pananalita at Pagbati",
        "multiple_choice": [
        "Magandang Umaga po",
        "Magandang Hapon po",
        "Magandang Gabi po",
        "Magandang Tanghali po"],
        "answer": 3},

        {
        "questionID" : 12,
        "question": "Ano sa Kapampangan ang 'Tuluy po kayo'?",
        "grade_level" : 2,
        "topic" : "Pagtukoy ng magagalang Magagalang na Pananalita at Pagbati",
        "multiple_choice": [
        "Pakiabut po",
        "Makilabas ku pu",
        "Malawus kayu pu",
        "Pasensya na pu"],
        "answer": 2},

        {
        "questionID" : 13,
        "question": "Ano sa Kapampangan ang 'Magandang hapon po'?",
        "grade_level" : 2,
        "topic" : "Pagtukoy ng magagalang Magagalang na Pananalita at Pagbati",
        "multiple_choice": [
        "Alang nanu man pu",
        "Pasensya na pu",
        "Malawus kayu pu",
        "Mayap a gatpanapun pu"],
        "answer": 3},

        {
        "questionID" : 14,
        "question": "Ano ang Kapampangan ng 'Maligayang Bagong Taon'?",
        "grade_level" : 2,
        "topic" : "Pagtukoy ng magagalang Magagalang na Pananalita at Pagbati",
        "multiple_choice": [
        "Masayang Bayung Banwa",
        "Masayang aldo ning kebaytan",
        "Masayang aldo kekayu ngan",
        "Mayap a bengi pu"],
        "answer": 0},

        {
        "questionID" : 15,
        "question": "Ano ang iyong sasabihin kapag may nagawa kang kasalanan?",
        "grade_level" : 2,
        "topic" : "Pagtukoy ng magagalang Magagalang na Pananalita at Pagbati",
        "multiple_choice": [
        "Komusta kayu pu",
        "Pasensya na pu",
        "Pakiabut pu",
        "Alang nanu man pu"],
        "answer": 1},

        {
        "questionID" : 16,
        "question": "Alin ang hindi nagpapakita ng paggalang?",
        "grade_level" : 2,
        "topic" : "Pagtukoy ng magagalang Magagalang na Pananalita at Pagbati",
        "multiple_choice": [
        "Komusta kayu pu",
        "Salamat pu",
        "Makilabas ku pu",
        "Lumayas na ka"],
        "answer": 3},

        {
        "questionID" : 17,
        "question": "Alin ang hindi nagpapakita ng paggalang?",
        "grade_level" : 2,
        "topic" : "Pagtukoy ng magagalang Magagalang na Pananalita at Pagbati",
        "multiple_choice": [
        "Po/Opu",
        "Salamat",
        "Alang nanu man pu",
        "Pasensya na pu"],
        "answer": 1},

        {
        "questionID" : 18,
        "question": "Alin ang hindi nagpapakita ng paggalang?",
        "grade_level" : 2,
        "topic" : "Pagtukoy ng magagalang Magagalang na Pananalita at Pagbati",
        "multiple_choice": [
        "Pakiabut pu",
        "Mayap a bengi pu",
        "Pasensya",
        "Makilabas ku pu"],
        "answer": 2},

        {
        "questionID" : 19,
        "question": "Ano sa Kapampangan ang Happy Birthday?",
        "grade_level" : 2,
        "topic" : "Pagtukoy ng magagalang Magagalang na Pananalita at Pagbati",
        "multiple_choice": [
        "Mayap a bengi pu",
        "Masayang bayung banwa pu",
        "Makilabas ku pu",
        "Masayang aldo ning kebaytan pu"],
        "answer": 3},

        {
        "questionID" : 20,
        "question": "Ano sa Kapampangan ang Paki abot po?",
        "grade_level" : 2,
        "topic" : "Pagtukoy ng magagalang Magagalang na Pananalita at Pagbati",
        "multiple_choice": [
        "Pakiabut pu",
        "Salamat pu",
        "Makilabas ku pu",
        "Masayang aldo ning kebaytan pu"],
        "answer": 0},
     {
        "questionID" : 21,
        "question": "Alin sa mga sumusunod na kakatni na naguumpisa sa 'a' ang hindi Kapampangan?",
        "grade_level" : 2,
        "topic" : "Kakatni at Makikatni",
        "multiple_choice": [
        "asbuk",
        "anam",
        "apulu",
        "apple"],
        "answer": 3},

        {
        "questionID" : 22,
        "question": "Alin sa mga sumusunod na kakatni na naguumpisa sa 'e' ang hindi Kapampangan?",
        "grade_level" : 2,
        "topic" : "Kakatni at Makikatni",
        "multiple_choice": [
        "embudu",
        "ebun",
        "egg",
        "elepanti"],
        "answer": 2},

        {
        "questionID" : 23,
        "question": "Alin sa mga sumusunod na kakatni na naguumpisa sa 'i' ang hindi Kapampangan?",
        "grade_level" : 2,
        "topic" : "Kakatni at Makikatni",
        "multiple_choice": [
        "inuman",
        "itlog",
        "ipan",
        "ima"],
        "answer": 1},

        {
        "questionID" : 24,
        "question": "Alin sa mga sumusunod na kakatni na naguumpisa sa 'o' ang hindi Kapampangan?",
        "grade_level" : 2,
        "topic" : "Kakatni at Makikatni",
        "multiple_choice": [
        "okra",
        "osu",
        "ospital",
        "open"],
        "answer": 3},

        {
        "questionID" : 25,
        "question": "Alin sa mga sumusunod na kakatni na naguumpisa 'u' ang hindi Kapampangan?",
        "grade_level" : 2,
        "topic" : "Kakatni at Makikatni",
        "multiple_choice": [
        "ulunan",
        "uran",
        "usok",
        "ulas"],
        "answer": 2},

        {
        "questionID" : 26,
        "question": "Alin sa mga sumusunod na makikatni na naguumpisa 'g' ang hindi Kapampangan?",
        "grade_level" : 2,
        "topic" : "Kakatni at Makikatni",
        "multiple_choice": [
        "gamat",
        "gabun",
        "gamit",
        "gule"],
        "answer": 2},

        {
        "questionID" : 27,
        "question": "Alin sa mga sumusunod na makikatni na naguumpisa 'm' ang hindi Kapampangan?",
        "grade_level" : 2,
        "topic" : "Kakatni at Makikatni",
        "multiple_choice": [
        "matsing",
        "malagu",
        "manuk",
        "maganda"],
        "answer": 3},

        {
        "questionID" : 28,
        "question": "Alin sa mga sumusunod na makikatni na naguumpisa 'p' ang hindi Kapampangan?",
        "grade_level" : 2,
        "topic" : "Kakatni at Makikatni",
        "multiple_choice": [
        "paro",
        "panulu",
        "patawad",
        "pesus"],
        "answer": 2},

        {
        "questionID" : 29,
        "question": "Alin sa mga sumusunod na makikatni na naguumpisa 's' ang hindi Kapampangan?",
        "grade_level" : 2,
        "topic" : "Kakatni at Makikatni",
        "multiple_choice": [
        "salol",
        "sampaga",
        "salu",
        "saronggola"],
        "answer": 3},

        {
        "questionID" : 30,
        "question": "Alin sa mga sumusunod na makikatni na naguumpisa 'd' ang hindi Kapampangan?",
        "grade_level" : 2,
        "topic" : "Kakatni at Makikatni",
        "multiple_choice": [
        "dikut",
        "dagis",
        "danum",
        "dugo"],
        "answer": 1},{
        "questionID" : 31,
        "question": "Alin sa mga sumusunod na salita ang hindi dalawa ang pantig?",
        "grade_level" : 2,
        "topic" : "Kakatni at Makikatni",
        "multiple_choice": [
        "asbuk",
        "anam",
        "apulu",
        "relo"],
        "answer": 2},

        {
        "questionID" : 32,
        "question": "Alin sa mga sumusunod na salita ang hindi dalawa ang pantig?",
        "grade_level" : 2,
        "topic" : "Kakatni at Makikatni",
        "multiple_choice": [
        "embudu",
        "uran",
        "ebun",
        "bitis"],
        "answer": 0},

        {
        "questionID" : 33,
        "question": "Alin sa mga sumusunod na salita ang hindi tatlo ang pantig?",
        "grade_level" : 2,
        "topic" : "Kakatni at Makikatni",
        "multiple_choice": [
        "inuman",
        "ebun",
        "mandilu",
        "apunan"],
        "answer": 1},

        {
        "questionID" : 34,
        "question": "Alin sa mga sumusunod na salita ang hindi tatlo ang pantig?",
        "grade_level" : 2,
        "topic" : "Kakatni at Makikatni",
        "multiple_choice": [
        "okra",
        "gabun",
        "danum",
        "malagu"],
        "answer": 3},

        {
        "questionID" : 35,
        "question": "Alin sa mga sumusunod na salita ang hindi tatlo ang pantig?",
        "grade_level" : 2,
        "topic" : "Kakatni at Makikatni",
        "multiple_choice": [
        "aginaldu",
        "salol",
        "pitaka",
        "masanting"],
        "answer": 1},

        {
        "questionID" : 36,
        "question": "Alin sa mga sumusunod na salita ang hindi apat ang pantig?",
        "grade_level" : 2,
        "topic" : "Kakatni at Makikatni",
        "multiple_choice": [
        "gamat",
        "maganaka",
        "aksidenti",
        "kaluguran"],
        "answer": 1},

        {
        "questionID" : 37,
        "question": "Alin sa mga sumusunod na salita ang may apat na pantig?",
        "grade_level" : 2,
        "topic" : "Kakatni at Makikatni",
        "multiple_choice": [
        "tuturu",
        "mananaman",
        "manuk",
        "lukluk"],
        "answer": 1},

        {
        "questionID" : 38,
        "question": "Alin sa mga sumusunod na salita ang may dalawang pantig?",
        "grade_level" : 2,
        "topic" : "Kakatni at Makikatni",
        "multiple_choice": [
        "abak",
        "apulu",
        "masanting",
        "mandilu"],
        "answer": 0},

        {
        "questionID" : 39,
        "question": "Alin sa mga sumusunod na salita ang may tatlong pantig?",
        "grade_level" : 2,
        "topic" : "Kakatni at Makikatni",
        "multiple_choice": [
        "salol",
        "manimu",
        "salu",
        "kawe"],
        "answer": 1},

        {
        "questionID" : 40,
        "question": "Alin sa mga sumusunod na salita ang may apat na pantig?",
        "grade_level" : 2,
        "topic" : "Kakatni at Makikatni",
        "multiple_choice": [
        "mamalantsa",
        "dagis",
        "mangadi",
        "sulapo"],
        "answer": 0},
          {
        "questionID" : 51,
        "grade_level" : 3,
        "question": "Alin sa mga sumusunod na salita ang hindi Kapampangan na kasarian?",
        "topic" : "Kasarian ning Palagyu",
        "multiple_choice": [
        "mestru",
        "bagong taon",
        "guro",
        "apu"],
        "answer": 2},

        {
        "questionID" : 52,
        "question": "Alin sa mga sumusunod na kasarian ang hindi Panlalaking Kasarian?",
        "grade_level" : 3,
        "topic" : "Kasarian ning Palagyu",
        "multiple_choice": [
        "ima",
        "bapa",
        "koya",
        "ingkung"],
        "answer": 0},

      
        {
        "questionID" : 53,
        "question": "Alin sa mga sumusunod na kasarian ang hindi Kapampangan?",
        "grade_level" : 3,
        "topic" : "Kasarian ning Palagyu",
        "multiple_choice": [
        "ima",
        "panadero",
        "tatang",
        "apu"],
        "answer": 1},
        
        {
        "questionID" : 54,
        "question": "Alin sa mga sumusunod na kasarian ang hindi Kapampangan?",
        "grade_level" : 2,
        "topic" : "Kasarian ning Palagyu",
        "multiple_choice": [
        "talaturu",
        "dentista",
        "pisan",
        "kaklase"],
        "answer": 3},

        {
        "questionID" : 55,
        "question": "Alin sa mga sumusunod na kasarian ang hindi Kapampangan?",
        "grade_level" : 3,
        "topic" : "Kasarian ning Palagyu",
        "multiple_choice": [
        "bag",
        "tiya",
        "tinape",
        "pasku"],
        "answer": 1},

        {
        "questionID" : 56,
        "question": "Alin sa mga sumusunod na kasarian ang hindi Kapampangan?",
        "grade_level" : 3,
        "topic" : "Kasarian ning Palagyu",
        "multiple_choice": [
        "kaluguran",
        "sundalu",
        "ima",
        "paper"],
        "answer": 3},
        
        {
        "questionID" : 57,
        "question": "Alin ang hindi kabilang sa mga kasarian ng Pangalan?",
        "grade_level" : 3,
        "topic" : "Kasarian ning Palagyu",
        "multiple_choice": [
        "panlalaki",
        "pambabai",
        "panghayop",
        "parewu"],
        "answer": 2},

        {
        "questionID" : 58,
        "question": "Alin sa mga sumusunod na Parehong Kasarian na ito ang hindi Kapampangan?",
        "grade_level" : 3,
        "topic" : "Kasarian ning Palagyu",
        "multiple_choice": [
        "guro",
        "pulis",
        "dentista",
        "kaklasi"],
        "answer": 0},

        {
        "questionID" : 59,
        "question": "Alin sa mga sumusunod na kasarian ang kabilang sa Pambabaing Kasarian ",
        "grade_level" : 3,
        "topic" : "Kasarian ning Palagyu",
        "multiple_choice": [
        "tinape",
        "atsi",
        "Pampanga",
        "ninung"],
        "answer": 1
        },
        
        {
        "questionID" : 60,
        "question": "Alin sa mga sumusunod na kasarian ang kabilang sa Panglalaking kasarian?",
        "grade_level" : 3,
        "topic" : "Kasarian ning Palagyu",
        "multiple_choice": [
        "mestra",
        "lapis",
        "kaluguran",
        "bapa"],
        "answer": 3},
          {
        "questionID" : 61,
        "grade_level" : 3,
        "question": "Alin ang tamang Panghalip panaong na gagamitin base sa pangungusap na ito: Munta ka keni, ___ ing kayabe kung mako.",
        "topic" : "Panghalip Panaong (Aku, Ika at Iya)",
        "multiple_choice": [
        "ika",
        "aku",
        "iya",
        "none of the above"],
        "answer": 0},

        {
        "questionID" : 62,
        "question": "Alin ang tamang Panghalip panaong na gagamitin base sa pangungusap na ito: Makatuknang ya i Darang Josie kening siping ming bale, ___ ing sasaup kekami.",
        "grade_level" : 3,
        "topic" : "Panghalip Panaong (Aku, Ika at Iya)",
        "multiple_choice": [
        "ika",
        "aku",
        "iya",
        "none of the above"],
        "answer": 2},

      
        {
        "questionID" : 63,
        "question": "Alin ang tamang Panghalip panaong na gagamitin base sa pangungusap na ito: ___ ing utusan nang saling inuman kaya meko ku.",
        "grade_level" : 3,
        "topic" : "Panghalip Panaong (Aku, Ika at Iya)",
        "multiple_choice": [
        "ika",
        "aku",
        "iya",
        "none of the above"],
        "answer": 1},
        
        {
        "questionID" : 64,
        "question": "Alin ang tamang Panghalip panaong na gagamitin base sa pangungusap na ito: Atin kaming dintang a bisita, ___ ing dara ku.",
        "grade_level" : 3,
        "topic" : "Panghalip Panaong (Aku, Ika at Iya)",
        "multiple_choice": [
        "ika",
        "aku",
        "iya",
        "none of the above"],
        "answer": 2},

        {
        "questionID" : 65,
        "question": "Alin ang tamang Panghalip panaong na gagamitin base sa pangungusap na ito: ____ ing inawus na ning mestra kaya tinikdo ku.",
        "grade_level" : 3,
        "topic" : "Panghalip Panaong (Aku, Ika at Iya)",
        "multiple_choice": [
        "ika",
        "aku",
        "iya",
        "none of the above"],
        "answer": 1},

        {
        "questionID" : 66,
        "question": "Alin ang tamang Panghalip panaong na gagamitin base sa pangungusap na ito: Pantunan na ka ning mestra, ____ kanu ing sagut.",
        "grade_level" : 3,
        "topic" : "Panghalip Panaong (Aku, Ika at Iya)",
        "multiple_choice": [
        "ika",
        "aku",
        "iya",
        "none of the above"],
        "answer": 0},
        
        {
        "questionID" : 67,
        "question": "Alin ang tamang Panghalip panaong na gagamitin base sa pangungusap na ito: Atin minaus kaku, ___ ing pisan ku.",
        "grade_level" : 3,
        "topic" : "Panghalip Panaong (Aku, Ika at Iya)",
        "multiple_choice": [
        "ika",
        "aku",
        "iya",
        "none of the above"],
        "answer": 2},

        {
        "questionID" : 68,
        "question": "Alin ang tamang Panghalip panaong na gagamitin base sa pangungusap na ito: Alayu pa i Jessie, ____ ing talwing datang",
        "grade_level" : 3,
        "topic" : "Panghalip Panaong (Aku, Ika at Iya)",
        "multiple_choice": [
        "ika",
        "aku",
        "iya",
        "none of the above"],
        "answer": 2},

        {
        "questionID" : 69,
        "question": "Alin ang tamang Panghalip panaong na gagamitin base sa pangungusap na ito: Atin kinatuk, ___ ing tatang ku.",
        "grade_level" : 3,
        "topic" : "Panghalip Panaong (Aku, Ika at Iya)",
        "multiple_choice": [
        "ika",
        "aku",
        "iya",
        "none of the above"],
        "answer": 2},
        
        {
        "questionID" : 70,
        "question": "Alin ang tamang Panghalip panaong na gagamitin base sa pangungusap na ito: Minawus ya kaku i Ima, ___ kanu ing sali.",
        "grade_level" : 3,
        "topic" : "Panghalip Panaong (Aku, Ika at Iya)",
        "multiple_choice": [
        "ika",
        "aku",
        "iya",
        "none of the above"],
        "answer": 1},
        {
        "questionID" : 71,
        "grade_level" : 3,
        "question": "Alin sa mga susunod na Kapampangan na salita ang hindi nagpapakita ng kilos?",
        "topic" : "Salitang Papakit Galo o Kimut",
        "multiple_choice": [
        "mamasa",
        "mamipi",
        "manalbe",
        "mayap"],
        "answer": 3},

        {
        "questionID" : 72,
        "question": "Alin sa mga susunod na Kapampangan na salita ang hindi nagpapakita ng kilos?",
        "grade_level" : 3,
        "topic" : "Salitang Papakit Galo o Kimut",
        "multiple_choice": [
        "lumakad",
        "sukle",
        "manayi",
        "mamulayi"],
        "answer": 1},

      
        {
        "questionID" : 73,
        "question": "Alin sa mga susunod na Kapampangan na salita ang hindi nagpapakita ng kilos?",
        "grade_level" : 3,
        "topic" : "Salitang Papakit Galo o Kimut",
        "multiple_choice": [
        "mandilig",
        "lukluk",
        "manimu",
        "basu"],
        "answer": 3},
        
        {
        "questionID" : 74,
        "question": "Alin sa mga susunod na Kapampangan na salita ang hindi nagpapakita ng kilos sa bahay?",
        "grade_level" : 2,
        "topic" : "Salitang Papakit Galo o Kimut",
        "multiple_choice": [
        "mamiblas",
        "manyipilyu",
        "mangan",
        "kakawe"],
        "answer": 3
        },

        {
        "questionID" : 75,
        "question": "Alin sa mga susunod na Kapampangan na salita ang hindi nagpapakita ng kilos ng mga hayop?",
        "grade_level" : 3,
        "topic" : "Salitang Papakit Galo o Kimut",
        "multiple_choice": [
        "maglutu",
        "mamulayi",
        "susulapo",
        "kukusad"],
        "answer": 0},

        {
        "questionID" : 76,
        "question": "Alin sa mga susunod na Kapampangan na salita ang hindi nagpapakita ng kilos ng mga hayop?",
        "grade_level" : 3,
        "topic" : "Salitang Papakit Galo o Kimut",
        "multiple_choice": [
        "mamanik",
        "luluksu",
        "manalbe",
        "susulapo"],
        "answer": 2},
        
        {
        "questionID" : 77,
        "question": "Alin sa mga susunod na Kapampangan na salita ang hindi nagpapakita ng kilos sa paaralan?",
        "grade_level" : 3,
        "topic" : "Salitang Papakit Galo o Kimut",
        "multiple_choice": [
        "susulat",
        "matudtud",
        "tuturu",
        "makiramdam"],
        "answer": 1},

        {
        "questionID" : 78,
        "question": "Alin sa mga susunod na Kapampangan na salita ang hindi nagpapakita ng kilos sa bahay?",
        "grade_level" : 3,
        "topic" : "Salitang Papakit Galo o Kimut",
        "multiple_choice": [
        "matudtud",
        "mandilig",
        "manimu",
        "susulapo"],
        "answer": 3},

        {
        "questionID" : 79,
        "question": "Alin sa mga susunod na Kapampangan na salita ang hindi nagpapakita ng kilos sa bahay?",
        "grade_level" : 3,
        "topic" : "Salitang Papakit Galo o Kimut",
        "multiple_choice": [
        "maglutu",
        "mamalis",
        "manigaral",
        "mamiblas"],
        "answer": 2},
        
        {
        "questionID" : 80,
        "question": "Alin sa mga susunod na Kapampangan na salita ang hindi nagpapakita ng kilos sa paaralan?",
        "grade_level" : 3,
        "topic" : "Salitang Papakit Galo o Kimut",
        "multiple_choice": [
        "mangadi",
        "manigaral",
        "manalbe",
        "teterak"],
        "answer": 2}
    ];
    

              for(int i=0; i<=lists.length; i++){
                print(lists[i]);
              _addflashcard(lists[i]['question'],lists[i]['multiple_choice'],lists[i]['answer'],lists[i]['questionID'],lists[i]['grade_level'],lists[i]['topic']);
              }
            }, child:Text('add')),

        ],),
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