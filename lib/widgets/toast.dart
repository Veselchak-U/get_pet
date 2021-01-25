import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showErrorToast(Object error) {
  Fluttertoast.cancel();
  Fluttertoast.showToast(
    msg: error.toString(),
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.TOP,
    backgroundColor: Colors.black,
    textColor: Colors.white,
    timeInSecForIosWeb: 1,
  );
}
