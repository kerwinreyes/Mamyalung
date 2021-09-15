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
    Future<void> _addflashcard(String a, List b, int c, int l, int v, String t, String trans) async {
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
        "translation": trans,
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
        "questionID" : 21,
        "question": "Sanu karing susunud a kakatni a magumpisa king 'a' ing ali kapampangan?",
        "translation": "Alin sa mga sumusunod na kakatni na naguumpisa sa 'a' ang hindi Kapampangan?",
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
        "question": "Sanu karing susunud a kakatni a magumpisa king 'e' ing ali kapampangan?",
        "translation": "Alin sa mga sumusunod na kakatni na naguumpisa sa 'e' ang hindi Kapampangan?",
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
        "question": "Sanu karing susunud a kakatni a magumpisa king 'i' ing ali kapampangan?",
        "translation": "Alin sa mga sumusunod na kakatni na naguumpisa sa 'i' ang hindi Kapampangan?",
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
        "question": "Sanu karing susunud a kakatni a magumpisa king 'o' ing ali kapampangan?",
        "translation": "Alin sa mga sumusunod na kakatni na naguumpisa sa 'o' ang hindi Kapampangan?",
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
        "question": "Sanu karing susunud a kakatni a magumpisa king 'u' ing ali kapampangan?",
        "translation": "Alin sa mga sumusunod na kakatni na naguumpisa sa 'u' ang hindi Kapampangan?",
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
        "question": "Sanu karing susunud a makikatni a magumpisa king 'g' ing ali kapampangan?",
        "translation": "Alin sa mga sumusunod na makikatni na naguumpisa 'g' ang hindi Kapampangan?",
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
        "question": "Sanu karing susunud a makikatni a magumpisa king 'm' ing ali kapampangan?",
        "translation": "Alin sa mga sumusunod na makikatni na naguumpisa 'm' ang hindi Kapampangan?",
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
        "question": "Sanu karing susunud a makikatni a magumpisa king 'p' ing ali kapampangan?",
        "translation": "Alin sa mga sumusunod na makikatni na naguumpisa 'p' ang hindi Kapampangan?",
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
        "question": "Sanu karing susunud a makikatni a magumpisa king 's' ing ali kapampangan?",
        "translation": "Alin sa mga sumusunod na makikatni na naguumpisa 's' ang hindi Kapampangan?",
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
        "question": "Sanu karing susunud a makikatni a magumpisa king 'd' ing ali kapampangan?",
        "translation": "Alin sa mga sumusunod na makikatni na naguumpisa 'd' ang hindi Kapampangan?",
        "grade_level" : 2,
        "topic" : "Kakatni at Makikatni",
        "multiple_choice": [
        "dikut",
        "dagis",
        "danum",
        "dugo"],
        "answer": 3},
         {
        "questionID" : 51,
        "grade_level" : 3,
        "question": "Sanu karing susunud a Palagyu ing ali salitang Kapampangan?",
        "translation": "Alin sa mga sumusunod na Pangngalan ang hindi salitang Kapampangan?",
        "topic" : "Kasarian ning Palagyu",
        "multiple_choice": [
        "mestru",
        "doktor",
        "guro",
        "apu"],
        "answer": 2},

        {
        "questionID" : 52,
        "question": "Sanu karing susunud a salitang Kapampangan ing ali papakit Panlalaking Kasarian?",
        "translation": "Alin sa mga sumusunod na salitang Kapampangan ang hindi nagpapakita ng Panlalakeng Kasarian?",
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
        "question": "Sanu karing susunud a palagyu ing ali salitang Kapampangan?",
        "translation": "Alin sa mga sumusunod na pangngalan ang hindi salitang Kapampangan?",
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
        "question": "Sanu karing susunud a palagyu ing ali salitang Kapampangan?",
        "translation": "Alin sa mga sumusunod na pangngalan ang hindi salitang Kapampangan?",
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
        "question": "Sanu karing susunud a palagyu ing ali salitang Kapampangan?",
        "translation": "Alin sa mga sumusunod na pangngalan ang hindi salitang Kapampangan?",
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
        "question": "Sanu karing susunud a palagyu ing ali salitang Kapampangan?",
        "translation": "Alin sa mga sumusunod na pangngalan ang hindi salitang Kapampangan?",
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
        "question": "Sanu ing ali kayabe karing kasarian ning Palagyu?",
        "translation": "Alin ang hindi kabilang sa mga kasarian ng Pangngalan?",
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
        "question": "Sanu karing susunud a Parewung Kasarian ing ali salitang Kapampangan?",
        "translation": "Alin sa mga sumusunod na Parehong Kasarian ang hindi salitang Kapampangan?",
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
        "question": "Sanu karing susunud a Palagyu ing kayabe king Pambabaing Kasarian?",
        "translation": "Alin sa mga sumusunod na Pangngalan ang kabilang sa Pambabaeng Kasarian?",
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
        "question": "Sanu karing susunud a Palagyu ing kayabe king Panlalaking Kasarian?",
        "translation": "Alin sa mga sumusunod na Pangngalan ang kabilang sa Panglalakeng kasarian?",
        "grade_level" : 3,
        "topic" : "Kasarian ning Palagyu",
        "multiple_choice": [
        "mestra",
        "lapis",
        "kaluguran",
        "bapa"],
        "answer": 3},
         {
        "questionID" : 11,
        "question": "Nanu ing buri ng sabiyan ning 'Mayap a ugtu pu' king tagalog?",
        "translation": "Ano ang ibig sabihin ng 'Mayap a ugtu pu' sa tagalog?",
        "grade_level" : 2,
        "topic" : "Pagtukoy ng Magagalang na Pananalita at Pagbati",
        "multiple_choice": [
        "Magandang Umaga po",
        "Magandang Hapon po",
        "Magandang Gabi po",
        "Magandang Tanghali po"],
        "answer": 3},

        {
        "questionID" : 12,
        "question": "Nanu ya king kapampangan ing 'Tuloy po kayo'?",
        "translation": "Ano sa Kapampangan ang 'Tuloy po kayo'?",
        "grade_level" : 2,
        "topic" : "Pagtukoy ng Magagalang na Pananalita at Pagbati",
        "multiple_choice": [
        "Pakiabut po",
        "Makilabas ku pu",
        "Malawus kayu pu",
        "Pasensya na pu"],
        "answer": 2},

        {
        "questionID" : 13,
        "question": "Nanu ya king kapampangan ing 'Magandang hapon po'?",
        "translation": "Ano sa Kapampangan ang 'Magandang hapon po'?",
        "grade_level" : 2,
        "topic" : "Pagtukoy ng Magagalang na Pananalita at Pagbati",
        "multiple_choice": [
        "Alang nanu man pu",
        "Pasensya na pu",
        "Malawus kayu pu",
        "Mayap a gatpanapun pu"],
        "answer": 3},

        {
        "questionID" : 14,
        "question": "Nanu ya king kapampangan ing 'Maligayang Bagong Taon'?",
        "translation": "Ano sa Kapampangan ang 'Maligayang Bagong Taon'?",
        "grade_level" : 2,
        "topic" : "Pagtukoy ng Magagalang na Pananalita at Pagbati",
        "multiple_choice": [
        "Masayang Bayung Banwa",
        "Masayang aldo ning kebaytan",
        "Masayang aldo kekayu ngan",
        "Mayap a bengi pu"],
        "answer": 0},

        {
        "questionID" : 15,
        "question": "Nanung sabiyan mu patse atin kang agawang kasalanan?",
        "translation": "Ano ang iyong sasabihin kapag may nagawa kang kasalanan?",
        "grade_level" : 2,
        "topic" : "Pagtukoy ng Magagalang na Pananalita at Pagbati",
        "multiple_choice": [
        "Komusta kayu pu",
        "Pasensya na pu",
        "Pakiabut pu",
        "Alang nanu man pu"],
        "answer": 1},

        {
        "questionID" : 16,
        "question": "Sanu ing ali papakit paggalang?",
        "translation": "Alin ang hindi nagpapakita ng paggalang?",
        "grade_level" : 2,
        "topic" : "Pagtukoy ng Magagalang na Pananalita at Pagbati",
        "multiple_choice": [
        "Komusta kayu pu",
        "Salamat pu",
        "Makilabas ku pu",
        "Lumayas na ka"],
        "answer": 3},

        {
        "questionID" : 17,
        "question": "Sanu ing ali papakit paggalang?",
        "translation": "Alin ang hindi nagpapakita ng paggalang?",
        "grade_level" : 2,
        "topic" : "Pagtukoy ng Magagalang na Pananalita at Pagbati",
        "multiple_choice": [
        "Po/Opu",
        "Salamat",
        "Alang nanu man pu",
        "Pasensya na pu"],
        "answer": 1},

        {
        "questionID" : 18,
        "question": "Sanu ing ali papakit paggalang?",
        "translation": "Alin ang hindi nagpapakita ng paggalang?",
        "grade_level" : 2,
        "topic" : "Pagtukoy ng Magagalang na Pananalita at Pagbati",
        "multiple_choice": [
        "Pakiabut pu",
        "Mayap a bengi pu",
        "Pasensya",
        "Makilabas ku pu"],
        "answer": 2},

        {
        "questionID" : 19,
        "question": "Nanu ya king Kapampangan ing 'Maligayang Kaarawan'?",
        "translation": "Ano sa Kapampangan ang 'Maligayang Kaarawan'?",
        "grade_level" : 2,
        "topic" : "Pagtukoy ng Magagalang na Pananalita at Pagbati",
        "multiple_choice": [
        "Mayap a bengi pu",
        "Masayang bayung banwa pu",
        "Makilabas ku pu",
        "Masayang aldo ning kebaytan pu"],
        "answer": 3},
{
        "questionID" : 20,
        "question": "Nanu ya king Kapampangan ing 'Paki abot po'?",
        "translation": "Ano sa Kapampangan ang 'Paki abot po'?",
        "grade_level" : 2,
        "topic" : "Pagtukoy ng Magagalang na Pananalita at Pagbati",
        "multiple_choice": [
        "Pakiabut pu",
        "Salamat pu",
        "Makilabas ku pu",
        "Masayang aldo ning kebaytan pu"],
        "answer": 0},
        {
    "questionID" : 61,
    "grade_level" : 3,
    "question": "Sanu ing ustung salita: Anam nakung ____",
    "translation": "Alin ang nararapat na salita: Anam nakung ____",
    "topic" : "Pagpapakilala sa Sarili",
    "multiple_choice": [
    "banwa",
    "mestra",
    "idad",
    "Ala king minunang atlu"],
    "answer": 0},

    {
    "questionID" : 62,
    "question": "Sanu ing ustung salita: _____ ku king Holy Angel University",
    "translation": "Alin ang nararapat na salita: _____ ku king Holy Angel University",
    "grade_level" : 3,
    "topic" : "Pagpapakilala sa Sarili",
    "multiple_choice": [
    "matudtud",
    "magaral",
    "mamulayi",
    "Ala king minunang atlu"],
    "answer": 1},

  
    {
    "questionID" : 63,
    "question": "Sanu ing ustung salita: ____ ku king Angeles City/San Fernando City",
    "translation": "Alin ang nararapat na salita: ____ ku king Angeles City/San Fernando City",
    "grade_level" : 3,
    "topic" : "Pagpapakilala sa Sarili",
    "multiple_choice": [
    "makatuknang",
    "mamulayi",
    "mandilu",
    "Ala king minunang atlu"],
    "answer": 0},
    
    {
    "questionID" : 64,
    "question": "Sanu ing ustung salita: Kayabe ku king bale i ima ku ampo i ____ ku",
    "translation": "Alin ang nararapat na salita: Kayabe ku king bale i ima ku ampo i ____ ku",
    "grade_level" : 3,
    "topic" : "Pagpapakilala sa Sarili",
    "multiple_choice": [
    "adwa",
    "okra",
    "tatang",
    "Ala king minunang atlu"],
    "answer": 2},

    {
    "questionID" : 65,
    "question": "Sanu karing susunud ing ali Kapampangan a numeru?",
    "translation": "Alin sa mga sumusunod ang hindi Kapampangan na numero?",
    "grade_level" : 3,
    "topic" : "Pagpapakilala sa Sarili",
    "multiple_choice": [
    "anam",
    "adwa",
    "isa",
    "atlu"],
    "answer": 2},

    {
    "questionID" : 66,
    "question": "Sanu karing susunud ing Kapampangan a bulan?",
    "translation": "Alin sa mga sumusunod ang Kapampangan na buwan?",
    "grade_level" : 3,
    "topic" : "Pagpapakilala sa Sarili",
    "multiple_choice": [
    "marsu",
    "april",
    "september",
    "Ala king minunang atlu"],
    "answer": 0},
    
    {
    "questionID" : 67,
    "question": "Nanu ya king tagalog ing 'Apulu nakung banwa'?",
    "translation": "Ano sa tagalog ang 'Apulu nakung banwa'?",
    "grade_level" : 3,
    "topic" : "Pagpapakilala sa Sarili",
    "multiple_choice": [
    "ako ay anim na taon na",
    "ako ay sampong taon na",
    "ako ay labing isang taon na",
    "Ala king minunang atlu"],
    "answer": 1},

    {
    "questionID" : 68,
    "question": "Nanu ya king tagalog ing 'Atyu na ku king katlung gradu'?",
    "translation": "Ano sa tagalog ang 'Atyu na ku king katlung gradu'?",
    "grade_level" : 3,
    "topic" : "Pagpapakilala sa Sarili",
    "multiple_choice": [
    "ako ay nasa unang baitang ",
    "ako ay nasa ikalawang baitang",
    "ako ay nasa ikatlong baitang",
    "Ala king minunang atlu"],
    "answer": 2},

    {
    "questionID" : 69,
    "question": "Nanu ya king tagalog ing 'Ing ima ku i'?",
    "translation": "Ano sa tagalog ang 'Ing ima ku i'?",
    "grade_level" : 3,
    "topic" : "Pagpapakilala sa Sarili",
    "multiple_choice": [
    "Ang tita ko ay si",
    "Ang lola ko ay si",
    "ang nanay ako ay si",
    "Ala king minunang atlu"],
    "answer": 2},
    
    {
    "questionID" : 70,
    "question": "Nanu ya king tagalog ing 'Ing tatang ku i'?",
    "translation": "Ano sa tagalog ang 'Ing tatang ku i'?",
    "grade_level" : 3,
    "topic" : "Pagpapakilala sa Sarili",
    "multiple_choice": [
    "ang kuya ko ay si",
    "ang tatay ko ay si",
    "ang kapatid ko ay si",
    "Ala king minunang atlu"],
    "answer": 1},
      {
        "questionID" : 1,
        "grade_level" : 2,
        "question": "Nanu ya king Kapampangan ing 'July'?",
        "translation": "Ano sa Kapampangan ang 'July'?",
        "topic" : "Pagpapakilala sa Sarili",
        "multiple_choice": [
        "Hunyu",
        "Mayu",
        "Hulyu",
        "Disyembri"],
        "answer": 2},

        {
        "questionID" : 2,
        "question": "Nung 'Tatang' ya ing Kapampangan ning 'Tatay', Nanu ya king Kapampangan ing 'Nanay'?",
        "translation": "Kung 'Tatang' ang Kapampangan ng 'Tatay', ano sa Kapampangan ang 'Nanay'?",
        "grade_level" : 2,
        "topic" : "Pagpapakilala sa Sarili",
        "multiple_choice": [
        "Ima",
        "Apu",
        "Idad",
        "Mama"],
        "answer": 0},

      
        {
        "questionID" : 3,
        "question": "Nanu ya king Kapampangan ing 'Paaralan'",
        "translation": "Ano sa Kapampangan ang 'Paaralan'?",
        "grade_level" : 2,
        "topic" : "Pagpapakilala sa Sarili",
        "multiple_choice": [
        "Paaralan",
        "Iskwela",
        "Tatang",
        "Park"],
        "answer": 1},
        
        {
        "questionID" : 4,
        "question": "Nanu ya ing buri ng sabiyan ning 'Lagyu' king English?",
        "translation": "Ano ang ibig sabihin ng 'Lagyu' sa English?",
        "grade_level" : 2,
        "topic" : "Pagpapakilala sa Sarili",
        "multiple_choice": [
        "age",
        "address",
        "school",
        "name"],
        "answer": 3},

        {
        "questionID" : 5,
        "question": "Sanu karing susunud ing ali Kapampangan a salita?",
        "translation": "Alin sa mga sumusunod ang hindi Kapampangan na salita?",
        "grade_level" : 2,
        "topic" : "Pagpapakilala sa Sarili",
        "multiple_choice": [
        "kebaytan",
        "baitang",
        "gradu",
        "idad"],
        "answer": 1},

        {
        "questionID" : 6,
        "question": "Sanu karing susunud ing ali Kapampangan a salita?",
        "translation": "Alin sa mga sumusunod ang hindi Kapampangan na salita?",
        "grade_level" : 2,
        "topic" : "Pagpapakilala sa Sarili",
        "multiple_choice": [
        "mayu",
        "hunyu",
        "ima",
        "april"],
        "answer": 3},
        
        {
        "questionID" : 7,
        "question": "Nanu ya king Kapampangang ing 'Birthday'?",
        "translation": "Ano ang Kapampangan ng 'Birthday'?",
        "grade_level" : 2,
        "topic" : "Pagpapakilala sa Sarili",
        "multiple_choice": [
        "kebaytan",
        "baitang",
        "gradu",
        "idad"],
        "answer": 0},

        {
        "questionID" : 8,
        "question": "Sanu karing bulan ing ali salitang Kapampangan?",
        "translation": "Alin sa mga Buwan ang hindi salitang Kapampangan?",
        "grade_level" : 2,
        "topic" : "Pagpapakilala sa Sarili",
        "multiple_choice": [
        "agostu",
        "oktubri",
        "may",
        "disyembri"],
        "answer": 2},

        {
        "questionID" : 9,
        "question": "Nanu ya king Kapampangan ing 'Tatay'?",
        "translation": "Ano sa Kapampangan ang 'Tatay'?",
        "grade_level" : 2,
        "topic" : "Pagpapakilala sa Sarili",
        "multiple_choice": [
        "papa",
        "tatang",
        "idad",
        "marsu"],
        "answer": 1},
        
        {
        "questionID" : 10,
        "question": "Nanu ya king tagalog ing 'Makatuknang ku king'?",
        "translation": "Ano sa tagalog ang 'Makatuknang ku king'?",
        "grade_level" : 2,
        "topic" : "Pagpapakilala sa Sarili",
        "multiple_choice": [
        "Ang pangalan ko ay",
        "Nakatira ako sa",
        "Ako ay kabilang sa",
        "Ako ay"],
        "answer": 1},
         {
        "questionID" : 31,
        "question": "Sanu karing susunud a salita ing ali adwang pantig?",
        "translation": "Alin sa mga sumusunod na salita ang hindi dalawang pantig?",
        "grade_level" : 2,
        "topic" : "Pamagpantig karing salita",
        "multiple_choice": [
        "asbuk",
        "anam",
        "apulu",
        "relo"],
        "answer": 2},

        {
        "questionID" : 32,
        "question": "Sanu karing susunud a salita ing ali adwang pantig?",
        "translation": "Alin sa mga sumusunod na salita ang hindi dalawang pantig?",
        "grade_level" : 2,
        "topic" : "Pamagpantig karing salita",
        "multiple_choice": [
        "embudu",
        "uran",
        "ebun",
        "bitis"],
        "answer": 0},

        {
        "questionID" : 33,
        "question": "Sanu karing susunud a salita ing ali atlung pantig?",
        "translation": "Alin sa mga sumusunod na salita ang hindi tatlong pantig?",
        "grade_level" : 2,
        "topic" : "Pamagpantig karing salita",
        "multiple_choice": [
        "inuman",
        "ebun",
        "mandilu",
        "apunan"],
        "answer": 1},

        {
        "questionID" : 34,
        "question": "Sanu karing susunud a salita ing ating atlung pantig?",
        "translation": "Alin sa mga sumusunod na salita ang may tatlong pantig?",
        "grade_level" : 2,
        "topic" : "Pamagpantig karing salita",
        "multiple_choice": [
        "okra",
        "gabun",
        "danum",
        "malagu"],
        "answer": 3},

        {
        "questionID" : 35,
        "question": "Sanu karing susunud a salita ing ali atlung pantig?",
        "translation": "Alin sa mga sumusunod na salita ang hindi tatlong pantig?",
        "grade_level" : 2,
        "topic" : "Pamagpantig karing salita",
        "multiple_choice": [
        "malagu",
        "salol",
        "pitaka",
        "masanting"],
        "answer": 1},

        {
        "questionID" : 36,
        "question": "Sanu karing susunud a salita ing ali apat a pantig?",
        "translation": "Alin sa mga sumusunod na salita ang hindi apat na pantig?",
        "grade_level" : 2,
        "topic" : "Pamagpantig karing salita",
        "multiple_choice": [
        "gamat",
        "maganaka",
        "aksidenti",
        "kaluguran"],
        "answer": 0},

        {
        "questionID" : 37,
        "question": "Sanu karing susunud a salita ing ating apat a pantig?",
        "translation": "Alin sa mga sumusunod na salita ang may apat na pantig?",
        "grade_level" : 2,
        "topic" : "Pamagpantig karing salita",
        "multiple_choice": [
        "tuturu",
        "mananaman",
        "manuk",
        "lukluk"],
        "answer": 1},

        {
        "questionID" : 38,
        "question": "Sanu karing susunud a salita ing ating adwang pantig?",
        "translation": "Alin sa mga sumusunod na salita ang may dalawang pantig?",
        "grade_level" : 2,
        "topic" : "Pamagpantig karing salita",
        "multiple_choice": [
        "abak",
        "apulu",
        "masanting",
        "mandilu"],
        "answer": 0},

        {
        "questionID" : 39,
        "question": "Sanu karing susunud a salita ing ating atlung pantig?",
        "translation": "Alin sa mga sumusunod na salita ang may tatlong pantig?",
        "grade_level" : 2,
        "topic" : "Pamagpantig karing salita",
        "multiple_choice": [
        "salol",
        "manimu",
        "salu",
        "kawe"],
        "answer": 1},

        {
        "questionID" : 40,
        "question": "Sanu karing susunud a salita ing ating apat a pantig?",
        "translation": "Alin sa mga sumusunod na salita ang may apat na pantig?",
        "grade_level" : 2,
        "topic" : "Pamagpantig karing salita",
        "multiple_choice": [
        "mamalantsa",
        "dagis",
        "mangadi",
        "sulapo"],
        "answer": 0},
           {
        "questionID" : 61,
        "grade_level" : 3,
        "question": "Sanu ing ustung Panghalip Panaong gamitan: Munta ka keni, ___ ing kayabe kung mako.",
        "translation": "Alin ang tamang Panghalip Panaong gagamitin: Munta ka keni, ___ ing kayabe kung mako.",
        "topic" : "Panghalip Panaong (Aku, Ika at Iya)",
        "multiple_choice": [
        "ika",
        "aku",
        "iya",
        "Ala king minunang atlu"],
        "answer": 0},

        {
        "questionID" : 62,
        "question": "Sanu ing ustung Panghalip Panaong gamitan: Makatuknang ya i Darang Josie kening siping ming bale, ___ ing sasaup kekami.",
        "translation": "Alin ang tamang Panghalip Panaong gagamitin: Makatuknang ya i Darang Josie kening siping ming bale, ___ ing sasaup kekami.",
        "grade_level" : 3,
        "topic" : "Panghalip Panaong (Aku, Ika at Iya)",
        "multiple_choice": [
        "ika",
        "aku",
        "iya",
        "Ala king minunang atlu"],
        "answer": 2},

      
        {
        "questionID" : 63,
        "question": "Sanu ing ustung Panghalip Panaong gamitan: ___ ing utusan nang saling inuman kaya meko ku.",
        "translation": "Alin ang tamang Panghalip Panaong gagamitin: ___ ing utusan nang saling inuman kaya meko ku.",
        "grade_level" : 3,
        "topic" : "Panghalip Panaong (Aku, Ika at Iya)",
        "multiple_choice": [
        "ika",
        "aku",
        "iya",
        "Ala king minunang atlu"],
        "answer": 1},
        
        {
        "questionID" : 64,
        "question": "Sanu ing ustung Panghalip Panaong gamitan: Atin kaming dintang a bisita, ___ ing dara ku.",
        "translation": "Alin ang tamang Panghalip Panaong gagamitin: Atin kaming dintang a bisita, ___ ing dara ku.",
        "grade_level" : 3,
        "topic" : "Panghalip Panaong (Aku, Ika at Iya)",
        "multiple_choice": [
        "ika",
        "aku",
        "iya",
        "Ala king minunang atlu"],
        "answer": 2},

        {
        "questionID" : 65,
        "question": "Sanu ing ustung Panghalip Panaong gamitan: ____ ing inawus na ning mestra kaya tinikdo ku.",
        "translation": "Alin ang tamang Panghalip Panaong gagamitin: ____ ing inawus na ning mestra kaya tinikdo ku.",
        "grade_level" : 3,
        "topic" : "Panghalip Panaong (Aku, Ika at Iya)",
        "multiple_choice": [
        "ika",
        "aku",
        "iya",
        "Ala king minunang atlu"],
        "answer": 1},

        {
        "questionID" : 66,
        "question": "Sanu ing ustung Panghalip Panaong gamitan: Pantunan na ka ning mestra, ____ kanu ing sagut.",
        "translation": "Alin ang tamang Panghalip Panaong gagamitin: Pantunan na ka ning mestra, ____ kanu ing sagut.",
        "grade_level" : 3,
        "topic" : "Panghalip Panaong (Aku, Ika at Iya)",
        "multiple_choice": [
        "ika",
        "aku",
        "iya",
        "Ala king minunang atlu"],
        "answer": 0},
        
        {
        "questionID" : 67,
        "question": "Sanu ing ustung Panghalip Panaong gamitan: Atin minaus kaku, ___ ing pisan ku.",
        "translation": "Alin ang tamang Panghalip Panaong gagamitin: Atin minaus kaku, ___ ing pisan ku.",
        "grade_level" : 3,
        "topic" : "Panghalip Panaong (Aku, Ika at Iya)",
        "multiple_choice": [
        "ika",
        "aku",
        "iya",
        "Ala king minunang atlu"],
        "answer": 2},

        {
        "questionID" : 68,
        "question": "Sanu ing ustung Panghalip Panaong gamitan: Alayu pa i Jessie, ____ ing talwing datang",
        "translation": "Alin ang tamang Panghalip Panaong gagamitin: Alayu pa i Jessie, ____ ing talwing datang",
        "grade_level" : 3,
        "topic" : "Panghalip Panaong (Aku, Ika at Iya)",
        "multiple_choice": [
        "ika",
        "aku",
        "iya",
        "Ala king minunang atlu"],
        "answer": 2},

        {
        "questionID" : 69,
        "question": "Sanu ing ustung Panghalip Panaong gamitan: Atin kinatuk, ___ ing tatang ku.",
        "translation": "Alin ang tamang Panghalip Panaong gagamitin: Atin kinatuk, ___ ing tatang ku.",
        "grade_level" : 3,
        "topic" : "Panghalip Panaong (Aku, Ika at Iya)",
        "multiple_choice": [
        "ika",
        "aku",
        "iya",
        "Ala king minunang atlu"],
        "answer": 2},
        
        {
        "questionID" : 70,
        "question": "Sanu ing ustung Panghalip Panaong gamitan: Minawus ya kaku i Ima, ___ kanu ing sali.",
        "translation": "Alin ang tamang Panghalip Panaong gagamitin: Minawus ya kaku i Ima, ___ kanu ing sali.",
        "grade_level" : 3,
        "topic" : "Panghalip Panaong (Aku, Ika at Iya)",
        "multiple_choice": [
        "ika",
        "aku",
        "iya",
        "Ala king minunang atlu"],
        "answer": 1},
          {
        "questionID" : 71,
        "grade_level" : 3,
        "question": "Sanu karing susunud a Kapampangan a salita ing ali papakit kilus?",
        "translation": "Alin sa mga susunod na Kapampangan na salita ang hindi nagpapakita ng kilos?",
        "topic" : "Salitang Papakit Galo o Kimut",
        "multiple_choice": [
        "mamasa",
        "mamipi",
        "manalbe",
        "mayap"],
        "answer": 3},

        {
        "questionID" : 72,
        "question": "Sanu karing susunud a Kapampangan a salita ing ali papakit kilus?",
        "translation": "Alin sa mga susunod na Kapampangan na salita ang hindi nagpapakita ng kilos?",
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
        "question": "Sanu karing susunud a Kapampangan a salita ing ali papakit kilus?",
        "translation": "Alin sa mga susunod na Kapampangan na salita ang hindi nagpapakita ng kilos?",
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
        "question": "Sanu karing susunud a Kapampangan a salita ing ali papakit kilus king bale?",
        "translation": "Alin sa mga susunod na Kapampangan na salita ang hindi nagpapakita ng kilos sa bahay?",
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
        "question": "Sanu karing susunud a Kapampangan a salita ing ali papakit kilus da ring Animal?",
        "translation": "Alin sa mga susunod na Kapampangan na salita ang hindi nagpapakita ng kilos ng mga Hayop?",
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
        "question": "Sanu karing susunud a Kapampangan a salita ing ali papakit kilus da ring Animal?",
        "translation": "Alin sa mga susunod na Kapampangan na salita ang hindi nagpapakita ng kilos ng mga Hayop?",
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
        "question": "Sanu karing susunud a Kapampangan a salita ing ali papakit kilus king iskwela?",
        "translation": "Alin sa mga susunod na Kapampangan na salita ang hindi nagpapakita ng kilos sa paaralan?",
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
        "question": "Sanu karing susunud a Kapampangan a salita ing ali papakit kilus king bale?",
        "translation": "Alin sa mga susunod na Kapampangan na salita ang hindi nagpapakita ng kilos sa bahay?",
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
        "question": "Sanu karing susunud a Kapampangan a salita ing ali papakit kilus king bale?",
        "translation": "Alin sa mga susunod na Kapampangan na salita ang hindi nagpapakita ng kilos sa bahay?",
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
        "question": "Sanu karing susunud a Kapampangan a salita ing ali papakit kilus king iskwela?",
        "translation": "Alin sa mga susunod na Kapampangan na salita ang hindi nagpapakita ng kilos sa paaralan?",
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
              _addflashcard(lists[i]['question'],lists[i]['multiple_choice'],lists[i]['answer'],lists[i]['questionID'],lists[i]['grade_level'],lists[i]['topic'],lists[i]['translation']);
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