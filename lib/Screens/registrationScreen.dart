// import 'dart:js';
// import 'package:js/js.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quicks/Screens/mainScreen.dart';
import 'package:quicks/main.dart';
import '../AllWidgets/progressDialog.dart';
import 'loginScreen.dart';

displayToastMessage(String message, BuildContext context) {
  Fluttertoast.showToast(msg: message);
}

class RegistrationScreen extends StatelessWidget {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  void registerNewUser(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ProgressDialog(
          message: "Registering, Please wait ...",
        );
      },
      barrierDismissible: false,
    );

    final User? firebaseUser = (await _firebaseAuth
            .createUserWithEmailAndPassword(
                email: emailTextEditingController.text,
                password: passwordTextEditingController.text)
            .catchError((errMsg) {
      //Fluttertoast.showToast(msg:"Error: " + errMsg.toString());
      Navigator.pop(context);
      displayToastMessage(
          "Error: " + errMsg.toString(), context as BuildContext);
    }))
        .user;

    if (firebaseUser != null) {
      //save user into database

      Map userDataMap = {
        "name": nameTextEditingController.text.trim(),
        "email": emailTextEditingController.text.trim(),
        "phone": phoneTextEditingController.text.trim(),
      };

      usersRef.child(firebaseUser.uid).set(userDataMap);
      //Fluttertoast.showToast(msg: "You have successfully created an account");
      displayToastMessage(
          "You have successfully created an account", context as BuildContext);

      Navigator.pushNamedAndRemoveUntil(context as BuildContext, MainScreen.idScreen, (route) => false);
    } else {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "New user account has not been created.");
      // display error message
      // displayToastMessage("New user account has not been created.", context as BuildContext);
    }
  }

  static const String idScreen = 'register';
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
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
                height: 25.0,
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
                "SignUp as a Passenger",
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
                      controller: nameTextEditingController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: "Name",
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
                      controller: phoneTextEditingController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: "Phone ",
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
                        if (nameTextEditingController.text.length < 4) {
                          displayToastMessage(
                              "Name must be atleast three characters", context);
                        } else if (!emailTextEditingController.text
                            .contains('@')) {
                          displayToastMessage(
                              "Email address is not valid", context);
                        } else if (phoneTextEditingController.text.isEmpty) {
                          displayToastMessage(
                              "Phone number is necessary", context);
                        } else if (passwordTextEditingController.text.length <
                            7) {
                          displayToastMessage(
                              "Password must be atleast 6 characters", context);
                        } else {
                          registerNewUser(context);

                        }
                      },
                      // color: Colors.yellow,
                      // textColor:Colors.white,
                      child: Container(
                        height: 50.0,
                        child: Center(
                            child: Text(
                          "Create Account",
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
                        context, LoginScreen.idScreen, (route) => false);
                  },
                  child: Text(
                    "Already have an account? Login here",
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

// "Name must be atleast three characters"
