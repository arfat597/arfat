import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studentsystem/core/class/SupabaseCrud.dart';
import 'package:studentsystem/core/class/statusRequest.dart';
import 'package:studentsystem/core/constens/Approutes.dart';
import 'package:studentsystem/core/function/showrDialog.dart';

class ForgetpasswordController extends GetxController {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  late TextEditingController number;

  statusRequest statusRequeste = statusRequest.none;
  SupabaseCrud supabaseCrud = SupabaseCrud();

  String? idstudent;
  int? verfiyCode;

  checknum() async {
    if (!formState.currentState!.validate()) return;

    statusRequeste = statusRequest.loding;
    update();

    final response = await supabaseCrud.selectOne(
      table: "student",
      match: {"stud_college_num": number.text.trim()},
    );

    if (response.status == statusRequest.success) {
      if (response.data != null) {
        idstudent = response.data!['stud_id'].toString();
        generateFiveDigitCode();
        final response1 = await supabaseCrud.update(
          table: "student",
          match: {"stud_college_num": number.text.trim()},
          newData: {"stud_verfi_code": verfiyCode},
        );

        if (response1.status == statusRequest.success) {
          if (response1.data != null && response1.data!.isNotEmpty) {
            statusRequeste = statusRequest.success;
            update();
            Get.toNamed(Approutes.verfiyCode, arguments: {"stud": idstudent});
          } else {
            statusRequeste = statusRequest.faliure;
            update();
          }
        } else {
          statusRequeste = statusRequest.faliure;
          update();
          // print("❌ خطأ أثناء تحديث الكود: ${response1.error}");
        }
      } else {
        statusRequeste = statusRequest.faliure;
        update();
        showLoginrDialog(
          false,
          Icons.info_outline,
          "خطأ",
          "⚠️ الطالب غير موجود أو الرقم الجامعي خاطئ",
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
    }
  }

  generateFiveDigitCode() {
    final random = Random();
    verfiyCode = 10000 + random.nextInt(90000);
    return verfiyCode.toString();
  }

  @override
  void onInit() {
    number = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    number.dispose();
    super.dispose();
  }
}
