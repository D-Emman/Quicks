import 'dart:convert';

class PlacePredictions{
  var secondary_text;
  var main_text;
  var place_id;

  PlacePredictions({required this.secondary_text,required this.main_text,required this.place_id});

  PlacePredictions.fromJson(Map<String, dynamic> json){
    place_id = json["place_id"];
    main_text = json["structured_formatting"]["main_text"];
    secondary_text = json["structured_formatting"]["secondary_text"];
  }



}