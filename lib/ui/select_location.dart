import 'package:flutter/material.dart';
import 'package:zomato_clone/utils/constants.dart';
import 'package:zomato_clone/utils/platform_widgets.dart';
import 'package:location/location.dart';

void main() {
  runApp(MaterialApp(home: SelectLocation()));
}

class SelectLocation extends StatefulWidget {
  @override
  _SelectLocationState createState() => _SelectLocationState();
}

class _SelectLocationState extends State<SelectLocation> {

  double _height, _width;

  Widget _searchSuffix = InkWell(child: SizedBox(width: 25.0));

  Location location = Location();
  bool hasLocationPermission;
  LocationData currLocation;

  @override
  void initState() {
    //Requesting for permissions initially
    requestLocationPermissions();
    super.initState();
  }

  void requestLocationPermissions() async {

//    Map<PermissionGroup, PermissionStatus> permissions =
//        await PermissionHandler()
//            .requestPermissions([PermissionGroup.locationWhenInUse]);

    //if (permissions[PermissionGroup.location] == PermissionStatus.granted) {
    hasLocationPermission = await location.hasPermission();
    if(hasLocationPermission){

      currLocation = await location.getLocation();
      print(currLocation.latitude);
      print(currLocation.longitude);

    } else {
      PlatformSpecific.alertDialog(
        context: context,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              child: Text('I\'M SURE', style: TextStyle(color: Colors.pink)),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              child: Text('RETRY', style: TextStyle(color: Colors.pink)),
              onTap: () {
                Navigator.of(context).pop();
                Future.delayed(Duration(milliseconds: 100)).whenComplete(() {
                  requestLocationPermissions();
                });
              },
            ),
          )
        ],
        content: Text(Labels.permissionDeniedContent),
        title: Text(Labels.permissionDeniedTitle),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        body: _getBody(),
        bottomSheet: Container(
          padding: const EdgeInsets.only(
              top: 8.0, bottom: 15.0, left: 8.0, right: 8.0),
          child: Text(
            Labels.improveUserExp,
            textAlign: TextAlign.center,
            style:
                TextStyle(fontSize: 14.0, color: Colors.black.withOpacity(0.8)),
          ),
        ),
      ),
    );
  }

  Widget _getBody() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
                height: _height * 3.5 / 10,
                child: Image.asset(
                  'assets/images/find.png',
                  fit: BoxFit.contain,
                )),
            SizedBox(height: 10.0),
            Text(Labels.hiUser,
                style: TextStyle(
                    fontSize: _height * 0.30 / 10,
                    fontWeight: FontWeight.w600)),
            SizedBox(height: 10.0),
            Text(
              Labels.setLocation,
              textAlign: TextAlign.center,
              style:
                  TextStyle(fontSize: _height * .20 / 10, color: Colors.black),
            ),
            SizedBox(height: 10.0),
            PlatformSpecific.button(
                color: Colors.pink,
                radius: 8.0,
                onPressed: () {
                  selectLocationManually();
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: SizedBox(
                    width: _width * 8.5 / 10,
                    child: Text(
                      Labels.setLocationManually,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white, fontSize: _height * 0.225 / 10),
                    ),
                  ),
                ))
          ],
        ),
      );

  void selectLocationManually() {
    PlatformSpecific.bottomSheet(
        context: context,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            //Search bar
            Padding(
              padding:
                  const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
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

            SizedBox(height: 5.0),

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
                selectCurrentLocation();
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
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Divider(
                thickness: 0.3,
                height: 1.0,
                color: Colors.black,
              ),
            ),

            Expanded(
              child: SizedBox(),
            )
          ],
        ));
  }

  void selectCurrentLocation() async {

    if(hasLocationPermission){      
      currLocation = await location.getLocation();
      print(currLocation.latitude);
      print(currLocation.longitude);
    }
    else{
      showSearchingIndicator();
      print('Requesting permissions');
      await location.requestPermission().then((value){
        if(value) {
          location.getLocation().then((LocationData ld) {
            print('Location : ${ld.latitude} ${ld.longitude}');
          });
        }
      });
    }
  }

  void showSearchingIndicator() {
    setState(() {
      _searchSuffix = SizedBox(
        width: 40.0,
        child: Padding(
          padding: const EdgeInsets.only(
              top: 12.0, bottom: 14.0, left: 18.0, right: 18.0),
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
          ),
        ),
      );
    });
  }
}
