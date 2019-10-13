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
  PersistentBottomSheetController _controller;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  double _height, _width;

  Widget _searchSuffix = InkWell(child: SizedBox(width: 25.0));

  Location location = Location();
  bool hasLocationPermission;
  LocationData currLocation;

  Widget placesAutoComplete = SizedBox();

  TextEditingController searchLocationController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void checkForPermissions() async {
    hasLocationPermission = await location.hasPermission();
    if (hasLocationPermission) {
      currLocation = await location.getLocation();
      print(
          "Current latlong: ${currLocation.latitude}, ${currLocation.longitude}");
    } else {
      requestLocationAccessPermission().then((permission) {
        if (permission)
          checkForPermissions();
        else
          showNoLocationPermissionDialog();
      });
    }
  }

  Future<bool> requestLocationAccessPermission() async {
    return location.requestPermission();
  }

  void showNoLocationPermissionDialog() {
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
                requestLocationAccessPermission().whenComplete(() {
                  checkForPermissions();
                });
              });
            },
          ),
        )
      ],
      content: Text(Labels.permissionDeniedContent),
      title: Text(Labels.permissionDeniedTitle),
    );
  }


  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;

    WidgetsBinding.instance.addPostFrameCallback((Duration d) {
      //Checking and requesting for location permissions initially
      checkForPermissions();
    });

    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: _getBody(),
      ),
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
                  //selectLocationManually();
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


  void selectCurrentLocation() async {
    if (hasLocationPermission) {
      currLocation = await location.getLocation();
      print(currLocation.latitude);
      print(currLocation.longitude);
    } else {
      showSearchingIndicator();
      print('Requesting permissions');
      await location.requestPermission().then((value) {
        if (value) {
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

  void hideSearchingIndicator() {
    setState(() {
      _searchSuffix = InkWell(child: SizedBox(width: 25.0));
    });
  }

  void showClearIndicator() {
    setState(() {
      _searchSuffix = InkWell(
        onTap: () {},
        child: SizedBox(
          width: 40.0,
          child: Padding(
            padding: const EdgeInsets.only(
                top: 12.0, bottom: 14.0, left: 18.0, right: 18.0),
            child: Icon(Icons.clear),
          ),
        ),
      );
    });
  }

  void hideClearIndicator() {
    setState(() {
      _searchSuffix = InkWell(child: SizedBox(width: 25.0));
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
