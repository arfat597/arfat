import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studentsystem/core/class/SupabaseCrud.dart';
import 'package:studentsystem/core/class/statusRequest.dart';
import 'package:studentsystem/core/constens/Approutes.dart';
import 'package:studentsystem/core/function/showrDialog.dart';

class ResetpasswordController extends GetxController {
  String? idstudent;
  statusRequest statusRequeste = statusRequest.none;
  SupabaseCrud supabaseCrud = SupabaseCrud();
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  late TextEditingController number;
  late TextEditingController newnumber;
  resetpasswor() async {
    if (formState.currentState!.validate()) {
      if (newnumber.text == number.text) {
        statusRequeste = statusRequest.loding;
        update();
        final response = await supabaseCrud.update(
          table: "student",
          match: {"stud_id": idstudent},
          newData: {"stud_pass": number.text},
        );
        if (response.status == statusRequest.success) {
          if (response.data != null && response.data!.isNotEmpty) {
            statusRequeste = statusRequest.success;
            update();
            showLoginrDialog(
              true,
              Icons.info_outline_rounded,
              "نجحة العملية",
              "تم تغير كلمة المرور بنجاح يرجى التوجة الى صفحة تسجيل الدخول ومتابعة العملية",
              true,
              () {
                Get.offAllNamed(Approutes.login);
              },
              () {
                Get.offAllNamed(Approutes.login);
              },
            );
          }
        } else {
          print(response.error);
        }
      } else {
        showLoginrDialog(
          false,
          Icons.info_outline_rounded,
          "خطاء",
          "كلمة المرور غير متطابقة",
          true,
          () {
            Get.back();
          },
          () {
            Get.back();
          },
        );
      }
    }
  }

  @override
  void onInit() {
    idstudent = Get.arguments["stuid"];
    number = TextEditingController();
    newnumber = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    newnumber.dispose();
    number.dispose();
    super.dispose();
  }
}
