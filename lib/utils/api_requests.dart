import 'package:http/http.dart';

import 'constants.dart';

class ApiRequests{



  static Future<dynamic> getNearbyPlaces(String query) async {
    try{

      //Forming url
      String baseUrl = "https://maps.googleapis.com/maps/api/place/autocomplete/json?";

      baseUrl += "key=${Keys.placesAPIKey}";
      baseUrl += "&inputtype=textquery";
      baseUrl += "&input=$query";


      var response = await get(baseUrl);

      print(response.body);

    }catch(e){
      print("Caught an error- getNearbyPlaces: $e");
    }
  }

}