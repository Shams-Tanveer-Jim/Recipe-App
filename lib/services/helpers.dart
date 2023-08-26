import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

showToast(String message, [ToastGravity gravity = ToastGravity.BOTTOM]) {
  if (message != '') {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: gravity,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.grey.shade800,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }
}

getIngredients(String ingredient) {
  var splitedIngredient = ingredient.split(" ");

  if (splitedIngredient.length > 3) {
    return [
      splitedIngredient.sublist(0, 2).join(" "),
      splitedIngredient.sublist(2).join(" ")
    ];
  } else {
    return [
      splitedIngredient.sublist(0, 1).join(" "),
      splitedIngredient.sublist(1).join(" ")
    ];
  }
}
