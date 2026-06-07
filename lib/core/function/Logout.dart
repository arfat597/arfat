import 'package:get/get.dart';
import 'package:studentsystem/core/constens/Approutes.dart';
import 'package:studentsystem/core/servieces/servieces.dart';

Myservieces myservieces = Get.find();

Logout() async {
  await myservieces.sharedPref.clear();
  Get.offAllNamed(Approutes.login);
}
