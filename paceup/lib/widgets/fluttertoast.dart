import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void fluttertoast(BuildContext context, String message) {
   Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Theme.of(context).primaryColor,
    textColor: Theme.of(context).textTheme.titleLarge!.color,
    fontSize: 16.0,
  );
  
}
