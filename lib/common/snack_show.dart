import 'package:flutter/material.dart';



class SnackShow{

  static showFailureSnack(BuildContext context, message){
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 2),
        content: Text(message)));
  }

}