import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studentsystem/core/class/SupabaseCrud.dart';
import 'package:studentsystem/core/class/statusRequest.dart';
import 'package:studentsystem/core/constens/Approutes.dart';
import 'package:studentsystem/core/function/showrDialog.dart';
import 'package:studentsystem/core/servieces/servieces.dart';

class LoginController extends GetxController {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  late TextEditingController number;
  late TextEditingController password;
  statusRequest statusRequeste = statusRequest.none;
  SupabaseCrud supabaseCrud = SupabaseCrud();
  Map? datastudent;
  Myservieces myservieces = Get.find();
  login() async {
    if (formState.currentState!.validate()) {
      statusRequeste = statusRequest.loding;
      update();
      final response = await supabaseCrud.selectWhere(
        table: "student",
        match: {
          "stud_college_num": number.text.trim(),
          "stud_pass": password.text.trim(),
        },
      );

      if (response.status == statusRequest.success) {
        if (response.data != null && response.data!.isNotEmpty) {
          datastudent = response.data!.first;
          statusRequeste = statusRequest.success;
          update();
          myservieces.sharedPref.setString(
            "id",
            response.data!.first["stud_id"].toString(),
          );
          myservieces.sharedPref.setString(
            "name",
            response.data!.first["stud_name"].toString(),
          );
          myservieces.sharedPref.setString(
            "academy_year",
            response.data!.first["id_academy_year"].toString(),
          );
          myservieces.sharedPref.setString(
            "cohort_num",
            response.data!.first["stud_cohort_num"].toString(),
          );
          myservieces.sharedPref.setString(
            "program",
            response.data!.first["id_program"].toString(),
          );
          myservieces.sharedPref.setString(
            "cheekgroup",
           "0",
          );
          myservieces.sharedPref.setString("step", "2");
          Get.offAllNamed(Approutes.home);
          update();
        } else {
          statusRequeste = statusRequest.faliure;
          update();
          showLoginrDialog(
            false,
            Icons.lock,
            "خطأ في تسجيل الدخول",
            "رقمك الجامعي أو كلمة المرور خاطئة. يرجى التحقق وإعادة المحاولة.",
            false,
            () {},
            () {
              Get.back();
            },
          );
        }
      } else {
        statusRequeste = statusRequest.faliure;
        update();
        showLoginrDialog(
          false,
          Icons.error,
          "خطأ في الاتصال",
          response.error ?? "حدث خطأ غير معروف. حاول مرة أخرى.",
          false,
          () {},
          () {
            Get.back();
          },
        );
      }
    }
  }

  gotowpage() {
    Get.toNamed(Approutes.forgetpassowrd);
  }

  @override
  void onInit() {
    number = TextEditingController();
    password = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    number.dispose();
    password.dispose();
    super.dispose();
  }
}
