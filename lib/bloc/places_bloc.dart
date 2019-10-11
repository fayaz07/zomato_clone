import 'package:flutter/foundation.dart';
import 'package:zomato_clone/utils/data_models.dart';

class PlacesBloc with ChangeNotifier{

  List<PlacesModel> _places = [];

  List<PlacesModel> get places => _places;

  set places(List<PlacesModel> p){
    _places = p;
    notifyListeners();
  }

  addPlace(PlacesModel place){
    places.add(place);
  }

  removePlace(PlacesModel place){
    places.remove(place);
  }

  removePlaceAtIndex(int index){
    places.removeAt(index);
  }

  clearPlaces(){
    places.clear();
  }

}