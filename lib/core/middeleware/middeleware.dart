

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studentsystem/core/constens/Approutes.dart';
import 'package:studentsystem/core/servieces/servieces.dart';

class Mymiddelware extends GetMiddleware {
  @override
  int? get priority => 1;
  Myservieces myservieces = Get.find();

  @override
  RouteSettings? redirect(String? route) {
    if (myservieces.sharedPref.getString("step") == "2") {
      return const RouteSettings(name: Approutes.home);
    }
    if (myservieces.sharedPref.getString("step") == "1") {
      return const RouteSettings(name: Approutes.login);
    }
    return null;
  }
}
