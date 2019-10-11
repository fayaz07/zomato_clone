import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

class PlatformSpecific {
  static Widget button(
      {Color color, double radius, Function onPressed, Widget child}) {
    return Platform.isAndroid
        ? RaisedButton(
            onPressed: onPressed,
            color: color,
            child: child,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius)),
          )
        : CupertinoButton(
            onPressed: onPressed,
            color: color,
            child: child,
            borderRadius: BorderRadius.circular(radius),
          );
  }

  static PageRoute route(Widget destination) {
    return Platform.isAndroid
        ? CupertinoPageRoute(builder: (BuildContext context) => destination)
        : CupertinoPageRoute(builder: (BuildContext context) => destination);
  }

  static void alertDialog(
      {BuildContext context,
      List<Widget> actions,
      Widget title,
      Widget content}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Platform.isAndroid
          ? AlertDialog(
              actions: actions,
              content: content,
              title: title,
              elevation: 8.0,
            )
          : CupertinoAlertDialog(
              actions: actions,
              content: content,
              title: title,
            ),
    );
  }

  static void bottomSheet({BuildContext context, Widget child}){
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      builder: (BuildContext context){
        return Platform.isAndroid ? Container(
          child: child,
        ) : Card(
          child: child,
        );
      }
    );
  }
}
