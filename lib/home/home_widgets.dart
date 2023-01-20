import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeWidgets {
  static Widget submitBtn() {
    return ElevatedButton(
        onPressed: () {
          Get.changeTheme(ThemeData.light());
          // Get.to(const AddItem());
          // Get.off(const AddItem());
        },
        child: const Text("Submit"));
  }
}
 
 