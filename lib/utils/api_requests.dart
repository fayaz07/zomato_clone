import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:zomato_clone/bloc/places_bloc.dart';
import 'package:zomato_clone/utils/session_data.dart';

import 'constants.dart';
import 'data_models.dart';

class ApiRequests{

  static Future<dynamic> getNearbyPlaces(String query, PlacesBloc bloc) async {
    try{

      //Forming url
      String baseUrl = "https://maps.googleapis.com/maps/api/place/autocomplete/json?";

      baseUrl += "key=${Keys.placesAPIKey}";
      baseUrl += "&inputtype=textquery";
      baseUrl += "&input=$query";
      
      print("Search location: " + query);

      var response = await get(baseUrl);

      var placesJson = json.decode(response.body);

      print("Places request status: ${placesJson["status"]}");

      placesJson = placesJson["predictions"];

      SessionData.places.clear();
      bloc.clearPlaces();
      for(var place in placesJson) {
        SessionData.places.add(PlacesModel.fromJson(place["structured_formatting"]));
        bloc.addPlace(PlacesModel.fromJson(place["structured_formatting"]));
//        print(bloc.places);
      }

    }catch(e){
      print("Caught an error- getNearbyPlaces: $e");
    }
  }

}