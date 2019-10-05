import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

class PlatformWidget{

  static Widget button(){
    return Platform.isAndroid ? RaisedButton(

    ) : CupertinoButton();
  }

}