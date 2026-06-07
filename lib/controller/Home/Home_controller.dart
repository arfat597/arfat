import 'package:get/get.dart';
import 'package:studentsystem/core/class/SupabaseCrud.dart';
import 'package:studentsystem/core/class/statusRequest.dart';
import 'package:studentsystem/core/servieces/servieces.dart';

class HomeController extends GetxController {
  Myservieces myservieces = Get.find();
  String? username;
  statusRequest statusRequeste = statusRequest.none;
  SupabaseCrud supabaseCrud = SupabaseCrud();
  Map<String, dynamic> data = {};
  int? percentage;
  projectstate() async {
    statusRequeste = statusRequest.loding;
    update();
    final response = await supabaseCrud.selectOne(
      table: "student_group_view",
      match: {"stud_id": myservieces.sharedPref.getString("id")},
    );
    if (response.status == statusRequest.success) {
      if (response.data != null && response.data!.isNotEmpty) {
        //idgroup = response.data!["id_program"];
        if (response.data!["group_id"] != null && response.data!.isNotEmpty) {
          data = response.data!;
          if (response.data!["group_progress"] != null &&
              response.data!.isNotEmpty) {
            double value = response.data!['group_progress'];
            percentage = (value * 100).round();
          }

          myservieces.sharedPref.setString(
            "idgroup",
            response.data!["group_id"].toString(),
          );
          // حفظ معرف قائد الفريق في الكاش
          if (response.data!["group_led_id"] != null) {
            myservieces.sharedPref.setString(
              "leaderid",
              response.data!["group_led_id"].toString(),
            );
          }
          myservieces.sharedPref.setString("cheekgroup", "1");
          statusRequeste = statusRequest.success;
          update();
        } else {
          statusRequeste = statusRequest.success;
          update();
          // لا يوجد معرف جروب
        }
      } else {}
    } else {}
  }

  @override
  void onInit() {
    username = myservieces.sharedPref.getString("name");
    projectstate();
    super.onInit();
  }
}
