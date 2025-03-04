import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:quicks/AllWidgets/progressDialog.dart';
import 'package:quicks/Screens/registrationScreen.dart';
import '../main.dart';
import 'mainScreen.dart';

class LoginScreen extends StatelessWidget {
  static const String idScreen = 'login';
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 35.0,
              ),
              Image(
                image: AssetImage("images/logo.png"),
                width: 390.0,
                height: 250.0,
                alignment: Alignment.center,
              ),
              SizedBox(
                height: 1.0,
              ),
              Text(
                "Login as Passenger",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24.0, fontFamily: "Brand Bold"),
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 1.0,
                    ),
                    TextField(
                      controller: emailTextEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        ),
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),
                    SizedBox(
                      height: 1.0,
                    ),
                    TextField(
                      controller: passwordTextEditingController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        ),
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.yellow),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white),
                        shape: MaterialStateProperty.all(
                            new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(24.0),
                        )),
                      ),
                      onPressed: () {
                        if (emailTextEditingController.text.length < 4) {
                          //displayToastMessage("Name must be atleast three characters", context);
                        } else if (passwordTextEditingController.text.length <
                            7) {
                          // displayToastMessage("Password must be atleast 6 characters", context);
                        } else {
                          loginUser(context);
                        }
                      },
                      // color: Colors.yellow,
                      // textColor:Colors.white,
                      child: Container(
                        height: 50.0,
                        child: Center(
                            child: Text(
                          "Login",
                          style: TextStyle(
                              fontSize: 18.0, fontFamily: "Brand Bold"),
                        )),
                      ),
                    )
                  ],
                ),
              ),
              TextButton(
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(Colors.black),
                  ),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, RegistrationScreen.idScreen, (route) => false);
                  },
                  child: Text(
                    "Do not have an account? Register here",
                  ))
            ],
          ),
        ),
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  void loginUser(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ProgressDialog(
          message: "Authenticating, Please wait ...",
        );
      },
      barrierDismissible: false,
    );

    final User? firebaseUser = (await _firebaseAuth
            .signInWithEmailAndPassword(
                email: emailTextEditingController.text,
                password: passwordTextEditingController.text)
            .catchError((errMsg) {
      Navigator.pop(context);
      displayToastMessage(
          "Error: $errMsg", context);
    }))
        .user;

    if (firebaseUser != null) {
      //save user into database

      usersRef.child(firebaseUser.uid).once().then((DataSnapshot snap) {
            if (snap.value != null) {
              Navigator.pushNamedAndRemoveUntil(context as BuildContext,
                  MainScreen.idScreen, (route) => false);
            } else {
              Navigator.pop(context);
              _firebaseAuth.signOut();
              displayToastMessage(
                  "No records exist for this user.", context as BuildContext);
            }
          } as FutureOr Function(DatabaseEvent value));

      //Navigator.pushNamedAndRemoveUntil(context as BuildContext, MainScreen.idScreen, (route) => false);
    } else {
      Navigator.pop(context);
      // display error message
      displayToastMessage("Cannot be signed in", context as BuildContext);
    }
  }
}
