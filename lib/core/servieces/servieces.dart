import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Myservieces extends GetxService {
  late SharedPreferences sharedPref;

  Future<Myservieces> init() async {
    sharedPref = await SharedPreferences.getInstance();
    return this;
  }
}

initializedservices() async {
  await Get.putAsync(() => Myservieces().init());
}
