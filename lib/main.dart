import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mamyalung/authService.dart';
import 'package:mamyalung/materials.dart';
import 'package:mamyalung/screens/admin/homepage.dart';
import 'package:mamyalung/screens/admin/profile.dart';
import 'package:mamyalung/screens/home.dart';
import 'package:mamyalung/loginpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mamyalung/screens/profile.dart';
import 'package:mamyalung/services/usermanagement.dart';
import 'package:mamyalung/utils/finalAuth.dart';
import 'package:provider/provider.dart';
import 'authService.dart';
import 'components/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationProvider>(
          create: (_) => AuthenticationProvider(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) => context.read<AuthenticationProvider>().authState, initialData: null,
        )
      ],
      child: MaterialApp(
      title: 'Mamyalung',
      initialRoute: '/',
      routes: {
        Routes.adminprofile: (context) => AdminProfile(),
      },
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            textStyle: TextStyle(
              fontSize: 24.0,
            ),
            padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
          ),
        ),
        textTheme: TextTheme(
          headline1: TextStyle(
            fontSize: 46.0,
            color: Colors.blue.shade700,
            fontWeight: FontWeight.w500,
          ),
          bodyText1: TextStyle(fontSize: 18.0),
        ),
      ),
      home: LoginPage(),
    ),
    );
  }
}

class Authenticate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();

    if (firebaseUser != null) {
      var data = FirebaseFirestore.instance
        .collection('users').where('uid',isEqualTo: firebaseUser.uid)
        .get();
      return AdminHomePage(user: firebaseUser,);
    }
    return LoginPage();
  }
}