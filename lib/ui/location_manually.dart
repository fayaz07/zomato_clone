import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zomato_clone/utils/api_requests.dart';
import 'package:zomato_clone/utils/constants.dart';
import 'package:zomato_clone/utils/data_models.dart';
import 'package:zomato_clone/utils/session_data.dart';

class SelectLocationManually extends StatefulWidget {
  @override
  _SelectLocationManuallyState createState() => _SelectLocationManuallyState();
}

class _SelectLocationManuallyState extends State<SelectLocationManually> {

  double _height, _width;

  Widget _searchSuffix = InkWell(child: SizedBox(width: 25.0));

  TextEditingController searchLocationController = TextEditingController();

  static List<PlacesModel> initialData = [];
  static StreamController streamController = StreamController<List<PlacesModel>>();
  static StreamSink sink = streamController.sink;
  static Stream stream = streamController.stream;

  @override
  Widget build(BuildContext context) {

    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    searchLocationController.addListener(searchLocationListener);

    return SafeArea(child: bottomSheetBody());
  }

  Widget bottomSheetBody() => Column(
      children: <Widget>[
        //Search bar
        Padding(
          padding:
          const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0,bottom: 5.0),
          child: Row(
            children: <Widget>[
              Text(
                'Search location',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: _height * 0.23 / 10,
                    fontWeight: FontWeight.w500),
              ),
              Expanded(child: SizedBox()),
              InkWell(
                child: Icon(Icons.close),
                onTap: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
        ),

        //Search location TextField
        Card(
          margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 3.0),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0)),
          child: SizedBox(
            height: 40.0,
            child: TextField(
              expands: false,
              autofocus: false,
              maxLines: 1,
              controller: searchLocationController,
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(top: 8.0),
                  prefixIcon: Icon(
                    Icons.search,
                    size: 24.0,
                    color: Colors.grey,
                  ),
                  suffixIcon: _searchSuffix,
                  hintText: Labels.locationSearchField,
                  border: InputBorder.none),
            ),
          ),
        ),

        //Use current location TextField
        InkWell(
          onTap: () {
//            selectCurrentLocation();
          },
          child: Padding(
            padding: const EdgeInsets.only(
                left: 10.0, right: 10.0, bottom: 10.0, top: 10.0),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.location_on,
                  color: Colors.pink,
                  size: 18.0,
                ),
                SizedBox(width: 5.0),
                Text(
                  'Use current location',
                  style: TextStyle(color: Colors.pink, fontSize: 16.0),
                ),
                Expanded(child: SizedBox()),
              ],
            ),
          ),
        ),

        Padding(
          padding:
          const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 10.0),
          child: Divider(
            thickness: 0.3,
            height: 1.0,
            color: Colors.black,
          ),
        ),

        Expanded(
          child: StreamBuilder<List<PlacesModel>>(
            stream: stream,
            initialData: initialData,
            builder: (context, snapshot) {
              return snapshot.data.runtimeType == initialData.runtimeType ?
               ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int i) {
                    return placeItem(snapshot.data[i]);
                  }
              ) : Container() ;
            }
          ),
        ),

        SizedBox(height: 5.0),
      ],
    );


  Widget placeItem(PlacesModel place) => InkWell(
    onTap: () {},
    child: Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        SizedBox(width: 15.0),
        Icon(Icons.location_on, color: Colors.grey),
        SizedBox(width: 10.0),
        Wrap(
          runAlignment: WrapAlignment.start,
          direction: Axis.vertical,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(width: 10.0),
                Text(place.main_text.trim(),
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700)),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(width: 10.0),
                Text(place.secondary_text.trim(),
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400)),
              ],
            ),
            Divider(
              height: 5.0,
              color: Colors.black,
            )
          ],
        )
      ],
    ),
  );


  void searchLocationListener() {
    String location = searchLocationController.text;
    print(location);
    if(location.length<3){
      sink.add(initialData);
    }
    else if (location.length >= 3 && location.length <= 5) {
      print("changing now");
      ApiRequests.getNearbyPlaces(location).whenComplete(() {
        sink.add(SessionData.places);
      });

    } else if (location.length >= 7) {
      print("location too long to search");
      sink.add(initialData);
    }
  }

  @override
  void dispose() {
    streamController.close();
    sink.close();
    super.dispose();
  }

}
