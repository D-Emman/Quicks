import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Users{
  var id;
  var email;
  var name;
  var phone;

  Users({this.id, this.email, this.phone});

  Users.fromSnapShot(var dataSnapshot){

      id = dataSnapshot.key;
      email = dataSnapshot.value["email"];
      name = dataSnapshot.value["name"];
      phone = dataSnapshot.value["phone"];



  }
}