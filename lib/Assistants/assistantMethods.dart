import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:quicks/Assistants/requestAssistant.dart';
import 'package:quicks/DataHandler/appData.dart';
import 'package:quicks/Models/directionDetails.dart';
import 'package:quicks/configMaps.dart';

import '../Models/address.dart';
import '../Models/allUsers.dart';

class AssistantMethods{
  static Future<String> searchCoordinateAddress(Position position, context) async{
    String placeAddress = "";
    String url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey";

    var response = await RequestAssistant.getRequest(url);
    String st1,st2,st3,st4;

    if(response != "failed"){
      //placeAddress= response["results"][0]["formatted_address"];
      st1= response["results"][0]["address_components"][3]["long_name"];
      st2 =response["results"][0]["address_components"][4]["long_name"];
      st3 =  response["results"][0]["address_components"][5]["long_name"];
      st4 =  response["results"][0]["address_components"][6]["long_name"];
      placeAddress = st1 + ", " + st2 + ", " + st3 + ", " +st4;

      Address userPickUpAddress = new Address();
      userPickUpAddress.longitude = position.longitude;
      userPickUpAddress.latitude = position.latitude;
      userPickUpAddress.placeName = placeAddress;

      Provider.of<AppData>(context, listen: false).updatePickUpLocationAddress(userPickUpAddress);
    }

    return placeAddress;
  }

  static Future<DirectionDetails?> obtainPlaceDirectionDetails( LatLng initialPosition, LatLng finalPosition) async{
    String directionUrl = "https://maps.googleapis.com/maps/api/directions/json?destination=${finalPosition.latitude},${finalPosition.longitude}&origin=${initialPosition.latitude},${initialPosition.longitude}&key=$mapKey";

    var res = await RequestAssistant.getRequest(directionUrl);

    if(res == "failed"){
      return null;
    }

    DirectionDetails directionDetails = DirectionDetails();

    directionDetails.encodePoints = res["routes"][0]["overview_polyline"]["points"];

    directionDetails.distanceText = res["routes"][0]["legs"][0]["distance"]["text"];
    directionDetails.distanceValue = res["routes"][0]["legs"][0]["distance"]["value"];

    directionDetails.durationText = res["routes"][0]["legs"][0]["duration"]["text"];
    directionDetails.durationValue = res["routes"][0]["legs"][0]["duration"]["value"];

    return directionDetails;
  }

  static int calculateFares(DirectionDetails directionDetails){

    //in terms of USD
    double timeTraveledFare = (directionDetails.durationValue/60)*0.20;
    double distanceTraveledFare = (directionDetails.distanceValue/100)*0.20;
    double totalFareAmount = timeTraveledFare + distanceTraveledFare;

    //local currency
    //1$ = 900₦
    //double totalLocalAmount = totalFareAmount * 900;

    return totalFareAmount.truncate();
  }

  static void getCurrentOnLineUserInfo() async{
   firebaseUser = await FirebaseAuth.instance.currentUser;
   String userId = firebaseUser.uid;
   DatabaseReference reference = FirebaseDatabase.instance.ref().child("users").child(userId);

   reference.once().then((DataSnapshot dataSnapshot){
     if(dataSnapshot.value != null){
       userCurrentInfo = Users.fromSnapShot(dataSnapshot);
     }
   } as FutureOr Function(DatabaseEvent value));
  }
}