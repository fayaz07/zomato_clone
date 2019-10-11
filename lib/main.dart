import 'package:flutter/material.dart';
import 'package:zomato_clone/ui/splash.dart';

void main() => runApp(ZomatoClone());

class ZomatoClone extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Splash(),
      theme: ThemeData(fontFamily: 'OpenSans'),
      debugShowCheckedModeBanner: false,
    );
  }
}
