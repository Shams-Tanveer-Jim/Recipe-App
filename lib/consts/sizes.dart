import 'package:flutter/material.dart';
import 'package:get/get.dart';

Orientation currentOrientation = MediaQuery.of(Get.context!).orientation;

var screenSize =
    currentOrientation == Orientation.portrait ? Get.height : Get.width;

class AppSizes {
  static getResponsiveSize(percentage) {
    return percentage * screenSize / 100;
  }
}
