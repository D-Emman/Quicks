import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quicks/DataHandler/appData.dart';
import 'package:quicks/Screens/mainScreen.dart';
import 'package:quicks/Screens/loginScreen.dart';
import 'package:firebase_database/firebase_database.dart';


import 'Screens/registrationScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp();
  runApp(const MyApp());
}


DatabaseReference usersRef = FirebaseDatabase.instance.ref().child("users");

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(

      create: (BuildContext context) => AppData(),
      child: MaterialApp(
        title: 'Taxi Rider App',
        theme: ThemeData(
          fontFamily: "Brand Bold",
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity
        ),
        initialRoute: FirebaseAuth.instance.currentUser == null ? LoginScreen.idScreen : MainScreen.idScreen,
        routes: {
          RegistrationScreen.idScreen: (context) => RegistrationScreen(),
          LoginScreen.idScreen: (context) => LoginScreen(),
          MainScreen.idScreen: (context) => MainScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}


