import 'package:flutter/widgets.dart';
import 'package:quicks/Models/address.dart';

class AppData extends ChangeNotifier
{
 var pickUpLocation, dropOffLocation;

 void updatePickUpLocationAddress(Address pickUpAddress){
   pickUpLocation = pickUpAddress;
   notifyListeners();
 }

 void updateDropOffLocationAddress(Address dropOffAddress){
   dropOffLocation= dropOffAddress;
   notifyListeners();
 }

}