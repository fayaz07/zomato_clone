import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zomato_clone/ui/location_manually.dart';
import 'package:zomato_clone/ui/splash.dart';

import 'ui/splash.dart';

void main() => runApp(ZomatoClone());

class ZomatoClone extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [],
        child: MaterialApp(
      home: SelectLocationManually(),
      theme: ThemeData(fontFamily: 'OpenSans'),
      debugShowCheckedModeBanner: false,
    ));
  }
}
