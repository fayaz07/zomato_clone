import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zomato_clone/bloc/places_bloc.dart';
import 'package:zomato_clone/ui/splash.dart';

import 'ui/splash.dart';

void main() => runApp(ZomatoClone());

class ZomatoClone extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PlacesBloc>.value(value: PlacesBloc())
      ],
        child: MaterialApp(
      home: Splash(),
      theme: ThemeData(fontFamily: 'OpenSans'),
      debugShowCheckedModeBanner: false,
    ));
  }
}
